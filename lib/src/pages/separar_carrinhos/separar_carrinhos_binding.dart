import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';

class SepararCarrinhosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SepararCarrinhosController());
    Get.lazyPut(() => SepararCarrinhoGridController());
  }
}
