import 'package:get/get.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';

class ConferenciaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferenciaController());
  }
}
