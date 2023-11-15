import 'package:get/get.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSocketConfig extends GetxController {
  final _baseUrl = '${dotenv.env['API_SERVER']}/';
  final Rx<bool> _isConnected = false.obs;
  late IO.Socket _socket;

  @override
  void onInit() {
    initSocket();
    super.onInit();
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
      //_socket.clearListeners();
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
