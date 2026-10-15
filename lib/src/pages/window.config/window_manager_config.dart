import 'dart:ui' as ui;

import 'package:window_manager/window_manager.dart';
import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/pages/window.config/window_event.dart';

class WindowManagerConfig {
  Future<void> config() async {
    await windowManager.ensureInitialized();
    windowManager.addListener(WindowEvent());

    windowManager.waitUntilReadyToShow(_windowOptions(), () async {
      await Future.wait([
        windowManager.setPreventClose(true),
        windowManager.setMaximizable(false),
        windowManager.setMinimizable(false),
      ]);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  WindowOptions _windowOptions() {
    return WindowOptions(
      center: true,
      size: ui.Size(1250, 720),
      title: 'Expedição Estoque',
      minimumSize: ui.Size(1250, 720),
      backgroundColor: AppColor.backgroundColor,
      titleBarStyle: TitleBarStyle.normal,
      skipTaskbar: false,
    );
  }
}
