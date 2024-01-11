import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/widget/desconected_animation_icon_widget.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class LoadingSeverDialogWidget {
  static Future<void> show({
    required BuildContext context,
  }) async {
    final socket = Get.find<AppSocketConfig>();

    return await showDialog<void>(
      barrierColor: Colors.white.withOpacity(0.7),
      context: context,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (_, __) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                socket.isConnect.listen((event) {
                  if (event == true) {
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.back();
                    });
                  }
                });
              });

              return Center(
                child: Container(
                  width: 800,
                  height: 300,
                  color: Colors.transparent,
                  child: const DesconectedAnimationIconWidget(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
