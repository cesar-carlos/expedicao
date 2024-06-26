import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:app_expedicao/src/pages/window.config/window_event.dart';
import 'package:app_expedicao/src/app/app_platform.dart';

class WindowManagerConfig {
  Future<void> config() async {
    if (AppPlatform.isDesktop) {
      windowManager.waitUntilReadyToShow(_windowOptions(), () async {
        await windowManager.show();
        await windowManager.focus();
        //await windowManager.minimize();
        //await windowManager.setOpacity(0);
      });

      windowManager.addListener(WindowEvent());
      await windowManager.ensureInitialized();
      await windowManager.setPreventClose(true);
      await windowManager.setMaximizable(false);
      await windowManager.setMinimizable(false);
    }
  }

  WindowOptions _windowOptions() {
    return WindowOptions(
      center: true,
      size: ui.Size(1250, 720),
      title: 'Expedição Estoque',
      minimumSize: ui.Size(1250, 720),
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal,
      skipTaskbar: false,
    );
  }
}
