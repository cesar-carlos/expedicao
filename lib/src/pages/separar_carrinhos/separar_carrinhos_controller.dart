import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/separacao_finalizar_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class SepararCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late SepararCarrinhoGridController _separarCarrinhoGridController;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late SepararConsultaServices _separarServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();

    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarGridController = Get.find<SepararGridController>();
    _separarCarrinhoGridController = Get.find<SepararCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    _separarServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    await _fillGridSepararCarrinhos();
  }

  @override
  onReady() async {
    super.onReady();

    _evetsCarrinhoGrid();
    _liteners();
  }

  Future<void> _fillGridSepararCarrinhos() async {
    final separarCarrinhos = await _separarServices.carrinhosPercurso();
    _separarCarrinhoGridController.addAllGrid(separarCarrinhos);
    _separarCarrinhoGridController.update();
  }

  void addCarrinho(ExpedicaoCarrinhoPercursoConsultaModel model) {
    _separarCarrinhoGridController.addGrid(model);
    _separarCarrinhoGridController.update();
  }

  _evetsCarrinhoGrid() {
    _separarCarrinhoGridController.onPressedSave = (item) async {
      final itensSeparacao = await _separarServices.itensSeparacao();
      final itensSeparacaoCarrinho = itensSeparacao
          .where((el) =>
              el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
              el.codCarrinho == item.codCarrinho)
          .toList();

      if (itensSeparacaoCarrinho.isEmpty) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho vazio!',
          detail: 'Adicione itens ao carrinho para finalizar!',
        );

        return;
      }

      final carrinho = await CarrinhoServices().select(
        "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
      );

      final carrinhoPercurso =
          ExpedicaoCarrinhoPercursoModel.fromConsulta(item);

      final carrinhoPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''
                  CodEmpresa = ${item.codEmpresa}
              AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
              AND CodPercursoEstagio = ${item.codPercursoEstagio}
              AND CodCarrinho = ${item.codCarrinho}
              AND Item = ${item.item}

            ''');

      if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;
      final newCarrinho = carrinho.first.copyWith(
        situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
      );

      await CarrinhoPercursoEstagioFinalizarService(
        carrinho: newCarrinho,
        carrinhoPercurso: carrinhoPercurso,
        carrinhoPercursoEstagio: carrinhoPercursoEstagio.first,
      ).execute();

      await SeparacaoFinalizarItemService().updateAll(itensSeparacaoCarrinho);
      final newCarrinhoPercursoConsulta = item.copyWith(
        situacao: ExpedicaoSituacaoModel.separando,
      );

      _separarCarrinhoGridController.updateGrid(newCarrinhoPercursoConsulta);
      _separarCarrinhoGridController.update();
    };

    /// Cancelar carrinho
    _separarCarrinhoGridController.onPressedRemove = (item) async {
      final carrinho = await CarrinhoServices().select(
        "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
      );

      final carrinhoPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''
                CodEmpresa = ${item.codEmpresa}
              AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
              AND CodPercursoEstagio = ${item.codPercursoEstagio}
              AND CodCarrinho = ${item.codCarrinho}
              AND Item = ${item.item}

            ''');

      if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;

      await CarrinhoPercursoEstagioCancelarService(
        carrinho: carrinho.first,
        percursoEstagio: carrinhoPercursoEstagio.first,
      ).execute();

      final carrinhoPercurso = item.copyWith(
        situacao: ExpedicaoSituacaoModel.cancelada,
      );

      final newSepararItens = await _separarServices.itensSaparar();
      _separarCarrinhoGridController.updateGrid(carrinhoPercurso);
      _separarGridController.updateAllGrid(newSepararItens);
      _separarCarrinhoGridController.update();
      _separarGridController.update();
    };
  }

  _liteners() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    const uuid = Uuid();

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            if (car.codEmpresa == _processoExecutavel.codEmpresa &&
                car.origem == _processoExecutavel.origem &&
                car.codOrigem == _processoExecutavel.codOrigem) {
              _separarCarrinhoGridController.addGrid(car);
              _separarCarrinhoGridController.update();
            }
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            _separarCarrinhoGridController.updateGrid(car);
            _separarCarrinhoGridController.update();
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            _separarCarrinhoGridController.removeGrid(car);
            _separarCarrinhoGridController.update();
          }
        },
      ),
    );
  }
}
