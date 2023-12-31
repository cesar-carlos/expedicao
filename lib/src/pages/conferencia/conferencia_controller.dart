import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/conferencia_remover_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog.widget.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/service/conferencia_adicionar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/produto_service.dart';

class ConferenciaController extends GetxController {
  final RxBool _viewMode = false.obs;

  // ignore: unused_field
  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late ProdutoService _produtoService;
  // ignore: unused_field
  late ProcessoExecutavelModel _processoExecutavel;

  late ConferirGridController _conferirGridController;
  late ConferenciaCarrinhoGridController _conferenciaGridController;
  late ConferirConsultaServices _conferirConsultasServices;

  late TextEditingController quantidadeController;
  late TextEditingController displayController;
  late TextEditingController scanController;

  late FocusNode scanFocusNode;
  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;

  ConferenciaController(this.percursoEstagioConsulta);

  @override
  void onInit() {
    super.onInit();

    _produtoService = ProdutoService();
    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    _conferirGridController = Get.find<ConferirGridController>();
    _conferenciaGridController = Get.find<ConferenciaCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    scanFocusNode = FocusNode()..requestFocus();
    displayFocusNode = FocusNode();
    quantidadeFocusNode = FocusNode();

    _conferirConsultasServices = ConferirConsultaServices(
      codEmpresa: percursoEstagioConsulta.codEmpresa,
      codConferir: percursoEstagioConsulta.codOrigem,
    );

    _fillCarrinhoPercurso();
    _fillGridConferirItens();
    _fillGridConferidoItens();
  }

  @override
  void onReady() async {
    super.onReady();

    _onEditItemConferenciaGrid();
    _onRemoveItemConferenciaGrid();
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
    final params = ''' 
            CodEmpresa = ${percursoEstagioConsulta.codEmpresa} 
          AND CodEmpresa = '${percursoEstagioConsulta.codEmpresa}' 
          AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}
        
        ''';

    final carrinhosPercurso = await CarrinhoPercursoServices().select(params);
    if (carrinhosPercurso.isEmpty) return;
    _carrinhoPercurso = carrinhosPercurso.last;
  }

  Future<void> _fillGridConferirItens() async {
    final conferirItens = await _conferirConsultasServices.itensConferir();

    final conferirItensCarrinho = conferirItens
        .where((el) =>
            el.codCarrinhoPercurso ==
                percursoEstagioConsulta.codCarrinhoPercurso &&
            el.codCarrinho == percursoEstagioConsulta.codCarrinho)
        .toList();

    _conferirGridController.addAllGrid(conferirItensCarrinho);
    _conferirGridController.update();
  }

  Future<void> _fillGridConferidoItens() async {
    final conferidoItens = await _conferirConsultasServices.itensConferencia();
    final conferidoItensCarrinho = conferidoItens
        .where((el) =>
            el.codCarrinhoPercurso ==
                percursoEstagioConsulta.codCarrinhoPercurso &&
            el.itemCarrinhoPercurso == percursoEstagioConsulta.item)
        .toList();

    _conferenciaGridController.addAllGrid(conferidoItensCarrinho);
    _conferenciaGridController.update();
  }

  bool get viewMode {
    if (percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.cancelada ||
        percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.conferido) {
      _viewMode.value = true;
    }

    return _viewMode.value;
  }

  Future<void> onSubmittedScan(String? value) async {
    if (value != null) _addItemConferencia();
  }

  Future<void> onSubmittedQuantity(String? value) async {
    if (value != null) _addItemConferencia();
  }

  Future<void> _addItemConferencia() async {
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

    if (!_conferirGridController.existsBarCode(scanValue.trim()) &&
        !_conferirGridController.existsCodProduto(
            AppHelper.tryStringToIntOrZero(scanValue.trim()))) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Produto não encontrado!',
        detail: 'Este produto não esta na lista de conferencia deste carrinho!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    final resp = AppHelper.isBarCode(scanValue)
        ? await _produtoService.consultaPorCodigoBarras(scanValue.trim())
        : await _produtoService.consultaPorCodigo(int.parse(scanValue.trim()));

    //DB RESPOSE ERROR
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
          ConferenciaAdicionarItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      );

