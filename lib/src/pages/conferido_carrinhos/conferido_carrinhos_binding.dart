import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';

class ConferidoCarrinhosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferidoCarrinhosController());
    Get.lazyPut(() => ConferidoCarrinhoGridController());
  }
}
