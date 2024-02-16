import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';

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
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    formFocusNode.dispose();
    notConfirmationFocusNode.dispose();
    confirmationFocusNode.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(FocusNode focusNod, KeyEvent event) {
    // if (event.logicalKey == LogicalKeyboardKey.escape) {
    //   Get.find<AppEventState>()..canCloseWindow = true;
    //   Get.back(result: false);
    // }

    return KeyEventResult.ignored;
  }

  void notConfirmationOnPressed() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: false);
  }

  void confirmationOnPressed() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: true);
  }
}
