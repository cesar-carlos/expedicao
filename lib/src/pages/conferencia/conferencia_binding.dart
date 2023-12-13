import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class ConferenciaBinding implements Bindings {
  final ExpedicaoCarrinhoPercursoConsultaModel model;

  ConferenciaBinding(this.model);

  @override
  void dependencies() {
    Get.lazyPut(() => ConferenciaController(model));
    Get.lazyPut(() => ConferenciaCarrinhoGridController());
    Get.lazyPut(() => ConferirGridController());
  }
}
