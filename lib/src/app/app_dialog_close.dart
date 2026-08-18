import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';

/// Evita dois [Navigator.pop] no mesmo Enter: o [AppKeyboardListener] e o
/// [ActivateIntent] do botão focado. Sem isso, o segundo pop fecha o modal
/// de baixo.
class DialogCloseGuard {
  bool _closing = false;

  bool get isClosing => _closing;

  void close<T>({
    T? result,
    bool canCloseWindow = true,
    BuildContext? context,
  }) {
    if (_closing) return;
    _closing = true;

    if (Get.isRegistered<AppEventState>()) {
      Get.find<AppEventState>().canCloseWindow = canCloseWindow;
    }

    scheduleMicrotask(() {
      if (context != null && context.mounted) {
        Navigator.of(context).pop<T>(result);
        return;
      }

      Get.back(result: result);
    });
  }
}
