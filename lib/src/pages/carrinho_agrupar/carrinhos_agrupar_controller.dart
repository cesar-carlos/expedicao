import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_agrupar_service.dart';

class CarrinhosAgruparController extends GetxController {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  late CarrinhosAgruparGridController _carrinhosAgruparGridController;

  CarrinhosAgruparController(this.percursoEstagioConsulta);

  @override
  Future<void> onInit() async {
    _carrinhosAgruparGridController = CarrinhosAgruparGridController();
    Get.put(_carrinhosAgruparGridController);

    await _fillGridCarrinhosAgruparGrid();
    super.onInit();
  }

  Future<void> _fillGridCarrinhosAgruparGrid() async {
    final _carrinhoAgruparService = CarrinhoAgruparService(
      codEmpresa: percursoEstagioConsulta.codEmpresa,
      codCarrinhoPercurso: percursoEstagioConsulta.codCarrinhoPercurso,
    );

    final result = (await _carrinhoAgruparService.carrinhosPercurso())
        .where((el) => el.origem == percursoEstagioConsulta.origem)
        .where((el) => el.codCarrinho != percursoEstagioConsulta.codCarrinho)
        .where((el) => el.situacao == ExpedicaoSituacaoModel.conferido)
        .toList();

    _carrinhosAgruparGridController.addAllGrid(result);
    _carrinhosAgruparGridController.update();
  }

  void onAgruparTudo() {
    print('Agrupar tudo');
  }

  void onDesabruparTudo() {
    print('Desagrupar tudo');
  }
}
