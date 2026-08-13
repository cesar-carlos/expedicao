import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';

class LoadingProcessDialogGenericWidget {
  static Future<T> show<T>({
    required BuildContext context,
    required Future<T> Function() process,
    bool canCloseWindow = false,
  }) async {
    Completer<T> completer = Completer<T>();
    final appEventState = Get.find<AppEventState>();
    appEventState.canCloseWindow = canCloseWindow;

    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(builder: (_, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                T result = await process();
                if (!completer.isCompleted) {
                  completer.complete(result);
                }

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              } catch (e) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }

                Get.snackbar(
                  'Processo erro',
                  e.toString(),
                  maxWidth: 500,
                  borderRadius: 7,
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                  duration: const Duration(seconds: 15),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.only(bottom: 40),
                  mainButton: TextButton(
                    onPressed: () {
                      Get.closeCurrentSnackbar();
                      if (!completer.isCompleted) {
                        completer.completeError(e);
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );

                if (!completer.isCompleted) {
                  completer.completeError(e);
                }
              } finally {
                appEventState.canCloseWindow = true;
              }
            });

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }),
        );
      },
    );

    return completer.future;
  }
}
