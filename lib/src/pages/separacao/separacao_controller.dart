import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/separacao_remover_item_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_widget.dart';
import 'package:app_expedicao/src/pages/Identificacao/wedgets/Identificacao_dialog_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class SeparacaoController extends GetxController {
  final RxBool _viewMode = false.obs;

  // ignore: unused_field
  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late SepararConsultaServices _separarConsultasServices;

  late TextEditingController quantidadeController;
  late TextEditingController displayController;
  late TextEditingController scanController;

  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;
  late FocusNode scanFocusNode;

  SeparacaoController(this.percursoEstagioConsulta);

  get title {
    return _viewMode.value ? 'Separação - Visualização' : 'Separação - Edição';
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => SeparacaoCarrinhoGridController());

    _separarGridController = Get.find<SepararGridController>();
    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    scanFocusNode = FocusNode()..requestFocus();
    quantidadeFocusNode = FocusNode();
    displayFocusNode = FocusNode();

    _separarConsultasServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    _fillGridSeparacaoItens();
    _fillCarrinhoPercurso();
  }

  @override
  void onReady() async {
    super.onReady();
    _onEditItemSeparacaoGrid();
    _onRemoveItemSeparacaoGrid();
    _listenFocusNode();
    _liteners();
  }

  @override
  void onClose() {
    _viewMode.close();

    scanController.dispose();
    quantidadeController.dispose();
    displayController.dispose();

    quantidadeFocusNode.dispose();
    displayFocusNode.dispose();
    scanFocusNode.dispose();
    _removeliteners();

    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
      Get.back();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  ExpedicaoCarrinhoPercursoConsultaModel get percursoEstagio =>
      percursoEstagioConsulta;

  _listenFocusNode() {
    quantidadeFocusNode.addListener(() {
      quantidadeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantidadeController.text.length,
      );
    });

    displayFocusNode.addListener(() {
      scanFocusNode.requestFocus();
    });
  }

  Future<void> _fillCarrinhoPercurso() async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa} 
      AND CodEmpresa = '${percursoEstagioConsulta.codEmpresa}' 
      AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}
        
    ''';

    final carrinhosPercurso = await CarrinhoPercursoServices().select(params);
    if (carrinhosPercurso.isEmpty) return;
    _carrinhoPercurso = carrinhosPercurso.last;
  }

  Future<void> _fillGridSeparacaoItens() async {
    final separacaoItens = await _separarConsultasServices.itensSeparacao();

    final separacaoItensFiltrados = separacaoItens.where((el) {
      return (el.codEmpresa == percursoEstagioConsulta.codEmpresa &&
          el.codCarrinhoPercurso ==
              percursoEstagioConsulta.codCarrinhoPercurso &&
          el.itemCarrinhoPercurso == percursoEstagioConsulta.item);
    }).toList();

    _separacaoGridController.removeAllGrid();
    _separacaoGridController.addAllGrid(separacaoItensFiltrados);
    _separacaoGridController.update();
  }

  bool get viewMode {
    if (percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.cancelada ||
        percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.separado) {
      _viewMode.value = true;
    }

    return _viewMode.value;
  }

  Future<void> onSubmittedScan(String? value) async {
    if (value != null) _addItemSeparacao();
  }

  Future<void> onSubmittedQuantity(String? value) async {
    if (value != null) _addItemSeparacao();
  }

  Future<void> _addItemSeparacao() async {
    final scanValue = scanController.text;
    final textQuantityValue = quantidadeController.text;

    if (scanValue.isEmpty) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite o codigo de barras do produto para fazer a pesquisa!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      return;
    }

    if (textQuantityValue.isEmpty) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite a quantidade do produto para fazer a separação!',
      );

      quantidadeController.text = '1,000';
      quantidadeFocusNode.requestFocus();
      return;
    }

    if (!_separarGridController.existsBarCode(scanValue.trim()) &&
        !_separarGridController.existsCodProduto(
            AppHelper.tryStringToIntOrZero(scanValue.trim()))) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Produto não encontrado!',
        detail: 'Este produto não esta na lista de separação!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    final scanText = scanValue.trim();
    final scanTextIsBarCode = AppHelper.isBarCode(scanText);

    final itemSepararConsulta = scanTextIsBarCode
        ? _separarGridController.findBarCode(scanText)
        : _separarGridController.findCodProduto(int.parse(scanText));

    if (itemSepararConsulta == null) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Produto não encontrado!',
        detail: 'Este produto não esta na lista de separação!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    if (itemSepararConsulta.codSetorEstoque !=
            _processoExecutavel.codSetorEstoque &&
        itemSepararConsulta.codSetorEstoque != null &&
        _processoExecutavel.codSetorEstoque != null) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Produto fora do setor estoque!',
        detail: ' Este produto não esta no seu setor de setor estoque!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    final carrinhoPercursoAdicionarItemService = SeparacaoAdicionarItemService(
      percursoEstagioConsulta: percursoEstagioConsulta,
    );

    double qtdConfDigitada = AppHelper.qtdDisplayToDouble(
      quantidadeController.text,
    );

    double qtdConferencia = qtdConfDigitada;
    final unidadesProduto = _separarGridController
        .findUnidadesProduto(itemSepararConsulta.codProduto);

    if (unidadesProduto != null) {
      final unidadeMedida = unidadesProduto
          .where((el) => el.codigoBarras?.trim() == scanValue.trim())
          .toList()
          .firstOrNull;

      if (unidadeMedida != null) {
        if (unidadeMedida.tipoFatorConversao != 'M') {
          qtdConferencia = qtdConfDigitada / unidadeMedida.fatorConversao;
        } else {
          qtdConferencia = qtdConfDigitada * unidadeMedida.fatorConversao;
        }
      }
    }

    if ((qtdConferencia + itemSepararConsulta.quantidadeSeparacao) >
        itemSepararConsulta.quantidade) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Quantidade invalida!',
        detail:
            '''A quantidade informada ${qtdConferencia.toStringAsFixed(3)}, é maior que a quantidade a separar!''',
      );

      quantidadeController.text = '1,000';
      scanController.clear();
      scanFocusNode.requestFocus();
      return;
    }

    final separacaoItemConsulta =
        await carrinhoPercursoAdicionarItemService.add(
      codProduto: itemSepararConsulta.codProduto,
      codUnidadeMedida: itemSepararConsulta.codUnidadeMedida,
      quantidade: qtdConferencia,
    );

    if (separacaoItemConsulta == null) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Erro ao adicionar item!',
        detail: 'Não foi possivel adicionar o item ao carrinho!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    displayController.text = itemSepararConsulta.nomeProduto;
    _separacaoGridController.addGrid(separacaoItemConsulta);

    final indexAdd = _separarGridController
        .findIndexCodProduto(separacaoItemConsulta.codProduto);
    _separarGridController.setSelectedRow(indexAdd);
    _separacaoGridController.update();
    _separarGridController.update();

    final itemSeparar = _findItemSepararGrid(separacaoItemConsulta.codProduto)!;

    _separarGridController.updateGrid(itemSeparar.copyWith(
      quantidadeSeparacao:
          itemSeparar.quantidadeSeparacao + separacaoItemConsulta.quantidade,
    ));

    scanController.text = '';
    quantidadeController.text = '1,000';
    scanFocusNode.requestFocus();
  }

  bool validQuantitySeparate(String scanText, double value) {
    bool isBarCode = AppHelper.isBarCode(scanText);
    int? codProduto = isBarCode
        ? _separarGridController.findCodProdutoFromBarCode(scanText.trim())
        : int.parse(scanText.trim());

    if (codProduto == null) return false;

    final totalSeparar = _separarGridController.totalQtdProduct(codProduto);
    final totalSeparada =
        _separarGridController.totalQtdProductSeparation(codProduto);
    if ((totalSeparada + value) > totalSeparar) return false;
    return true;
  }

  Future<void> _onEditItemSeparacaoGrid() async {
    _separacaoGridController.onPressedEditItem = (el) async {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não implementado!',
        detail: 'Não é possível editar, funcionalidade não foi implementada.',
      );
    };
  }

  Future<void> _onRemoveItemSeparacaoGrid() async {
    _separacaoGridController.onPressedRemoveItem = (el) async {
      if (el.codSetorEstoque != null &&
          _processoExecutavel.codSetorEstoque != null &&
          el.codSetorEstoque != _processoExecutavel.codSetorEstoque) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O produto não esta no seu setor estoque!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        context: Get.context!,
        message: 'Deseja realmente cancelar?',
        detail: 'Ao cancelar, os itens serão removido do carrinho!',
      );

      if (confirmation == null || !confirmation) return;

      if (viewMode) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O carrinho esta em modo de visualização..',
        );

        return;
      }

      await SeparacaoRemoverItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      ).remove(
        item: el.item,
      );

      _separacaoGridController.removeGrid(el);
      final itemSeparar = _findItemSepararGrid(el.codProduto)!;
      _separacaoGridController.update();
      _separarGridController.update();

      _separarGridController.updateGrid(itemSeparar.copyWith(
        quantidadeSeparacao: itemSeparar.quantidadeSeparacao - el.quantidade,
      ));
    };
  }

  Future<void> onSepararTudo() async {
    final double totalSeparar = _separarGridController.totalQuantity();
    final double totalSeparado =
        _separarGridController.totalQuantitySeparetion();

    if (viewMode) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não é possivel separar tudo!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (totalSeparado >= totalSeparar) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não existe itens para separar!',
        detail: 'Todos os itens ja foram separados!',
      );

      return;
    }

    final confirmation = await IdentificacaoDialogWidget().show();

    if (confirmation != null) {
      final carrinhoPercursoAdicionarItemService =
          SeparacaoAdicionarItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      );

      LoadingProcessDialogWidget.show(
        context: Get.context!,
        process: () async {
          final response = await carrinhoPercursoAdicionarItemService.addAll();
          _separacaoGridController.addAllGrid(response);

          final List<ExpedicaoSepararItemConsultaModel> itensGridSeparar = [];
          for (var el in response) {
            final itemSeparar = _findItemSepararGrid(el.codProduto)!;

            itensGridSeparar.add(itemSeparar.copyWith(
              quantidadeSeparacao:
                  itemSeparar.quantidadeSeparacao + el.quantidade,
            ));
          }

          _separarGridController.updateAllGrid(itensGridSeparar);
          _separacaoGridController.update();
          _separarGridController.update();
        },
      );
    }
  }

  Future<void> onReconferirTudo() async {
    if (viewMode) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não é possivel reconferir!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (_separacaoGridController.totalQuantity() == 0) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não existe itens no carrinho!',
        detail: 'Não é possivel reconferir, pois não existe itens no carrinho!',
      );

      return;
    }

    final confirmation = await IdentificacaoDialogWidget().show();

    if (confirmation != null) {
      SeparacaoRemoverItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      ).removeAllItensCart();

      final separacaoItemConsulta = _separacaoGridController.itens;
      final List<ExpedicaoSepararItemConsultaModel> itensGridSeparar = [];
      for (var el in separacaoItemConsulta) {
        final itemSeparar = _findItemSepararGrid(el.codProduto)!;
        itensGridSeparar.add(itemSeparar.copyWith(
          quantidadeSeparacao: 0.00,
        ));
      }

      _separarGridController.updateAllGrid(itensGridSeparar);
      _separacaoGridController.removeAllGrid();
      _separacaoGridController.update();
      _separarGridController.update();
    }
  }

  ExpedicaoSepararItemConsultaModel? _findItemSepararGrid(int codProduto) {
    final el = _separarGridController.findCodProduto(codProduto);
    return el;
  }

  void _liteners() {
    const uuid = Uuid();
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final separacaoItemEvent = SeparacaoItemEventRepository.instancia;

    final updateCarrinhoPercurso = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
          if (car.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              car.codCarrinho == percursoEstagioConsulta.codCarrinho &&
              car.situacao == ExpedicaoSituacaoModel.cancelada) {
            _viewMode.value = true;
            update();

            await ConfirmationDialogMessageWidget.show(
              context: Get.context!,
              message: 'Carrinho cancelado!',
              detail: 'Cancelado pelo usuario: ${car.nomeUsuarioCancelamento}!',
            );
          }

          if (car.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              car.codCarrinho == percursoEstagioConsulta.codCarrinho &&
              car.situacao == ExpedicaoSituacaoModel.separando) {
            _viewMode.value = true;
            update();

            await ConfirmationDialogMessageWidget.show(
              context: Get.context!,
              message: 'Carrinho cancelado!',
              detail: 'Cancelado pelo usuario: ${car.nomeUsuarioCancelamento}!',
            );
          }
        }
      },
    );

    final insertSeparacaoItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.insert,
      callback: (data) async {
        for (var el in data.mutation) {
          final res = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          if (res.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.separacao ==
                  percursoEstagioConsulta.origem &&
              res.codSepararEstoque == percursoEstagioConsulta.codOrigem &&
              res.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            _separacaoGridController.addGrid(res);
            _separacaoGridController.update();
          }
        }
      },
    );

    final deleteSeparacaoItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.delete,
      callback: (data) async {
        for (var el in data.mutation) {
          final sep = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          _separacaoGridController.removeGrid(sep);
          _separacaoGridController.update();
        }
      },
    );

    carrinhoPercursoEvent.addListener(updateCarrinhoPercurso);
    separacaoItemEvent.addListener(insertSeparacaoItem);
    separacaoItemEvent.addListener(deleteSeparacaoItem);

    _pageListerner.add(updateCarrinhoPercurso);
    _pageListerner.add(insertSeparacaoItem);
    _pageListerner.add(deleteSeparacaoItem);
  }

  void _removeliteners() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final separacaoItemEvent = SeparacaoItemEventRepository.instancia;

    carrinhoPercursoEvent.removeListeners(_pageListerner);
    separacaoItemEvent.removeListeners(_pageListerner);
  }
}
