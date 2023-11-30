import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoadingProcessDialogWidget {
  static Future<void> show({
    required BuildContext context,
    required Future<void> Function() process,
  }) async {
    return await showDialog<void>(
      context: context,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (_, __) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                try {
                  await process();
                  Get.back();
                } catch (e) {
                  Get.back();
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
                      },
                      child: const Text('OK',
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                }
              });

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
