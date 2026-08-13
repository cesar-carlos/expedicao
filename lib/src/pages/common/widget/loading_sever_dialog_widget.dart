import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class LoadingSeverDialogWidget {
  static Future<void> show({
    required bool canCloseWindow,
    required BuildContext context,
  }) async {
    final socket = Get.find<AppSocketConfig>();
    final appEventState = Get.find<AppEventState>();
    appEventState.canCloseWindow = canCloseWindow;

    return await showDialog<void>(
      barrierDismissible: false,
      barrierColor: Colors.white.withValues(alpha: 0.7),
      context: context,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (_, _) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) async {
                  socket.isConnect.listen((event) {
                    if (event == true) {
                      Future.delayed(const Duration(seconds: 1), () {
                        appEventState.canCloseWindow = true;
                        Get.back();
                      });
                    }
                  });
                },
              );

              return Center(
                child: Container(
                  width: 800,
                  height: 300,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Conectando ao servidor...'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