      final conferenciaItemConsulta =
          await carrinhoPercursoAdicionarItemService.add(
        codProduto: resp.right!.codProduto,
        codUnidadeMedida: resp.right!.codUnidadeMedida,
        quantidade:
            AppHelper.quantityDisplayToDouble(quantidadeController.text),
      );

      if (conferenciaItemConsulta == null) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Erro ao adicionar item!',
          detail: 'Não foi possivel conferir o item do carrinho!',
        );

        displayController.text = '';
        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      //ADD ITEM NA GRID
      displayController.text = resp.right!.nomeProduto;
      _conferenciaGridController.addGrid(conferenciaItemConsulta);
      final indexAdd = _conferirGridController
          .findIndexCodProduto(conferenciaItemConsulta.codProduto);
      _conferirGridController.setSelectedRow(indexAdd);
      _conferenciaGridController.update();
      _conferirGridController.update();

      final itemSeparar =
          _findItemConferirGrid(conferenciaItemConsulta.codProduto)!;

      _conferirGridController.updateGrid(itemSeparar.copyWith(
        quantidadeConferida: itemSeparar.quantidadeConferida +
            conferenciaItemConsulta.quantidade,
      ));

      scanController.text = '';
      quantidadeController.text = '1,000';
      scanFocusNode.requestFocus();
    }
  }

  bool validQuantitySeparate(String scanText, double value) {
    bool isBarCode = AppHelper.isBarCode(scanText);
    int? codProduto = isBarCode
        ? _conferirGridController.findcodProdutoFromBarCode(scanText.trim())
        : int.parse(scanText.trim());

    final totalConferir = _conferirGridController.totalQtdProduct(codProduto!);
    final totalSeparada =
        _conferirGridController.totalQtdProductChecked(codProduto);
    if ((totalSeparada + value) > totalConferir) return false;
    return true;
  }

  Future<void> _onEditItemConferenciaGrid() async {
    _conferenciaGridController.onPressedEditItem = (el) async {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não implementado!',
        detail: 'Não é possível editar, funcionalidade não foi implementada.',
      );
    };
  }

  Future<void> _onRemoveItemConferenciaGrid() async {
    _conferenciaGridController.onPressedRemoveItem = (el) async {
      if (viewMode) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O carrinho esta em modo de visualização..',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        context: Get.context!,
        message: 'Deseja realmente cancelar?',
        detail: 'Ao cancelar, os itens serão removido do carrinho!',
      );

      if (confirmation != null && confirmation) {
        await ConferenciaRemoverItemService(
          percursoEstagioConsulta: percursoEstagioConsulta,
        ).remove(
          item: el.item,
        );

        _conferenciaGridController.removeGrid(el);
        final itemConferir = _findItemConferirGrid(el.codProduto)!;
        _conferenciaGridController.update();
        _conferirGridController.update();

        _conferirGridController.updateGrid(itemConferir.copyWith(
          quantidadeConferida: itemConferir.quantidadeConferida - el.quantidade,
        ));
      }
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

    if (_conferenciaGridController.totalQuantity() == 0) {
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
      ConferenciaRemoverItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      ).removeAllItensCart();

      final conferenciaItemConsulta = _conferenciaGridController.itens;
      final List<ExpedicaoConferirItemConsultaModel> itensGridConferir = [];
      for (var el in conferenciaItemConsulta) {
        final itemConferir = _findItemConferirGrid(el.codProduto)!;

        itensGridConferir.add(itemConferir.copyWith(
          quantidadeConferida: 0.00,
        ));
      }

      _conferirGridController.updateAllGrid(itensGridConferir);
      _conferenciaGridController.removeAllGrid();

      _conferirGridController.update();
      _conferenciaGridController.update();
    }
  }

  Future<void> onConferirTudo() async {
    final double totalSeparar = _conferirGridController.totalQuantity();
    final double totalSeparado =
        _conferirGridController.totalQuantitySeparetion();

    if (viewMode) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não é possivel conferir tudo!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (totalSeparado >= totalSeparar) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Não existe itens para conferir!',
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
          ConferenciaAdicionarItemService(
        percursoEstagioConsulta: percursoEstagioConsulta,
      );

      LoadingProcessDialogWidget.show(
        context: Get.context!,
        process: () async {
          final response = await carrinhoPercursoAdicionarItemService.addAll();
          _conferenciaGridController.addAllGrid(response);

          final List<ExpedicaoConferirItemConsultaModel> itensGridConferir = [];
          for (var el in response) {
            final itemConferir = _findItemConferirGrid(el.codProduto)!;

            itensGridConferir.add(itemConferir.copyWith(
              quantidadeConferida:
                  itemConferir.quantidadeConferida + el.quantidade,
            ));
          }

          _conferirGridController.updateAllGrid(itensGridConferir);
          _conferenciaGridController.update();
          _conferirGridController.update();
        },
      );
    }
  }

  Future<void> onSobraCarrinho() async {}

  ExpedicaoConferirItemConsultaModel? _findItemConferirGrid(int codProduto) {
    final el = _conferirGridController.findCodProduto(codProduto);
    return el;
  }

  void _liteners() {
    const uuid = Uuid();
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final conferenciaItemEvent = ConferenciaItemEventRepository.instancia;
    final conferirItemEvent = ConferirItemEventRepository.instancia;

    final updateCarrinhoPercurso = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
          if (item.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              item.codCarrinho == percursoEstagioConsulta.codCarrinho &&
              item.situacao == ExpedicaoSituacaoModel.cancelada) {
            _viewMode.value = true;
            update();

            await ConfirmationDialogMessageWidget.show(
              context: Get.context!,
              message: 'Carrinho cancelado!',
              detail:
                  'Cancelado pelo usuario: ${item.nomeUsuarioCancelamento}!',
            );
          }
        }
      },
    );

    final updateConferirItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoConferirItemConsultaModel.fromJson(el);
          if (item.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.conferencia ==
                  percursoEstagioConsulta.origem &&
              item.codConferir == percursoEstagioConsulta.codOrigem &&
              item.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            _conferirGridController.updateGrid(item);
            _conferirGridController.update();
          }
        }
      },
    );

    final insertConferenciaItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.insert,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);
          if (item.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.conferencia ==
                  percursoEstagioConsulta.origem &&
              item.codConferir == percursoEstagioConsulta.codOrigem &&
              item.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            _conferenciaGridController.addGrid(item);
            _conferenciaGridController.update();
          }
        }
      },
    );

    final updateConferenciaItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);
          if (item.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.conferencia ==
                  percursoEstagioConsulta.origem &&
              item.codConferir == percursoEstagioConsulta.codOrigem &&
              item.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            _conferenciaGridController.addGrid(item);
            _conferenciaGridController.update();
          }
        }
      },
    );

    final deleteConferenciaItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.delete,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);
          _conferenciaGridController.removeGrid(item);
          _conferenciaGridController.update();
        }
      },
    );

    conferirItemEvent.addListener(updateConferirItem);

    carrinhoPercursoEvent.addListener(updateCarrinhoPercurso);
    conferenciaItemEvent.addListener(insertConferenciaItem);
    conferenciaItemEvent.addListener(updateConferenciaItem);
    conferenciaItemEvent.addListener(deleteConferenciaItem);

    _pageListerner.add(updateCarrinhoPercurso);
    _pageListerner.add(updateConferenciaItem);
    _pageListerner.add(insertConferenciaItem);
    _pageListerner.add(deleteConferenciaItem);
    _pageListerner.add(updateConferirItem);
  }

  void _removeliteners() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final conferenciaItemEvent = ConferenciaItemEventRepository.instancia;
    final conferirItemEvent = ConferirItemEventRepository.instancia;

    carrinhoPercursoEvent.removeListeners(_pageListerner);
    conferenciaItemEvent.removeListeners(_pageListerner);
    conferirItemEvent.removeListeners(_pageListerner);
  }
}
