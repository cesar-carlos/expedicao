import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/server_config/server_config_controller.dart';

class ServerConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerConfigController>(() => ServerConfigController());
  }
}
