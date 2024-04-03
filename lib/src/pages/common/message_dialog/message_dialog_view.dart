import 'package:app_expedicao/src/app/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_controller.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class MessageDialogView {
  static const double _widthForm = 380;
  static const double _heightForm = 230;

  static Future<bool?> show({
    required BuildContext context,
    required String message,
    required String detail,
    bool canCloseWindow = false,
  }) async {
    return await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final _appEventState = Get.find<AppEventState>();
        _appEventState.canCloseWindow = canCloseWindow;

        return GetBuilder<MessageDialogController>(
          init: MessageDialogController(),
          builder: (MessageDialogController controller) {
            return RawKeyboardListener(
              focusNode: controller.formFocusNode,
              onKey: controller.handleKeyEvent,
              child: Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColor.foregroundColor,
                  ),
                  child: SizedBox(
                    width: _widthForm,
                    height: _heightForm,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 15, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: _heightForm - 115,
                            child: SingleChildScrollView(
                              child: Text(detail),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonFormElement(
                                name: 'Ok',
                                padding: EdgeInsets.only(right: 5, bottom: 10),
                                focusNode: controller.okFocusNode,
                                onPressed: controller.onPressedOK,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
