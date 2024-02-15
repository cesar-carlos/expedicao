import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.find<AppEventState>()..canCloseWindow = true;
        Get.back(result: false);
      }
    }

    return KeyEventResult.ignored;
  }

  void onPressedOK() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: true);
  }
}
