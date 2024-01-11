import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/manager_config/manager_controller.dart';

class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerController>(() => ManagerController());
  }
}
