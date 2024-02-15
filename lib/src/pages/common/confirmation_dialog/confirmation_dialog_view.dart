import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_controller.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class ConfirmationDialogView {
  static const double _widthForm = 350;
  static const double _heightForm = 200;

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

        return GetBuilder<ConfirmationDialogController>(
          init: ConfirmationDialogController(),
          builder: (controller) {
            return RawKeyboardListener(
              focusNode: controller.formFocusNode,
              onKey: controller.handleKeyEvent,
              child: Dialog(
                child: Container(
                  width: _widthForm,
                  height: _heightForm,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: SizedBox.expand(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 15, top: 30),
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
                                name: 'Não',
                                padding: EdgeInsets.only(right: 5, bottom: 10),
                                focusNode: controller.notConfirmationFocusNode,
                                onPressed: controller.notConfirmationOnPressed,
                              ),
                              ButtonFormElement(
                                name: 'Sim',
                                padding: EdgeInsets.only(right: 5, bottom: 10),
                                focusNode: controller.confirmationFocusNode,
                                onPressed: controller.confirmationOnPressed,
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
