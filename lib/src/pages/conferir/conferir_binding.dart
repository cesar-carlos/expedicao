import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_binding.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_binding.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';

class ConferirBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferirController());

    ConferirCarrinhosBinding().dependencies();
    ConferidoCarrinhosBinding().dependencies();
  }
}
