import 'dart:async';

import 'package:get/get.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class AppSocketConfig extends GetxController {
  String _baseUrl = '';
  final Rx<bool> _isConnected = false.obs;
  late io.Socket _socket;
  bool _socketStarted = false;

  @override
  Future<void> onInit() async {
    await confg();
    if (_baseUrl.isNotEmpty) initSocket();
    super.onInit();
  }

  Future<void> confg() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    if (apiServerModel == null) return;

    _baseUrl = 'http://${apiServerModel.hostServer}:${apiServerModel.port}';
  }

  Rx<bool> get isConnect => _isConnected;
  io.Socket get socket => _socket;

  bool get _hasSession => _socketStarted && _socket.id != null;

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
      return await ready.future.timeout(
        timeout,
        onTimeout: () => _hasSession,
      );
    } finally {
      poll.cancel();
      await subscription.cancel();
    }
  }

  void initSocket() {
    _socketStarted = true;
    _socket = io.io(_baseUrl, <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });

    onConnect();
    onDisconnect();
    onConnectError();
    onError();
  }

  void connect() {
    _socket.connect();
  }

  void onConnect() {
    _socket.onConnect((_) {
      _isConnected.value = true;
    });
  }

  void onDisconnect() {
    _socket.onDisconnect((_) {
      _isConnected.value = false;
    });
  }

  void onConnectError() {
    _socket.onConnectError((_) {});
  }

  void onError() {
    _socket.onError((_) {});
  }

  @override
  void onClose() {
    if (_socketStarted) _socket.dispose();
    _isConnected.close();
    super.onClose();
  }
}
