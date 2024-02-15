import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_controller.dart';

class MessageDialogBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageDialogController());
  }
}
