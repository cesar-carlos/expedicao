import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/carrinhos_agrupar_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class CarrinhosAgruparBinding implements Bindings {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel model;

  CarrinhosAgruparBinding(this.model);

  @override
  void dependencies() {
    Get.lazyPut(() => CarrinhosAgruparController(model));
  }
}
