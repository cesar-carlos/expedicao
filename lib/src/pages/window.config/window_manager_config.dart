import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
import 'package:app_expedicao/src/pages/window.config/window_event.dart';
import 'package:app_expedicao/src/app/app_platform.dart';

class WindowManagerConfig {
  final WindowOptions _windowOptions = const WindowOptions(
    title: 'Expedição de Estoque',
    size: ui.Size(1300, 800),
    minimumSize: ui.Size(1300, 800),
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
    center: true,
  );

  Future<void> config() async {
    if (AppPlatform.isDesktop) {
      windowManager.waitUntilReadyToShow(_windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });

      windowManager.addListener(WindowEvent());
      await windowManager.ensureInitialized();
    }
  }
}
