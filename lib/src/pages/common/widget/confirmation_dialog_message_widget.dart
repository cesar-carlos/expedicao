import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class ConfirmationDialogMessageWidget {
  static Future<bool?> show({
    required BuildContext context,
    required String message,
    required String detail,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        final _appEventState = Get.find<AppEventState>();
        _appEventState.canCloseWindow = false;
        return Dialog(
          child: Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 15, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(detail),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonFormElement(
                          name: 'Ok',
                          padding: const EdgeInsets.only(right: 5, bottom: 10),
                          onPressed: () {
                            _appEventState.canCloseWindow = true;
                            return Navigator.of(context).pop(true);
                          },
                          focusNode: FocusNode()..requestFocus(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
