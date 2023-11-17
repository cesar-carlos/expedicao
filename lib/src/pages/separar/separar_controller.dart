import 'package:app_expedicao/src/service/carrinho_percurso_cancelar_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';

import 'package:app_expedicao/src/service/carrinho_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_estoque_consulta_services.dart';
import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/service/expedicao.estagio.service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';

class SepararController extends GetxController {
  late int codEmpresa;
  late int codSepararEstoque;

  late SepararEstoqueconsultaServices _separarServices;
  late SepararGridController _separarGridController;
  late SepararCarrinhoGridController _separarCarrinhoGridController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late ProcessoExecutavelModel _processoExecutavel;

  final _carrinhoPercursoServices = CarrinhoPercursoServices();

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
    _onRemoveItemSepararCarrinhoGrid();
    super.onInit();
  }

  Future<void> _fillGridSepararItens() async {
    final separarItens = await _separarServices.itensSaparar();
    for (var el in separarItens) {
      _separarGridController.addItem(el);
    }
  }

  Future<void> _fillGridSepararCarrinhos() async {
    final separarCarrinhos = await _separarServices.carrinhosPercurso();
    for (var el in separarCarrinhos) {
      _separarCarrinhoGridController.addItem(el);
    }
  }

  Future<void> _fillGridSeparacaoItens() async {
    final separacaoItens = await _separarServices.itensSeparacao();
    for (var el in separacaoItens) {
      _separacaoGridController.addItem(el);
    }
  }

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

      final carrinhoPercurso = await _carrinhoPercursoServices.selectPercurso(
        "CodEmpresa = ${_processoExecutavel.codEmpresa} AND Origem = '${_processoExecutavel.origem}' AND CodOrigem = ${_processoExecutavel.codOrigem}",
      );

      final estagio = await ExpedicaoEstagioService().separacao();

      await _carrinhoPercursoServices.adicionarCarrinhoPercursoService(
        carrinho: carrinho,
        carrinhoPercurso: carrinhoPercurso.first,
        percursoEstagio: estagio,
        processo: _processoExecutavel,
      );

      final separarCarrinhos = await _separarServices.carrinhosPercurso();
      _separarCarrinhoGridController.addItem(
        separarCarrinhos
            .where((el) => el.codCarrinho == carrinho.codCarrinho)
            .toList()
            .first,
      );
    }
  }

  _onRemoveItemSepararCarrinhoGrid() {
    _separarCarrinhoGridController.onPressedRemoveItem = (item) async {
      final carrinho = await CarrinhoServices().select(
        "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
      );

      final carrinhoPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''   
                  CodEmpresa = ${item.codEmpresa}
              AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
              AND CodPercursoEstagio = ${item.codPercursoEstagio}
              AND CodCarrinho = ${item.codCarrinho}
              AND Situacao = 'AB'
            ''');

      await CarrinhoPercursoCancelarService(
        carrinho: carrinho.first,
        percursoEstagio: carrinhoPercursoEstagio.first,
        processo: _processoExecutavel,
      ).execute();
    };
  }

  _litenerCarrinhoPercurso() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            _separarCarrinhoGridController.addItem(car);
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            // ignore: unused_local_variable
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            //TODO: Atualizar carrinho
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            _separarCarrinhoGridController.removeItem(car);
          }
        },
      ),
    );
  }
}
