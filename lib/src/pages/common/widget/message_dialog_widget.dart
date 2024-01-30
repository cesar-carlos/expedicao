import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

Future<void> customDialog(
  BuildContext context, {
  required String title,
  required String message,
  required bool canCloseWindow,
}) async {
  final _appEventState = Get.find<AppEventState>();
  _appEventState.canCloseWindow = canCloseWindow;

  return await showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => Dialog(
      child: Container(
        width: 320,
        height: 180,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Color(Colors.white.value),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
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
                    message,
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
                  focusNode: FocusNode()..requestFocus(),
                  onPressed: () {
                    _appEventState.canCloseWindow = true;
                    Get.back();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
