import 'dart:io';

import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';

class AppEncerrar {
  static bool _encerrando = false;

  static Future<void> agora() async {
    if (_encerrando) return;
    _encerrando = true;

    if (Get.isRegistered<AppSocketConfig>()) {
      await Get.find<AppSocketConfig>().desconectar();
    }

    await windowManager.destroy();
    exit(0);
  }
}
