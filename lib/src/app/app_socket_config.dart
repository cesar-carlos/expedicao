import 'package:get/get.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class AppSocketConfig extends GetxController {
  late String _baseUrl;
  final Rx<bool> _isConnected = false.obs;
  late io.Socket _socket;

  @override
  Future<void> onInit() async {
    await confg();
    initSocket();
    super.onInit();
  }

  Future<void> confg() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    _baseUrl = 'http://${apiServerModel!.hostServer}:${apiServerModel.port}';
  }

  Rx<bool> get isConnect => _isConnected;
  io.Socket get socket => _socket;

  void initSocket() {
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
    _socket.dispose();
    _isConnected.close();
    super.onClose();
  }
}
