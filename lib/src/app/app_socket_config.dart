import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/socket_recovery.dart';
import 'package:app_expedicao/src/app/socket_mutation_operation.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';
import 'package:app_expedicao/src/model/pagination/paged_query.dart';
import 'package:app_expedicao/src/model/pagination/pagination.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class AppSocketConfig extends GetxController {
  final io.Socket Function(String, Map<String, dynamic>) _socketFactory;

  AppSocketConfig({
    io.Socket Function(String, Map<String, dynamic>)? socketFactory,
  }) : _socketFactory =
           socketFactory ?? ((url, options) => io.io(url, options));

  static const _requestTimeout = Duration(seconds: 30);
  static const _uuid = Uuid();
  static final _connectionError = AppError(
    'Não foi possível conectar ao servidor. Verifique a rede e o endereço da API.',
  );
  static final _sessionEndedError = AppError(
    'O servidor encerrou a sessão. Reconecte para continuar.',
  );

  String _baseUrl = '';
  final Rx<bool> _isConnected = false.obs;
  final RxBool trafficPaused = false.obs;
  final RxBool sessionEndedByServer = false.obs;
  io.Socket? _socket;
  bool _socketStarted = false;
  Future<void>? _inFlightStart;
  final _listenHandlers = <String, List<void Function(dynamic)>>{};
  final _pending = <_PendingSocketRequest>[];
  bool _everConnected = false;
  late final recovery = SocketRecovery(
    canRead: () =>
        _hasSession && !trafficPaused.value && !sessionEndedByServer.value,
  );
  late final mutationOperation = SocketMutationOperation(recovery);

  /// Handshake continua sem token. Quando o servidor exigir, preencher
  /// (ex.: `{'token': token}`). Hoje **não** enviar — o servidor rejeitaria
  /// o cliente antigo se o token passasse a ser obrigatório sem migração.
  Map<String, dynamic>? handshakeAuth;

  @override
  void onInit() {
    super.onInit();
    _ensureSocketCreated();
  }

  Future<void> confg() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    if (apiServerModel == null) {
      _baseUrl = '';
      return;
    }

    _baseUrl = 'http://${apiServerModel.hostServer}:${apiServerModel.port}';
  }

  Rx<bool> get isConnect => _isConnected;
  String? get sessionId => _socket?.id;
  io.Socket get socket {
    final current = _socket;
    if (current == null) {
      throw _connectionError;
    }
    return current;
  }

  bool get _hasSession =>
      _socketStarted && _socket?.id != null && _socket?.disconnected == false;

  Future<void> _ensureSocketCreated() {
    if (_socketStarted) return Future.value();
    return _inFlightStart ??= _createSocket();
  }

  Future<void> _createSocket() async {
    try {
      await confg();
      if (_baseUrl.isEmpty || _socketStarted) return;
      initSocket();
    } finally {
      _inFlightStart = null;
    }
  }

  Future<bool> ensureStarted({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await _ensureSocketCreated();
    return waitUntilConnected(timeout: timeout);
  }

  /// Espera o handshake terminar. Sem isso, `socket.id` ainda é nulo.
  Future<bool> waitUntilConnected({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_hasSession) return true;
    if (!_socketStarted) return false;

    final ready = Completer<bool>();
    final subscription = _isConnected.listen((connected) {
      if (connected && _hasSession && !ready.isCompleted) {
        ready.complete(true);
      }
    });
    final poll = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_hasSession && !ready.isCompleted) ready.complete(true);
    });

    try {
      return await ready.future.timeout(timeout, onTimeout: () => _hasSession);
    } finally {
      poll.cancel();
      await subscription.cancel();
    }
  }

  void initSocket() {
    if (_everConnected) recovery.invalidate();
    _failPending(_connectionError);
    _socket?.dispose();
    _socketStarted = true;
    _isConnected.value = false;
    final builder = io.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .enableReconnection()
        .enableForceNew()
        .setReconnectionDelay(1000)
        .setReconnectionDelayMax(5000)
        .setTimeout(20000);
    final auth = handshakeAuth;
    if (auth != null && auth.isNotEmpty) {
      builder.setAuth(auth);
    }
    _socket = _socketFactory(_baseUrl, builder.build());

    _bindLifecycle();
    _bindPersistentListeners();
  }

  /// Para `*.consulta` e mutação e desliga auto-reconnect. Usado em
  /// `servidor.emergencia.listen` com `Acao=desconectar`.
  void pauseForServerDisconnect() {
    trafficPaused.value = true;
    _setReconnectionEnabled(false);
    _failPending(_sessionEndedError);
  }

  Future<void> reconnectAfterServerEnd() async {
    sessionEndedByServer.value = false;
    trafficPaused.value = false;
    _setReconnectionEnabled(true);
    await reconnectFromConfig();
  }

  void _setReconnectionEnabled(bool enabled) {
    final socket = _socket;
    if (socket == null) return;
    socket.io.reconnection = enabled;
    socket.io.skipReconnect = !enabled;
  }

  Future<void> reconnectFromConfig() async {
    await confg();
    if (_baseUrl.isEmpty) return;
    initSocket();
  }

  void connect() {
    _socket?.connect();
  }

  /// Envia o disconnect e espera o pacote sair antes do processo morrer.
  Future<void> desconectar() async {
    if (!_socketStarted || _socket == null || _socket!.disconnected) return;
    _failPending(_connectionError);
    _socket!.disconnect();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  void listen(String event, void Function(dynamic data) handler) {
    _listenHandlers.putIfAbsent(event, () => []).add(handler);
    _socket?.on(event, handler);
  }

  Future<Map<String, dynamic>> request({
    required String eventSuffix,
    Map<String, dynamic>? payload,
    Duration timeout = _requestTimeout,
  }) async {
    if (trafficPaused.value || sessionEndedByServer.value) {
      throw _sessionEndedError;
    }

    // Congela o pedido antes de qualquer espera pela conexão/recuperação.
    late final Map<String, dynamic> requestPayload;
    try {
      requestPayload = Map<String, dynamic>.from(
        jsonDecode(jsonEncode(payload ?? <String, dynamic>{})) as Map,
      );
    } catch (error) {
      throw AppError(
        'Parâmetros da solicitação inválidos.',
        details: error.toString(),
      );
    }
    final isMutation = requestPayload.containsKey('Mutation');
    if (isMutation) mutationOperation.checkAccess();
    final connected = await ensureStarted();
    if (isMutation) await recovery.beforeMutation();
    if (trafficPaused.value || sessionEndedByServer.value) {
      throw _sessionEndedError;
    }
    final socket = _socket;
    final session = socket?.id;
    if (!connected ||
        socket == null ||
        session == null ||
        socket.disconnected) {
      throw trafficPaused.value || sessionEndedByServer.value
          ? _sessionEndedError
          : _connectionError;
    }

    final responseIn = _uuid.v4();
    final completer = Completer<Map<String, dynamic>>();
    final event = '$session $eventSuffix';
    Timer? timer;
    var emitted = false;
    var uncertain = false;

    AppError uncertainError() {
      if (!uncertain) {
        uncertain = true;
        recovery.mutationUncertain();
      }
      return AppError(
        'Não foi possível confirmar a gravação. Ela pode ter sido aplicada no servidor. '
        'Antes de repetir, o app consultará o documento e o carrinho. '
        'Confira os dados atualizados para evitar duplicidade.',
        location: eventSuffix,
      );
    }

    late final _PendingSocketRequest pending;

    void finish() {
      timer?.cancel();
      socket.off(responseIn);
      _pending.remove(pending);
    }

    pending = _PendingSocketRequest(
      completer: completer,
      failure: (error) => isMutation && emitted ? uncertainError() : error,
      cancel: () {
        timer?.cancel();
        socket.off(responseIn);
      },
    );
    _pending.add(pending);

    timer = Timer(timeout, () {
      if (completer.isCompleted) return;
      finish();
      completer.completeError(
        isMutation && emitted
            ? uncertainError()
            : AppError('O servidor não respondeu a tempo. Tente novamente.'),
      );
    });

    socket.on(responseIn, (receiver) {
      if (completer.isCompleted) return;
      var serverError = false;
      try {
        final decoded = _decodePayload(receiver);
        if (decoded is! Map) {
          throw AppError('Resposta inválida do servidor.');
        }
        final map = Map<String, dynamic>.from(decoded);
        if ((map['Session'] != null && map['Session'] != session) ||
            (map['ResponseIn'] != null && map['ResponseIn'] != responseIn)) {
          throw AppError('Resposta não corresponde à solicitação enviada.');
        }
        if (map['Error'] != null) {
          serverError = true;
          final error = AppError.fromResponse(map);
          final mutation = requestPayload['Mutation'];
          if (isMutation &&
              ((error.identifier?.startsWith('SQL-') ?? false) ||
                  error.identifier == 'INTERNAL_ERROR' ||
                  (mutation is List && mutation.length > 1))) {
            uncertainError();
          }
          throw error;
        }
        if (isMutation && map['Mutation'] == null && map['Data'] == null) {
          throw AppError('Resposta de gravação inválida.');
        }
        if (isMutation) recovery.receivedChange();
        if (!completer.isCompleted) completer.complete(map);
      } catch (e) {
        if (!completer.isCompleted) {
          if (isMutation && !serverError) uncertainError();
          completer.completeError(AppError.fromUnknown(e));
        }
      } finally {
        finish();
      }
    });

    final body = <String, dynamic>{
      ...requestPayload,
      'Session': session,
      'ResponseIn': responseIn,
    };

    try {
      if (isMutation && recovery.blocksMutation) {
        throw AppError(
          'Os dados precisam ser atualizados. Inicie novamente a ação para consultar o estado gravado.',
        );
      }
      if (isMutation) mutationOperation.checkAccess();
      final encoded = jsonEncode(body);
      emitted = true;
      socket.emit(event, encoded);
    } catch (e) {
      finish();
      if (!completer.isCompleted) {
        completer.completeError(
          isMutation && emitted ? uncertainError() : AppError.fromUnknown(e),
        );
      }
    }

    return completer.future;
  }

  Future<List<T>> queryMapped<T>({
    required String eventSuffix,
    required QueryBuilder queryBuilder,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final query = queryBuilder.copy();
    if (query.fetchAllPages) {
      return _queryMappedAllPages(
        eventSuffix: eventSuffix,
        queryBuilder: query,
        fromJson: fromJson,
      );
    }

    return _queryMappedPage(
      eventSuffix: eventSuffix,
      queryBuilder: query,
      fromJson: fromJson,
    );
  }

  Future<List<T>> _queryMappedPage<T>({
    required String eventSuffix,
    required QueryBuilder queryBuilder,
    required T Function(Map<String, dynamic> json) fromJson,
    String? pagination,
  }) async {
    final where = queryBuilder.buildWhereList();
    final orderBy = queryBuilder.buildOrderByQuery();
    final page = pagination ?? queryBuilder.buildPagination();

    final response = await request(
      eventSuffix: eventSuffix,
      payload: {
        if (where.isNotEmpty) 'Where': where,
        if (page.isNotEmpty) 'Pagination': page,
        if (orderBy.isNotEmpty) 'OrderBy': orderBy,
      },
    );

    return _mapRows(response['Data'] ?? response['Mutation'], fromJson);
  }

  Future<List<T>> _queryMappedAllPages<T>({
    required String eventSuffix,
    required QueryBuilder queryBuilder,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    if (!await ensureStarted()) throw _connectionError;
    final querySocket = _socket;
    final querySession = sessionId;
    void ensureSameSession() {
      if (!_hasSession || _socket != querySocket || sessionId != querySession) {
        throw AppError(
          'A conexão mudou durante a consulta. Atualize os dados novamente.',
        );
      }
    }

    try {
      return await PagedQuery.collect(
        pageSize: queryBuilder.fetchPageSize,
        fetchPage: (page, pageSize) async {
          ensureSameSession();
          final pagination = Pagination(
            limit: pageSize,
            offset: (page - 1) * pageSize,
            page: page,
          ).toQueryString();

          final rows = await _queryMappedPage(
            eventSuffix: eventSuffix,
            queryBuilder: queryBuilder,
            fromJson: fromJson,
            pagination: pagination,
          );
          ensureSameSession();
          return rows;
        },
      );
    } on StateError {
      throw AppError(
        'Não foi possível carregar todos os itens. Refine o filtro e tente novamente.',
      );
    }
  }

  Future<List<T>> mutateMapped<T>({
    required String eventSuffix,
    required Object mutation,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final expected = mutation is List ? mutation.length : 1;
    final response = await request(
      eventSuffix: eventSuffix,
      payload: {'Mutation': mutation},
    );

    try {
      final rows = _mapRows(response['Mutation'] ?? response['Data'], fromJson);
      if (rows.length != expected) {
        throw AppError(
          'A resposta não confirmou todos os registros da gravação.',
        );
      }
      if (rows.isNotEmpty) mutationOperation.recorded();
      return rows;
    } catch (_) {
      recovery.mutationUncertain();
      rethrow;
    }
  }

  static List<T> _mapRows<T>(
    dynamic rows,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (rows is Map) {
      return [fromJson(Map<String, dynamic>.from(rows))];
    }
    if (rows is! List || rows.any((row) => row is! Map)) {
      throw AppError(
        'Resposta inválida do servidor: esperada uma lista de registros.',
      );
    }
    return rows
        .map((row) => fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  static dynamic _decodePayload(dynamic receiver) {
    if (receiver is String) {
      final text = receiver.trim();
      if (text.isEmpty) return receiver;
      return jsonDecode(text);
    }
    return receiver;
  }

  void _failPending(Object error) {
    if (_pending.isEmpty) return;
    final pending = List<_PendingSocketRequest>.of(_pending);
    _pending.clear();
    for (final item in pending) {
      item.cancel();
      if (!item.completer.isCompleted) {
        item.completer.completeError(item.failure(error));
      }
    }
  }

  void _bindLifecycle() {
    final socket = _socket;
    if (socket == null) return;

    socket.onConnect((_) {
      _isConnected.value = true;
      if (_everConnected &&
          !trafficPaused.value &&
          !sessionEndedByServer.value) {
        unawaited(
          recovery.refresh().catchError((Object error) {
            AppSocketListenLog.error('reconexao', error);
          }),
        );
      }
      _everConnected = true;
    });
    socket.onDisconnect((_) {
      _isConnected.value = false;
      if (_everConnected) recovery.invalidate();
      if (trafficPaused.value) {
        sessionEndedByServer.value = true;
        _failPending(_sessionEndedError);
      } else {
        _failPending(_connectionError);
      }
    });
    socket.onConnectError((_) {
      _isConnected.value = false;
    });
  }

  void _bindPersistentListeners() {
    final socket = _socket;
    if (socket == null) return;
    for (final entry in _listenHandlers.entries) {
      for (final handler in entry.value) {
        socket.on(entry.key, handler);
      }
    }
  }

  @override
  void onClose() {
    _failPending(_connectionError);
    if (_socketStarted) _socket?.dispose();
    _isConnected.close();
    super.onClose();
  }
}

class _PendingSocketRequest {
  final Completer<Map<String, dynamic>> completer;
  final void Function() cancel;
  final Object Function(Object) failure;

  _PendingSocketRequest({
    required this.completer,
    required this.cancel,
    required this.failure,
  });
}
