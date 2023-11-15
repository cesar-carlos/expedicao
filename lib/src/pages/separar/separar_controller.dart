import 'package:get/get.dart';

import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/service/adicionar_carrinho_percurso.service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_estoque_consulta_services.dart';
import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/service/expedicao.estagio.service.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class SepararController extends GetxController {
  late int codEmpresa;
  late int codSepararEstoque;

  late SepararEstoqueconsultaServices _separarServices;
  late SepararGridController _separarGridController;
  late SepararCarrinhoGridController _separarCarrinhoGridController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late ProcessoExecutavelModel _processoExecutavel;

  final _separarItens = <ExpedicaoSepararItemConsultaModel>[].obs;
  final _separarCarrinhos = <ExpedicaoPercursoConsultaModel>[].obs;
  final _separacaoItens = <ExpedicaSeparacaoItemConsultaModel>[].obs;

  @override
  onInit() async {
    _separarGridController = Get.find<SepararGridController>();
    _separarCarrinhoGridController = Get.find<SepararCarrinhoGridController>();
    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    _separarServices = SepararEstoqueconsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    await _fillGridSepararItens();
    await _fillGridSepararCarrinhos();
    await _fillGridSeparacaoItens();
    _litenerCarrinhoPercurso();
    super.onInit();
  }

  Future<void> _fillGridSepararItens() async {
    _separarItens.value = await _separarServices.itensSaparar();

    for (var el in _separarItens) {
      _separarGridController.addItem(el);
    }
  }

  Future<void> _fillGridSepararCarrinhos() async {
    _separarCarrinhos.value = await _separarServices.carrinhos();

    for (var el in _separarCarrinhos) {
      _separarCarrinhoGridController.addItem(el);
    }
  }

  Future<void> _fillGridSeparacaoItens() async {
    _separacaoItens.value = await _separarServices.itensSeparacao();

    for (var el in _separacaoItens) {
      _separacaoGridController.addItem(el);
    }
  }

  List<ExpedicaoSepararItemConsultaModel> get separarItens => _separarItens;
  List<ExpedicaSeparacaoItemConsultaModel> get separadoItens => _separacaoItens;
  List<ExpedicaoPercursoConsultaModel> get carrinhos => _separarCarrinhos;

  Future<void> addCarrinho() async {
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

      final percurso = await CarrinhoPercursoServices().selectPercurso(
        "CodEmpresa = ${_processoExecutavel.codEmpresa} AND Origem = '${_processoExecutavel.origem}' AND CodOrigem = ${_processoExecutavel.codOrigem}",
      );

      final estagio = await ExpedicaoEstagioService().separacao();
      await AdicionarCarrinhoPercursoService(
        carrinho: carrinho,
        percurso: percurso.first,
        estagio: estagio,
        processo: _processoExecutavel,
      ).execute();
    }
  }

  _litenerCarrinhoPercurso() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.insert,
        callback: (data) {
          print(data);
        },
      ),
    );
  }

  @override
  void onClose() {
    _separarItens.close();
    _separarCarrinhos.close();
    _separacaoItens.close();
    super.onClose();
  }
}
