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
      popPage<T>(
        result: result,
        context: context,
        canCloseWindow: canCloseWindow,
      );
    });
  }

  /// Fecha o `showDialog` do Navigator. `Get.back()` não serve: com snackbar
  /// aberto ele só fecha o snackbar, e com `PopScope(canPop: false)` não dá pop.
  static void popPage<T>({
    T? result,
    BuildContext? context,
    bool canCloseWindow = true,
  }) {
    if (Get.isRegistered<AppEventState>()) {
      Get.find<AppEventState>().canCloseWindow = canCloseWindow;
    }

    final ctx = context ?? Get.context;
    if (ctx != null && ctx.mounted) {
      Navigator.of(ctx).pop<T>(result);
      return;
    }

    Get.back(result: result);
  }
}
