import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/api_config/api_config_controller.dart';

class ApiConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiConfigController());
  }
}
