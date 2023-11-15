import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';

class SeparacaoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SeparacaoController());
    Get.lazyPut(() => SeparacaoCarrinhoGridController());
  }
}
