import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';

class FooterPageController extends GetxController {
  bool _isConnected = false;
  final _socket = Get.find<AppSocketConfig>();

  bool get isConnected => _isConnected;

  @override
  void onInit() {
    _linstenConnection();
    super.onInit();
  }

  _linstenConnection() {
    _socket.isConnect.listen((event) {
      _isConnected = event;
      update();
    });
  }
}
