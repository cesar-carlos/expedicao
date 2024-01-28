import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AppEventState extends GetxController {
  bool _canCloseWindow = true;

  bool get canCloseWindow => _canCloseWindow;
  void set canCloseWindow(bool value) => _canCloseWindow = value;
}
