import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';

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
  void onInit() async {
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

    _fillGridCarrinhosAgruparGrid();
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
    Get.delete<CarrinhosAgruparGridController>();
    super.onClose();
  }

  Future<void> _fillGridCarrinhosAgruparGrid() async {
    final _carrinhoAgruparService = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: carrinhoPercursoAgrupamento.codEmpresa,
      codCarrinhoPercurso: carrinhoPercursoAgrupamento.codCarrinhoPercurso,
    );

    final result = await _carrinhoAgruparService.carrinhosPercurso(
      this.carrinhoPercursoAgrupamento,
    );

    final resultFiltered = result.where((el) {
      if (el.situacao == ExpedicaoSituacaoModel.agrupado &&
          el.codCarrinhoAgrupador != carrinhoPercursoAgrupamento.codCarrinho) {
        return false;
      }

      return true;
    }).toList();

    _carrinhosAgruparGridController.addAllGrid(resultFiltered);
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

    await _addItemGroup(carrinhoAgrupar);
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
      _removeItemGroup(item);
    };

    _carrinhosAgruparGridController.onPressedGroup = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.agrupado) return;
      _addItemGroup(item);
    };
  }

  Future<void> _removeItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoRemover,
  ) async {
    await LoadingProcessDialogGenericWidget.show<bool>(
      canCloseWindow: false,
      context: Get.context!,
      process: () async {
        try {
          await _carrinhoAgruparService.cancelarAgrupamento(carrinhoRemover);

          final newCarrinhoAgrupar = carrinhoRemover.copyWith(
            situacao: ExpedicaoSituacaoModel.conferido,
          );

          _carrinhosAgruparGridController.updateGrid(newCarrinhoAgrupar);
          _carrinhosAgruparGridController.update();

          return true;
        } on AppErrorAlert catch (err) {
          await ConfirmationDialogMessageWidget.show(
            canCloseWindow: false,
            context: Get.context!,
            message: err.message,
            detail: err.details ?? '',
          );
          return false;
        } catch (err) {
          return false;
        }
      },
    );
  }

  Future<void> _addItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    await LoadingProcessDialogGenericWidget.show<bool>(
      canCloseWindow: false,
      context: Get.context!,
      process: () async {
        try {
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
          return true;
        } on AppErrorAlert catch (err) {
          await ConfirmationDialogMessageWidget.show(
            canCloseWindow: false,
            context: Get.context!,
            message: err.message,
            detail: err.details ?? '',
          );
          return false;
        } catch (err) {
          return false;
        }
      },
    );
  }
}