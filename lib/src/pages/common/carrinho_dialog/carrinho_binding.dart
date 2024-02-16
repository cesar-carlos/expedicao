import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/carrinho_dialog/carrinho_controller.dart';

class CarrinhoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarrinhoController>(() => CarrinhoController());
  }
}
