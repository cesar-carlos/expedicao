import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';

class CarrinhosAgruparController extends GetxController {
  final ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel
      carrinhoPercursoAgrupamento;

  late CarrinhosAgruparGridController _carrinhosAgruparGridController;
  late CarrinhoPercursoEstagioAgruparService _carrinhoAgruparService;

  CarrinhosAgruparController(this.carrinhoPercursoAgrupamento);

  final controllerNomeCarrinho = TextEditingController();
  final controllerCodigoBarras = TextEditingController();
  final controllerCarrinhoSituacao = TextEditingController();
  final controllerScanCarrinho = TextEditingController();

  final focusScanCarrinho = FocusNode();

  @override
  Future<void> onInit() async {
    _carrinhosAgruparGridController = CarrinhosAgruparGridController();
    Get.put(_carrinhosAgruparGridController);

    _carrinhoAgruparService = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: carrinhoPercursoAgrupamento.codEmpresa,
      codCarrinhoPercurso: carrinhoPercursoAgrupamento.codCarrinhoPercurso,
    );

    controllerNomeCarrinho.text = carrinhoPercursoAgrupamento.nomeCarrinho;
    controllerCodigoBarras.text =
        carrinhoPercursoAgrupamento.codigoBarrasCarrinho;
    controllerCarrinhoSituacao.text = carrinhoPercursoAgrupamento.situacao;
    focusScanCarrinho.requestFocus();

    await _fillGridCarrinhosAgruparGrid();
    _evetsCarrinhoGrid();
    super.onInit();
  }

  @override
  void onClose() {
    controllerNomeCarrinho.dispose();
    controllerCodigoBarras.dispose();
    controllerCarrinhoSituacao.dispose();
    controllerScanCarrinho.dispose();
    focusScanCarrinho.dispose();
    super.onClose();
  }

  Future<void> _fillGridCarrinhosAgruparGrid() async {
    final _carrinhoAgruparService = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: carrinhoPercursoAgrupamento.codEmpresa,
      codCarrinhoPercurso: carrinhoPercursoAgrupamento.codCarrinhoPercurso,
    );

    final result = (await _carrinhoAgruparService.carrinhosPercurso())
        .where((el) => el.origem == carrinhoPercursoAgrupamento.origem)
        .where(
            (el) => el.codCarrinho != carrinhoPercursoAgrupamento.codCarrinho)
        .where((el) =>
            el.situacao == ExpedicaoSituacaoModel.conferido ||
            el.situacao == ExpedicaoSituacaoModel.agrupado)
        .toList();

    _carrinhosAgruparGridController.addAllGrid(result);
    _carrinhosAgruparGridController.update();
  }

  Future<void> onSubmittedScan(String? value) async {
    if (value == null || value.isEmpty) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite o codigo de barras do para fazer a pesquisa!',
      );

      controllerScanCarrinho.clear();
      focusScanCarrinho.requestFocus();
      return;
    }

    final carrinhoAgrupar =
        _carrinhosAgruparGridController.findCodigoBarras(value);

    if (carrinhoAgrupar == null) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail:
            'Carrinho não encontrado na lista de carrinhos disponiveis para agrupamento!',
      );

      controllerScanCarrinho.clear();
      focusScanCarrinho.requestFocus();
      return;
    }

    if (carrinhoAgrupar.situacao == ExpedicaoSituacaoModel.agrupado) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já agrupado!',
        detail: 'Carrinho já foi agrupado!',
      );

      controllerScanCarrinho.clear();
      focusScanCarrinho.requestFocus();
      return;
    }

    await _addItemAgrupamento(carrinhoAgrupar);
    controllerScanCarrinho.clear();
    focusScanCarrinho.requestFocus();
  }

  void onAgruparTudo() {
    print('Agrupar tudo');
  }

  void onDesabruparTudo() {
    print('Desagrupar tudo');
  }

  _evetsCarrinhoGrid() {
    _carrinhosAgruparGridController.onPressedRemove = (item) async {
      if (item.situacao != ExpedicaoSituacaoModel.agrupado) return;

      await _carrinhoAgruparService.cancelarAgrupamento(item);

      final newCarrinhoAgrupar =
          item.copyWith(situacao: ExpedicaoSituacaoModel.conferido);

      _carrinhosAgruparGridController.updateGrid(newCarrinhoAgrupar);
      _carrinhosAgruparGridController.update();
    };

    _carrinhosAgruparGridController.onPressedGroup = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.agrupado) return;
      _addItemAgrupamento(item);
    };
  }

  Future<void> _addItemAgrupamento(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    await _carrinhoAgruparService.agruparCarrinhoPercurso(
      carrinhoPercursoAgrupamento,
      carrinhoAgrupar,
    );

    final newItemCarrinhoPercurso =
        await _carrinhoAgruparService.carrinhoPercurso(
      carrinhoAgrupar.itemCarrinhoPercurso,
    );

    _carrinhosAgruparGridController.updateGrid(newItemCarrinhoPercurso!);
    _carrinhosAgruparGridController.update();
  }
}
