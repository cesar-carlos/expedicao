import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
import 'package:app_expedicao/src/pages/window.config/window_event.dart';
import 'package:app_expedicao/src/app/app_platform.dart';

class WindowManagerConfig {
  final WindowOptions _windowOptions = const WindowOptions(
    center: true,
    size: ui.Size(1250, 720),
    title: 'Expedição de Estoque',
    minimumSize: ui.Size(1250, 720),
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  Future<void> config() async {
    if (AppPlatform.isDesktop) {
      windowManager.waitUntilReadyToShow(_windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });

      windowManager.addListener(WindowEvent());
      await windowManager.setPreventClose(true);
      await windowManager.ensureInitialized();
    }
  }
}
