import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/notfound/notfound_controller.dart';

class NotFoundBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NotFoundController>(NotFoundController());
  }
}
