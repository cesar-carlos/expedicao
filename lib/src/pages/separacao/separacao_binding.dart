import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';

class SeparacaoBinding implements Bindings {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel model;

  SeparacaoBinding(this.model);

  @override
  void dependencies() {
    Get.lazyPut(() => SeparacaoController(model));
    Get.lazyPut(() => SeparacaoCarrinhoGridController());
  }
}
