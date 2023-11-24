import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/separacao_remover_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_separacao_item_services.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/produto_service.dart';

class SeparacaoController extends GetxController {
  final RxBool _viewMode = false.obs;

  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;
  final _carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
  final _separacaoItemEvent = SeparacaoItemEventRepository.instancia;
  final List<RepositoryEventListenerModel> _listerner = [];

  late SepararGridController _separarGridController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late ProcessoExecutavelModel _processoExecutavel;

  late ProdutoService _produtoService;
  late CarrinhoSeparacaoItemServices _separacaoServices;

  late TextEditingController scanController;
  late TextEditingController quantidadeController;
  late TextEditingController displayController;

  late FocusNode scanFocusNode;
  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;

  SeparacaoController(this.percursoEstagioConsulta);

  @override
  void onInit() {
    _produtoService = ProdutoService();
    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _separarGridController = Get.find<SepararGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separacaoServices = CarrinhoSeparacaoItemServices();

    scanFocusNode = FocusNode()..requestFocus();
    displayFocusNode = FocusNode();
    quantidadeFocusNode = FocusNode();

    _fillGridSeparacaoItens();
    _onRemoveItemSeparacaoGrid();
    _listenFocusNode();
    _addLiteners();

    super.onInit();
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

  Future<void> _fillGridSeparacaoItens() async {
    final params = '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa} 
      AND CodSepararEstoque = '${percursoEstagioConsulta.codOrigem}' 
      AND CodCarrinhoPercurso = '${percursoEstagioConsulta.codCarrinhoPercurso}'
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}'
    ''';

    final separacaoItens = await _separacaoServices.consulta(params);
    _separacaoGridController.clear();
    for (var el in separacaoItens) {
      _separacaoGridController.addItem(el);
    }
  }

  bool get viewMode {
    if (percursoEstagioConsulta.situacao == 'CA') {
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
    final quantityValue = quantidadeController.text;

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

    if (quantityValue.isEmpty) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite a quantidade do produto para fazer a separação!',
      );

      quantidadeController.text = '1,000';
      quantidadeFocusNode.requestFocus();
      return;
    }

    if (!_separarGridController.findFrombarcode(scanValue.trim()) &&
        !_separarGridController.findFromCodigo(int.parse(scanValue.trim()))) {
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

    final resp = scanValue.trim().length >= 7
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
      final carrinhosPercurso = await CarrinhoPercursoServices().selectPercurso(
        ''' CodEmpresa = ${_processoExecutavel.codEmpresa} 
          AND Origem = '${_processoExecutavel.origem}' 
          AND CodOrigem = ${_processoExecutavel.codOrigem}
        
        ''',
      );

      if (carrinhosPercurso.isEmpty) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho não encontrado!',
          detail: 'Não foi encontrado nenhum carrinho para o percurso!',
        );

        displayController.text = '';
        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      final carrinhoPercursoAdicionarItemService =
          SeparacaoAdicionarItemService(
        carrinhoPercurso: carrinhosPercurso.first,
        percursoEstagioConsulta: percursoEstagioConsulta,
      );

      final separacaoItemConsulta =
          await carrinhoPercursoAdicionarItemService.add(
        codProduto: resp.right!.codProduto,
        codUnidadeMedida: resp.right!.codUnidadeMedida,
        quantidade: double.parse(
            quantidadeController.text.replaceAll('.', '').replaceAll(',', '.')),
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

      displayController.text = resp.right!.nomeProduto;
      _separacaoGridController.addItem(separacaoItemConsulta);

      scanController.text = '';
      quantidadeController.text = '1,000';
      scanFocusNode.requestFocus();
    }
  }

  Future<void> _onRemoveItemSeparacaoGrid() async {
    _separacaoGridController.onPressedRemoveItem = (el) async {
      if (viewMode) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Não é possivel remover o item!',
          detail: 'O carrinho ja foi cancelado!',
        );

        return;
      }

      await SeparacaoRemoverItemService().remove(
        codEmpresa: el.codEmpresa,
        codSepararEstoque: el.codSepararEstoque,
        item: el.item,
      );

      _separacaoGridController.removeItem(el);
    };
  }

  void _addLiteners() {
    const uuid = Uuid();

    final updateCarrinhoPercurso = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
          if (car.situacao == 'CA') {
            _viewMode.value = true;
            update();

            await ConfirmationDialogMessageWidget.show(
              context: Get.context!,
              message: 'Carrinho cancelado!',
              detail:
                  'Carrinho cancelado pelo usuario: ${car.nomeUsuarioCancelamento}!',
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
          final sep = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          _separacaoGridController.addItem(sep);
        }
      },
    );

    final deleteSeparacaoItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.delete,
      callback: (data) async {
        for (var el in data.mutation) {
          final sep = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          _separacaoGridController.removeItem(sep);
        }
      },
    );

    _carrinhoPercursoEvent.addListener(updateCarrinhoPercurso);
    _separacaoItemEvent.addListener(insertSeparacaoItem);
    _separacaoItemEvent.addListener(deleteSeparacaoItem);

    _listerner.add(updateCarrinhoPercurso);
    _listerner.add(insertSeparacaoItem);
    _listerner.add(deleteSeparacaoItem);
  }

  void _removeliteners() {
    for (var el in _listerner) {
      _carrinhoPercursoEvent.removeListener(el);
      _separacaoItemEvent.removeListener(el);
    }
  }
}
