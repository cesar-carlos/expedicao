import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:window_manager/window_manager.dart';

class WindowEvent implements WindowListener {
  @override
  void onWindowBlur() {}

  @override
  void onWindowClose() async {
    final appEventState = Get.find<AppEventState>();

    if (appEventState.canCloseWindow) {
      await windowManager.destroy();
    }
  }

  @override
  void onWindowDocked() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowEvent(String eventName) {}

  @override
  void onWindowFocus() {}

  @override
  void onWindowLeaveFullScreen() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowMoved() {}

  @override
  void onWindowResize() {}

  @override
  void onWindowResized() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowUndocked() {}

  @override
  void onWindowUnmaximize() {}
}
