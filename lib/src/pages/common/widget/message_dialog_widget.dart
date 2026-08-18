import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

Future<void> customDialog(
  BuildContext context, {
  required String title,
  required String message,
  required bool canCloseWindow,
}) async {
  final appEventState = Get.find<AppEventState>();
  appEventState.canCloseWindow = canCloseWindow;

  return await showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => _CustomDialog(
      title: title,
      message: message,
    ),
  );
}

class _CustomDialog extends StatefulWidget {
  final String title;
  final String message;

  const _CustomDialog({
    required this.title,
    required this.message,
  });

  @override
  State<_CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<_CustomDialog> {
  final _formFocusNode = FocusNode();
  final _okFocusNode = FocusNode();
  final _closeGuard = DialogCloseGuard();

  @override
  void initState() {
    super.initState();
    _okFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _formFocusNode.dispose();
    _okFocusNode.dispose();
    super.dispose();
  }

  void _close() {
    _closeGuard.close(context: context);
  }

  KeyEventResult _onKey(KeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.escape ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.f12) {
        _close();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return AppKeyboardListener(
      focusNode: _formFocusNode,
      onKey: _onKey,
      child: Dialog(
        child: Container(
          width: 320,
          height: 180,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Color(Colors.white.toARGB32()),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonFormElement(
                    name: 'OK',
                    focusNode: _okFocusNode,
                    onPressed: _close,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
