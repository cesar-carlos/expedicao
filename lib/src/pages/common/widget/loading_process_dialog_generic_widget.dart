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
    final _appEventState = Get.find<AppEventState>();
    _appEventState.canCloseWindow = canCloseWindow;

    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(builder: (_, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                T result = await process();
                completer.complete(result);

                Get.back();
              } catch (e) {
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
                      Get.back();
                      completer.completeError(e);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );

                Get.back();
              } finally {
                _appEventState.canCloseWindow = true;
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
