import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

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
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/produto_service.dart';

class SeparacaoController extends GetxController {
  final RxBool _viewMode = false.obs;

  // ignore: unused_field
  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late ProdutoService _produtoService;
  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late SepararConsultaServices _separarConsultasServices;

  late TextEditingController quantidadeController;
  late TextEditingController displayController;
  late TextEditingController scanController;

  late FocusNode scanFocusNode;
  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;

  SeparacaoController(this.percursoEstagioConsulta);

  get title {
    return _viewMode.value ? 'Separação - Visualização' : 'Separação - Edição';
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => SeparacaoCarrinhoGridController());

    _produtoService = ProdutoService();
    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    _separarGridController = Get.find<SepararGridController>();
    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    scanFocusNode = FocusNode()..requestFocus();
    displayFocusNode = FocusNode();
    quantidadeFocusNode = FocusNode();

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
    scanController.dispose();
    quantidadeController.dispose();
    quantidadeFocusNode.dispose();
    displayController.dispose();
    scanFocusNode.dispose();
    _viewMode.close();

    _removeliteners();

    super.onClose();
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
    final params = ''' CodEmpresa = ${percursoEstagioConsulta.codEmpresa} 
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

    final isValidQuantitySeparate = validQuantitySeparate(
      scanValue.trim(),
      AppHelper.quantityDisplayToDouble(textQuantityValue),
    );

    if (!isValidQuantitySeparate) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Quantidade invalida!',
        detail: 'A quantidade informada é maior que a quantidade a separar!',
      );

      quantidadeController.text = '1,000';
      scanController.clear();
      scanFocusNode.requestFocus();
      return;
    }

    final resp = AppHelper.isBarCode(scanValue)
        ? await _produtoService.consultaPorCodigoBarras(scanValue.trim())
        : await _produtoService.consultaPorCodigo(int.parse(scanValue.trim()));

    if (resp.left != null) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: resp.left!.title,
        detail: resp.left!.message,
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    if (resp.right != null) {
      final carrinhoPercursoAdicionarItemService =
          SeparacaoAdicionarItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      );

      final separacaoItemConsulta =
          await carrinhoPercursoAdicionarItemService.add(
        codProduto: resp.right!.codProduto,
        codUnidadeMedida: resp.right!.codUnidadeMedida,
        quantidade:
            AppHelper.quantityDisplayToDouble(quantidadeController.text),
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

      //ADD ITEM NA GRID
      displayController.text = resp.right!.nomeProduto;
      _separacaoGridController.addGrid(separacaoItemConsulta);
      final indexAdd = _separarGridController
          .findIndexCodProduto(separacaoItemConsulta.codProduto);
      _separarGridController.setSelectedRow(indexAdd);
      _separacaoGridController.update();
      _separarGridController.update();

      final itemSeparar =
          _findItemSepararGrid(separacaoItemConsulta.codProduto)!;

      _separarGridController.updateGrid(itemSeparar.copyWith(
        quantidadeSeparacao:
            itemSeparar.quantidadeSeparacao + separacaoItemConsulta.quantidade,
      ));

      scanController.text = '';
      quantidadeController.text = '1,000';
      scanFocusNode.requestFocus();
    }
  }

  bool validQuantitySeparate(String scanText, double value) {
    bool isBarCode = AppHelper.isBarCode(scanText);
    int? codProduto = isBarCode
        ? _separarGridController.findcodProdutoFromBarCode(scanText.trim())
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

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente reconferir?',
      detail: 'Ao reconferir, todos os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
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

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja separa tudo?',
      detail: 'Itens com saldo para separação serão adicionados no carrinho!',
    );

    if (confirmation != null && confirmation) {
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
