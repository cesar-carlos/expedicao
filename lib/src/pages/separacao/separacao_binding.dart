import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';

class SeparacaoBinding implements Bindings {
  final ExpedicaoCarrinhoPercursoConsultaModel model;

  SeparacaoBinding(this.model);

  @override
  void dependencies() {
    Get.put(SeparacaoController(model));
    Get.put(SeparacaoCarrinhoGridController());
    Get.put(SepararSetorGridController());
  }

  void dispose() {
    Get.delete<SeparacaoController>();
    Get.delete<SeparacaoCarrinhoGridController>();
    Get.delete<SepararSetorGridController>();
  }
}
