import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_controller.dart';

class ConfirmationDialogBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfirmationDialogController());
  }
}
