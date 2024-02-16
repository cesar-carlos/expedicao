import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';

class MessageDialogController extends GetxController {
  late FocusNode formFocusNode;
  late FocusNode okFocusNode;

  @override
  void onInit() {
    super.onInit();
    formFocusNode = FocusNode();
    okFocusNode = FocusNode()..requestFocus();
  }

  @override
  void onClose() {
    formFocusNode.dispose();
    okFocusNode.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(FocusNode focusNod, KeyEvent event) {
    // if (event.logicalKey == LogicalKeyboardKey.escape) {
    //   Get.find<AppEventState>()..canCloseWindow = true;
    //   Get.back(result: false);
    // }

    return KeyEventResult.ignored;
  }

  void onPressedOK() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: true);
  }
}
