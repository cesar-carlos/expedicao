import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class MessageDialogController extends GetxController {
  late FocusNode formFocusNode;
  late FocusNode okFocusNode;
  final _closeGuard = DialogCloseGuard();

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

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _closeGuard.close(result: false, context: formFocusNode.context);
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f12 ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        onPressedOK();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void onPressedOK() {
    _closeGuard.close(result: true, context: formFocusNode.context);
  }
}
