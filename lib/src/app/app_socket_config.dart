import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';
import 'package:app_expedicao/src/model/pagination/paged_query.dart';
import 'package:app_expedicao/src/model/pagination/pagination.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class AppSocketConfig extends GetxController {
  static const _requestTimeout = Duration(seconds: 30);
  static const _uuid = Uuid();
  static final _connectionError = AppError(
    'Não foi possível conectar ao servidor. Verifique a rede e o endereço da API.',
  );

  String _baseUrl = '';
  final Rx<bool> _isConnected = false.obs;
  io.Socket? _socket;
  bool _socketStarted = false;
  Future<void>? _inFlightStart;
  final _listenHandlers = <String, List<void Function(dynamic)>>{};
  final _pending = <_PendingSocketRequest>[];

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
    _failPending(_connectionError);
    _socket?.dispose();
    _socketStarted = true;
    _isConnected.value = false;
    _socket = io.io(
      _baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .enableForceNew()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(20000)
          .build(),
    );

    _bindLifecycle();
    _bindPersistentListeners();
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
    final connected = await ensureStarted();
    final socket = _socket;
    final session = socket?.id;
    if (!connected ||
        socket == null ||
        session == null ||
        socket.disconnected) {
      throw _connectionError;
    }

    final responseIn = _uuid.v4();
    final completer = Completer<Map<String, dynamic>>();
    final event = '$session $eventSuffix';
    Timer? timer;

    late final _PendingSocketRequest pending;

    void finish() {
      timer?.cancel();
      socket.off(responseIn);
      _pending.remove(pending);
    }

    pending = _PendingSocketRequest(
      completer: completer,
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
        AppError('O servidor não respondeu a tempo. Tente novamente.'),
      );
    });

    socket.on(responseIn, (receiver) {
      try {
        final decoded = _decodePayload(receiver);
        if (decoded is! Map) {
          throw AppError('Resposta inválida do servidor.');
        }
        final map = Map<String, dynamic>.from(decoded);
        if (map['Error'] != null) {
          throw AppError.fromResponse(map);
        }
        if (!completer.isCompleted) completer.complete(map);
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(AppError.fromUnknown(e));
        }
      } finally {
        finish();
      }
    });

    final body = <String, dynamic>{
      'Session': session,
      'ResponseIn': responseIn,
      ...?payload,
    };

    try {
      socket.emit(event, jsonEncode(body));
    } catch (e) {
      finish();
      if (!completer.isCompleted) {
        completer.completeError(AppError.fromUnknown(e));
      }
    }

    return completer.future;
  }

  Future<List<T>> queryMapped<T>({
    required String eventSuffix,
    required QueryBuilder queryBuilder,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    if (queryBuilder.fetchAllPages) {
      return _queryMappedAllPages(
        eventSuffix: eventSuffix,
        queryBuilder: queryBuilder,
        fromJson: fromJson,
      );
    }

    return _queryMappedPage(
      eventSuffix: eventSuffix,
      queryBuilder: queryBuilder,
      fromJson: fromJson,
    );
  }

  Future<List<T>> _queryMappedPage<T>({
    required String eventSuffix,
    required QueryBuilder queryBuilder,
    required T Function(Map<String, dynamic> json) fromJson,
    String? pagination,
  }) async {
    final where = queryBuilder.buildSqlWhere();
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
    try {
      return await PagedQuery.collect(
        pageSize: queryBuilder.fetchPageSize,
        fetchPage: (page, pageSize) {
          final pagination = Pagination(
            limit: pageSize,
            offset: (page - 1) * pageSize,
            page: page,
          ).toQueryString();

          return _queryMappedPage(
            eventSuffix: eventSuffix,
            queryBuilder: queryBuilder,
            fromJson: fromJson,
            pagination: pagination,
          );
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
    final response = await request(
      eventSuffix: eventSuffix,
      payload: {'Mutation': mutation},
    );

    return _mapRows(response['Mutation'] ?? response['Data'], fromJson);
  }

  static List<T> _mapRows<T>(
    dynamic rows,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (rows is Map) {
      return [fromJson(Map<String, dynamic>.from(rows))];
    }
    if (rows is! List) return [];
    return rows
        .whereType<Map>()
        .map((row) => fromJson(Map<String, dynamic>.from(row)))
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
        item.completer.completeError(error);
      }
    }
  }

  void _bindLifecycle() {
    final socket = _socket;
    if (socket == null) return;

    socket.onConnect((_) {
      _isConnected.value = true;
    });
    socket.onDisconnect((_) {
      _isConnected.value = false;
      _failPending(_connectionError);
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

  _PendingSocketRequest({required this.completer, required this.cancel});
}
