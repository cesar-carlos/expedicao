import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';

class SepararCarrinhosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SepararCarrinhosController());
  }
}
