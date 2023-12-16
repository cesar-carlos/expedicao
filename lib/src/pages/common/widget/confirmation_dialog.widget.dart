import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';

class ConfirmationDialogWidget {
  static Future<bool?> show({
    required BuildContext context,
    required String message,
    required String detail,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
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
                          name: 'Não',
                          padding: const EdgeInsets.only(right: 5, bottom: 10),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        ButtonFormElement(
                          name: 'Sim',
                          padding: const EdgeInsets.only(right: 5, bottom: 10),
                          onPressed: () => Navigator.of(context).pop(true),
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
