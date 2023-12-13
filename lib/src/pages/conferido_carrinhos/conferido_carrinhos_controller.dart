import 'package:app_expedicao/src/service/conferencia_cancelar_item_service.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_binding.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_page.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class ConferidoCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  late ExpedicaoConferirConsultaModel _conferirConsulta;
  late ConferidoCarrinhoGridController _conferidoCarrinhoGridController;

  late ConferirConsultaServices _conferirServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  //ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();

    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();

    _conferidoCarrinhoGridController =
        Get.find<ConferidoCarrinhoGridController>();

    _conferirServices = ConferirConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codConferir: _processoExecutavel.codOrigem,
    );

    await _fillGridConferidoCarrinhos();
  }

  @override
  onReady() async {
    super.onReady();

    _evetsCarrinhoGrid();
    _liteners();
  }

  Future<void> _fillGridConferidoCarrinhos() async {
    final conferidoCarrinhos = await _conferirServices.carrinhosPercurso();
    _conferidoCarrinhoGridController.addAllGrid(conferidoCarrinhos);
    _conferidoCarrinhoGridController.update();
  }

  void addCarrinho(ExpedicaoCarrinhoPercursoConsultaModel model) {
    _conferidoCarrinhoGridController.addGrid(model);
    _conferidoCarrinhoGridController.update();
  }

  _evetsCarrinhoGrid() {
    _conferidoCarrinhoGridController.onPressedEdit = (item) async {
      ConferenciaBinding(item).dependencies();
      final dialog = ConferenciaPage(item);
      await dialog.show();

      Get.delete<ConferenciaController>();
      Get.delete<ConferenciaCarrinhoGridController>();
      Get.delete<ConferirGridController>();
    };

    // _conferidoCarrinhoGridController.onPressedSave = (item) async {
    //   final itensSeparacao = await _separarServices.itensSeparacao();
    //   final itensSeparacaoCarrinho = itensSeparacao
    //       .where((el) =>
    //           el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
    //           el.codCarrinho == item.codCarrinho)
    //       .toList();

    //   if (itensSeparacaoCarrinho.isEmpty) {
    //     await ConfirmationDialogMessageWidget.show(
    //       context: Get.context!,
    //       message: 'Carrinho vazio!',
    //       detail: 'Adicione itens ao carrinho para finalizar!',
    //     );

    //     return;
    //   }

    //   final carrinho = await CarrinhoServices().select(
    //     "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
    //   );

    //   final carrinhoPercurso =
    //       ExpedicaoCarrinhoPercursoModel.fromConsulta(item);

    //   final carrinhoPercursoEstagio =
    //       await CarrinhoPercursoEstagioServices().select('''
    //               CodEmpresa = ${item.codEmpresa}
    //           AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
    //           AND CodPercursoEstagio = ${item.codPercursoEstagio}
    //           AND CodCarrinho = ${item.codCarrinho}
    //           AND Item = ${item.item}

    //         ''');

    //   if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;
    //   final newCarrinho = carrinho.first.copyWith(
    //     situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
    //   );

    //   await CarrinhoPercursoEstagioFinalizarService(
    //     carrinho: newCarrinho,
    //     carrinhoPercurso: carrinhoPercurso,
    //     carrinhoPercursoEstagio: carrinhoPercursoEstagio.first,
    //   ).execute();

    //   await SeparacaoFinalizarItemService().updateAll(itensSeparacaoCarrinho);
    //   final newCarrinhoPercursoConsulta = item.copyWith(
    //     situacao: ExpedicaoSituacaoModel.separando,
    //   );

    //   _conferidoCarrinhoGridController.updateGrid(newCarrinhoPercursoConsulta);
    //   _conferidoCarrinhoGridController.update();
    // };

    // Cancelar carrinho
    _conferidoCarrinhoGridController.onPressedRemove = (item) async {
      final carrinho = await CarrinhoServices().select(
        '''CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}''',
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
      final newCarrinho = carrinho.last.copyWith(
        situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
      );

      await CarrinhoPercursoEstagioCancelarService(
        carrinho: newCarrinho,
        percursoEstagio: carrinhoPercursoEstagio.last,
      ).execute();

      final carrinhoPercurso = item.copyWith(
        situacao: ExpedicaoSituacaoModel.cancelada,
      );

      ConferenciaCancelarItemService(
        percursoEstagioConsulta: carrinhoPercurso,
      ).cancelarAllItensCart();

      _conferidoCarrinhoGridController.updateGrid(carrinhoPercurso);
      _conferidoCarrinhoGridController.update();
    };
  }

  _liteners() {
    //   final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    //   const uuid = Uuid();

    //   carrinhoPercursoEvent.addListener(
    //     RepositoryEventListenerModel(
    //       id: uuid.v4(),
    //       event: Event.insert,
    //       callback: (data) async {
    //         for (var el in data.mutation) {
    //           final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //           if (car.codEmpresa == _processoExecutavel.codEmpresa &&
    //               car.origem == _processoExecutavel.origem &&
    //               car.codOrigem == _processoExecutavel.codOrigem) {
    //             _conferidoCarrinhoGridController.addGrid(car);
    //             _conferidoCarrinhoGridController.update();
    //           }
    //         }
    //       },
    //     ),
    //   );

    //   carrinhoPercursoEvent.addListener(
    //     RepositoryEventListenerModel(
    //       id: uuid.v4(),
    //       event: Event.update,
    //       callback: (data) async {
    //         for (var el in data.mutation) {
    //           final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //           _conferidoCarrinhoGridController.updateGrid(car);
    //           _conferidoCarrinhoGridController.update();
    //         }
    //       },
    //     ),
    //   );

    //   carrinhoPercursoEvent.addListener(
    //     RepositoryEventListenerModel(
    //       id: uuid.v4(),
    //       event: Event.delete,
    //       callback: (data) async {
    //         for (var el in data.mutation) {
    //           final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //           _conferidoCarrinhoGridController.removeGrid(car);
    //           _conferidoCarrinhoGridController.update();
    //         }
    //       },
    //     ),
    //   );
  }
}
