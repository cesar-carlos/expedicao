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
        _pop(false);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.numpad1 ||
          event.logicalKey == LogicalKeyboardKey.digit1 ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.f12) {
        _pop(true);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.numpad0 ||
          event.logicalKey == LogicalKeyboardKey.digit0) {
        _pop(false, canCloseWindow: false);
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void notConfirmationOnPressed() => _pop(false);

  void confirmationOnPressed() => _pop(true);

  void _pop(bool result, {bool canCloseWindow = true}) {
    Get.find<AppEventState>().canCloseWindow = canCloseWindow;
    final ctx = formFocusNode.context;
    if (ctx != null && ctx.mounted) {
      Navigator.of(ctx).pop(result);
      return;
    }

    final overlay = Get.overlayContext;
    if (overlay != null && overlay.mounted) {
      Navigator.of(overlay).pop(result);
      return;
    }

    Get.back(result: result);
  }
}
