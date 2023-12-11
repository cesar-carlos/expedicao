import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';

class FooterPageController extends GetxController {
  bool _isConnected = true;

  final _socket = Get.find<AppSocketConfig>();

  bool get isConnected => _isConnected;

  @override
  void onInit() {
    super.onInit();
    _linstenConnection();
  }

  _linstenConnection() {
    _socket.isConnect.listen((event) {
      _isConnected = event;
      update();
    });
  }
}
