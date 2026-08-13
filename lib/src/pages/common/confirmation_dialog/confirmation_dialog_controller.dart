import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class ConfirmationDialogController extends GetxController {
  late FocusNode formFocusNode;
  late FocusNode notConfirmationFocusNode;
  late FocusNode confirmationFocusNode;

  @override
  void onInit() {
    super.onInit();
    formFocusNode = FocusNode();
    notConfirmationFocusNode = FocusNode();
    confirmationFocusNode = FocusNode()..requestFocus();
  }


  @override
  void onClose() {
    formFocusNode.dispose();
    notConfirmationFocusNode.dispose();
    confirmationFocusNode.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.find<AppEventState>().canCloseWindow = true;
        Get.back(result: false);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.numpad1 ||
          event.logicalKey == LogicalKeyboardKey.digit1 ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        Get.find<AppEventState>().canCloseWindow = true;
        Get.back(result: true);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.numpad0 ||
          event.logicalKey == LogicalKeyboardKey.digit0) {
        Get.find<AppEventState>().canCloseWindow = false;
        Get.back(result: false);
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void notConfirmationOnPressed() {
    Get.find<AppEventState>().canCloseWindow = true;
    Get.back(result: false);
  }

  void confirmationOnPressed() {
    Get.find<AppEventState>().canCloseWindow = true;
    Get.back(result: true);
  }
}
