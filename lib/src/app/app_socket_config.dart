import 'package:get/get.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class AppSocketConfig extends GetxController {
  late String _baseUrl;
  final Rx<bool> _isConnected = false.obs;
  late IO.Socket _socket;

  @override
  Future<void> onInit() async {
    await confg();
    initSocket();
    super.onInit();
  }

  Future<void> confg() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    //_baseUrl = 'http://localhost:3001';
    _baseUrl = 'http://${apiServerModel!.hostServer}:${apiServerModel.port}';
  }

  Rx<bool> get isConnect => _isConnected;
  IO.Socket get socket => _socket;

  initSocket() {
    _socket = IO.io(_baseUrl, <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });

    onConnect();
    onDisconnect();
    onConnectError();
    onError();
  }

  connect() {
    _socket.connect();
  }

  onConnect() {
    _socket.onConnect((_) {
      _isConnected.value = true;
    });
  }

  onDisconnect() {
    _socket.onDisconnect((_) {
      _isConnected.value = false;
    });
  }

  onConnectError() {
    _socket.onConnectError((_) {});
  }

  onError() {
    _socket.onError((_) {});
  }

  @override
  void onClose() {
    _socket.dispose();
    _isConnected.close();
    super.onClose();
  }
}
