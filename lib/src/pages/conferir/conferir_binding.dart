import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';

class ConferirBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferirController());
    Get.lazyPut(() => ConferirGridController());

    Get.lazyPut(() => ConferirCarrinhosController());
    Get.lazyPut(() => ConferirCarrinhoGridController());
  }
}
