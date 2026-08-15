import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_error_alert.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class CarrinhosAgruparController extends GetxController {
  late FocusNode formFocusNode;
  final RxBool _viewMode = false.obs;
  bool _processando = false;

  final ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel
      carrinhoPercursoAgrupamento;

  late CarrinhosAgruparGridController _carrinhosAgruparGridController;
  late CarrinhoPercursoEstagioAgruparService _carrinhoAgruparService;

  bool get viewMode => _viewMode.value;

  String get title => viewMode
      ? 'Visualizar - Agrupar Carrinhos'
      : 'Incluir - Agrupar Carrinhos';

  final controllerNomeCarrinho = TextEditingController();
  final controllerCodigoBarras = TextEditingController();
  final controllerCarrinhoSituacao = TextEditingController();
  final controllerScanCarrinho = TextEditingController();
  final focusScanCarrinho = FocusNode();

  CarrinhosAgruparController(this.carrinhoPercursoAgrupamento,
      [bool viewMode = false]) {
    _viewMode.value = viewMode;
  }

  @override
  void onInit() async {
    formFocusNode = FocusNode();
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

    _fillGridCarrinhosAgruparGrid();
    _evetsCarrinhoGrid();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewMode) {
        return;
      }

      if (focusScanCarrinho.canRequestFocus) {
        focusScanCarrinho.requestFocus();
      }
    });
  }

  @override
  void onClose() {
    controllerNomeCarrinho.dispose();
    controllerCodigoBarras.dispose();
    controllerCarrinhoSituacao.dispose();
    controllerScanCarrinho.dispose();
    focusScanCarrinho.dispose();
    formFocusNode.dispose();
    Get.delete<CarrinhosAgruparGridController>();
    _viewMode.close();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (_processando) {
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.find<AppEventState>().canCloseWindow = true;
        Get.back();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f7) {
        onAgruparTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f8) {
        onDesabruparTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f6) {
        onAgruparLinha();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.delete) {
        if (focusScanCarrinho.hasFocus) {
          return KeyEventResult.ignored;
        }

        onDesagruparLinha();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f4 ||
          event.logicalKey == LogicalKeyboardKey.f5 ||
          event.logicalKey == LogicalKeyboardKey.f9 ||
          event.logicalKey == LogicalKeyboardKey.f10 ||
          event.logicalKey == LogicalKeyboardKey.f12) {
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _fillGridCarrinhosAgruparGrid() async {
    final carrinhoAgruparService = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: carrinhoPercursoAgrupamento.codEmpresa,
      codCarrinhoPercurso: carrinhoPercursoAgrupamento.codCarrinhoPercurso,
    );

    final result = await carrinhoAgruparService.carrinhosPercurso(
      carrinhoPercursoAgrupamento,
    );

    final resultFiltered = result.where((el) {
      if (el.codCarrinhoAgrupador == null) return true;
      if (el.codCarrinhoAgrupador == carrinhoPercursoAgrupamento.codCarrinho) {
        return true;
      }

      return false;
    }).where((el) {
      if (el.situacao == ExpedicaoSituacaoModel.agrupado) return true;
      if (el.situacao == ExpedicaoSituacaoModel.conferido) return true;
      if (el.situacao == ExpedicaoSituacaoModel.embalando) return true;
      if (el.situacao == ExpedicaoSituacaoModel.emEntrega) return true;
      return false;
    }).where((el) {
      if (el.carrinhoAgrupador == 'S') return false;
      return true;
    }).toList();

    _carrinhosAgruparGridController.addAllGrid(resultFiltered);
    _carrinhosAgruparGridController.update();
    _carrinhosAgruparGridController.highlightFirstRow();
  }

  Future<void> onSubmittedScan(String? value) async {
    if (_processando) {
      return;
    }

    final codigoBarras = value?.trim() ?? '';
    if (codigoBarras.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite o codigo de barras do para fazer a pesquisa!',
      );

      focusScanCarrinho.requestFocus();
      controllerScanCarrinho.clear();
      return;
    }

    final carrinhoAgrupar =
        _carrinhosAgruparGridController.findCodigoBarras(codigoBarras);

    if (carrinhoAgrupar == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail:
            'Carrinho não encontrado na lista de carrinhos disponiveis para agrupamento!',
      );

      focusScanCarrinho.requestFocus();
      controllerScanCarrinho.clear();
      return;
    }

    if (carrinhoAgrupar.situacao == ExpedicaoSituacaoModel.agrupado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já agrupado!',
        detail: 'Carrinho já foi agrupado!',
      );

      focusScanCarrinho.requestFocus();
      controllerScanCarrinho.clear();
      return;
    }

    if (carrinhoAgrupar.situacao != ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho ${carrinhoAgrupar.situacao.toLowerCase()}!',
        detail:
            'Não é possível agrupar um carrinho que esteja ${carrinhoAgrupar.situacao}!',
      );

      focusScanCarrinho.requestFocus();
      controllerScanCarrinho.clear();
      return;
    }

    await _addItemGroup(carrinhoAgrupar);
    controllerScanCarrinho.clear();
    focusScanCarrinho.requestFocus();
  }

  Future<void> onAgruparTudo() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );

      return;
    }

    final itensAgrupar = _carrinhosAgruparGridController.itens
        .where((el) => el.situacao == ExpedicaoSituacaoModel.conferido)
        .where((el) => el.carrinhoAgrupador == 'N')
        .toList();

    if (itensAgrupar.isEmpty) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho para agrupar!',
        detail: 'Não existe carrinhos para serem agrupados na lista!',
      );

      return;
    }

    await _addAllItemGroup(carrinhoPercursoAgrupamento);
  }

  void onPressedCloseBar() {
    Get.find<AppEventState>().canCloseWindow = true;
    Get.back();
  }

  Future<void> onDesabruparTudo() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );

      return;
    }

    final itensAgrupar = _carrinhosAgruparGridController.itens
        .where((el) => el.situacao == ExpedicaoSituacaoModel.agrupado)
        .toList();

    if (itensAgrupar.isEmpty) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho encontrado!',
        detail: 'Não existe carrinhos para serem desagrupado na lista!',
      );

      return;
    }

    await _removeAllItemGroup(carrinhoPercursoAgrupamento);
  }

  Future<void> onAgruparLinha() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );
      return;
    }

    final item = _carrinhoParaAtalhoAgrupar();
    if (item == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Não existe carrinho conferido para agrupar.',
      );
      return;
    }

    if (item.situacao != ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho ${item.situacao.toLowerCase()}!',
        detail:
            'Não é possível agrupar um carrinho que esteja ${item.situacao}!',
      );
      return;
    }

    await _addItemGroup(item);
  }

  Future<void> onDesagruparLinha() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );
      return;
    }

    final item = _carrinhoParaAtalhoDesagrupar();
    if (item == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Não existe carrinho agrupado para desagrupar.',
      );
      return;
    }

    if (item.situacao != ExpedicaoSituacaoModel.agrupado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho ${item.situacao.toLowerCase()}!',
        detail:
            'Não é possível desagrupar um carrinho que esteja ${item.situacao}!',
      );
      return;
    }

    await _removeItemGroup(item);
  }

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel? _carrinhoParaAtalhoAgrupar() {
    final itens = _carrinhosAgruparGridController.itens;
    if (itens.isEmpty) {
      return null;
    }

    final selecionado = _carrinhosAgruparGridController.selectedItem;
    if (selecionado != null) {
      return selecionado;
    }

    final conferidos = itens.where(
      (el) => el.situacao == ExpedicaoSituacaoModel.conferido,
    );
    if (conferidos.isNotEmpty) {
      return conferidos.first;
    }

    return itens.first;
  }

  ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?
      _carrinhoParaAtalhoDesagrupar() {
    final itens = _carrinhosAgruparGridController.itens;
    if (itens.isEmpty) {
      return null;
    }

    final selecionado = _carrinhosAgruparGridController.selectedItem;
    if (selecionado != null) {
      return selecionado;
    }

    final agrupados = itens.where(
      (el) => el.situacao == ExpedicaoSituacaoModel.agrupado,
    );
    if (agrupados.isNotEmpty) {
      return agrupados.first;
    }

    return itens.first;
  }

  void _evetsCarrinhoGrid() {
    _carrinhosAgruparGridController.onPressedRemove = (item) async {
      if (item.situacao != ExpedicaoSituacaoModel.agrupado) return;
      _removeItemGroup(item);
    };

    _carrinhosAgruparGridController.onPressedGroup = (item) async {
      if (item.situacao != ExpedicaoSituacaoModel.conferido) return;
      _addItemGroup(item);
    };
  }

  Future<void> _removeItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoRemover,
  ) async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );

      return;
    }

    _processando = true;
    try {
      await LoadingProcessDialogGenericWidget.show<bool>(
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
            await MessageDialogView.show(
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
    } finally {
      _processando = false;
    }
  }

  Future<void> _removeAllItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoRemover,
  ) async {
    _processando = true;
    try {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            final result =
                await _carrinhoAgruparService.cancelarTodosAgrupamento(
              carrinhoRemover,
            );

            for (var element in result) {
              _carrinhosAgruparGridController.updateGrid(element);
            }

            _carrinhosAgruparGridController.update();
            return true;
          } on AppErrorAlert catch (err) {
            await MessageDialogView.show(
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
    } finally {
      _processando = false;
    }
  }

  Future<void> _addItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      MessageDialogView.show(
        context: Get.context!,
        message: 'Operação não permitida!',
        detail: 'Operação não permitida em modo de visualização!',
      );

      return;
    }

    _processando = true;
    try {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            await _carrinhoAgruparService.agruparCarrinho(
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
            await MessageDialogView.show(
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
    } finally {
      _processando = false;
    }
  }

  Future<void> _addAllItemGroup(
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel carrinhoAgrupar,
  ) async {
    _processando = true;
    try {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            final result = await _carrinhoAgruparService.agruparTodosCarrinho(
              carrinhoAgrupar,
            );

            for (var element in result) {
              _carrinhosAgruparGridController.updateGrid(element);
            }

            _carrinhosAgruparGridController.update();
            return true;
          } on AppErrorAlert catch (err) {
            await MessageDialogView.show(
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
    } finally {
      _processando = false;
    }
  }
}
