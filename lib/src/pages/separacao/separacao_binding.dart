import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';
import 'package:get/get.dart';

class SeparacaoBinding implements Bindings {
  final ExpedicaoCarrinhoPercursoConsultaModel model;

  SeparacaoBinding({required this.model});

  @override
  void dependencies() {
    Get.lazyPut(() => SeparacaoController(model));
    Get.lazyPut(() => SeparacaoCarrinhoGridController());
  }
}
