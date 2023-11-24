import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/service/expedicao.estagio.service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consulta_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class SepararController extends GetxController {
  late SepararConsultaServices _separarServices;
  late SepararGridController _separarGridController;
  late ProcessoExecutavelModel _processoExecutavel;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late SepararCarrinhosController _separarCarrinhosController;

  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  onInit() async {
    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarGridController = Get.find<SepararGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separarCarrinhosController = Get.find<SepararCarrinhosController>();

    _separarServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    await _fillGridSepararItens();
    _litenerSepararItens();
    super.onInit();
  }

  @override
  void onClose() {
    _separarGridController.dispose();
    super.onClose();
  }

  Future<void> _fillGridSepararItens() async {
    final separarItens = await _separarServices.itensSaparar();
    for (var el in separarItens) {
      _separarGridController.addItem(el);
    }
  }

  Future<void> adicionarCarrinho() async {
    final dialog = AdicionarCarrinhoDialogWidget();
    final carrinhoConsulta = await dialog.show();

    if (carrinhoConsulta != null) {
      final carrinho = ExpedicaoCarrinhoModel(
        codEmpresa: carrinhoConsulta.codEmpresa,
        codCarrinho: carrinhoConsulta.codCarrinho,
        descricao: carrinhoConsulta.descricaoCarrinho,
        ativo: carrinhoConsulta.ativo,
        codigoBarras: carrinhoConsulta.codigoBarras,
        situacao: carrinhoConsulta.situacao,
      );

      final carrinhoPercurso = await CarrinhoPercursoServices().selectPercurso(
        ''' CodEmpresa = ${_processoExecutavel.codEmpresa} 
        AND Origem = '${_processoExecutavel.origem}' 
        AND CodOrigem = ${_processoExecutavel.codOrigem}
        
        ''',
      );

      final estagio = await ExpedicaoEstagioService().separacao();

      final response = await CarrinhoPercursoAdicionarService(
        carrinho: carrinho,
        carrinhoPercurso: carrinhoPercurso.first,
        percursoEstagio: estagio,
        processo: _processoExecutavel,
      ).execute();

      if (response != null) {
        final percursoEstagioConsulta =
            await _separarServices.carrinhosPercurso()
              ..where((el) => el.item == response.item).toList();

        _separarCarrinhosController.addCarrinho(percursoEstagioConsulta.last);
      }
    }
  }

  _litenerSepararItens() {
    final carrinhoPercursoEvent = SepararItemEventRepository.instancia;
    const uuid = Uuid();

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        id: uuid.v4(),
        event: Event.update,
        allEvent: true,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoSepararItemConsultaModel.fromJson(el);
            _separarGridController.updateItem(item);
          }
        },
      ),
    );
  }
}
