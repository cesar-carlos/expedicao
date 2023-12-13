import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';

class SeparadoCarrinhosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SeparadoCarrinhosController());
    Get.lazyPut(() => SeparadoCarrinhoGridController());
  }
}
