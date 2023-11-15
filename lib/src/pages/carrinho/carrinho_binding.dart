import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/carrinho/carrinho_controller.dart';

class CarrinhoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarrinhoController>(() => CarrinhoController());
  }
}
