import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';

class ConferirCarrinhosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferirCarrinhoGridController());
    Get.lazyPut(() => ConferirCarrinhosController());
  }
}
