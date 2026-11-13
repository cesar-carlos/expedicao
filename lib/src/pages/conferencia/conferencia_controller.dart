import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/app/app_audio_helper.dart';
import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/conferencia_remover_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/identificacao_dialog_view.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_event_repository.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/service/conferencia_adicionar_item_service.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/service/cancelamento_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class ConferenciaController extends GetxController {
  bool canClose = true;

  late FocusNode formFocusNode;
  final RxBool _viewMode = false.obs;

  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  StreamSubscription<String>? _changeListListenWorker;
  bool _cartIndicatorComplit = false;
  bool _processando = false;

  late ProcessoExecutavelModel _processoExecutavel;
  late ConferirGridController _conferirGridController;
  late ConferenciaCarrinhoGridController _conferenciaGridController;
  late ConferidoCarrinhosController _conferidoCarrinhosController;
  late ConferirConsultaServices _conferirConsultasServices;

  late TabController tabController;
  late TextEditingController quantidadeController;
  late TextEditingController displayController;
  late TextEditingController scanController;

  late FocusNode scanFocusNode;
  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;

  ConferenciaController(this.percursoEstagioConsulta);

  String get title {
    return _viewMode.value
        ? 'Conferencia - Visualização'
        : 'Conferencia - Edição';
  }

  String get fullCartName {
    return '${percursoEstagioConsulta.codCarrinho} - ${percursoEstagioConsulta.nomeCarrinho}';
  }

  String get displaySituacao {
    return percursoEstagioConsulta.situacao;
  }

  set setSituacao(String situacao) {
    percursoEstagioConsulta.situacao = situacao;
  }

  Color get colorIndicator {
    switch (percursoEstagioConsulta.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        return Colors.red;
      case ExpedicaoSituacaoModel.conferindo:
        return isComplitCart ? Colors.green : Colors.orange;
      case ExpedicaoSituacaoModel.conferido:
      case ExpedicaoSituacaoModel.agrupado:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  bool get isComplitCart {
    return _conferirGridController.isCompliteCart(
      percursoEstagioConsulta.codCarrinho,
    );
  }

  void _syncCartIndicator() {
    final complit = isComplitCart;
    if (complit == _cartIndicatorComplit) {
      return;
    }
    _cartIndicatorComplit = complit;
    update();
  }

  @override
  onInit() {
    super.onInit();
    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    Get.lazyPut(() => ConferirGridController());
    Get.lazyPut(() => ConferenciaCarrinhoGridController());

    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _conferirGridController = Get.find<ConferirGridController>();
    _conferenciaGridController = Get.find<ConferenciaCarrinhoGridController>();
    _conferidoCarrinhosController = Get.find<ConferidoCarrinhosController>();

    scanFocusNode = FocusNode();
    quantidadeFocusNode = FocusNode();
    displayFocusNode = FocusNode();
    formFocusNode = FocusNode();

    _conferirConsultasServices = ConferirConsultaServices(
      codEmpresa: percursoEstagioConsulta.codEmpresa,
      codConferir: percursoEstagioConsulta.codOrigem,
    );
  }

  @override
  void onReady() async {
    super.onReady();

    await Future.wait([
      _fillGridConferirItens(),
      _fillGridConferidoItens(),
    ]);

    if (_viewMode.value) {
      formFocusNode.requestFocus();
    } else {
      scanFocusNode.requestFocus();
    }

    _onEditItemConferenciaGrid();
    _onRemoveItemConferenciaGrid();
    _listenFocusNode();
    _liteners();

    _cartIndicatorComplit = isComplitCart;
    _changeListListenWorker = _conferirGridController.changeListListen.listen((
      _,
    ) {
      _syncCartIndicator();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCartIndicator();
    });
  }

  @override
  void onClose() {
    // Cancelar o listener antes de deletar o controller
    _changeListListenWorker?.cancel();

    // Remover listeners de eventos
    _removeliteners();

    // Fechar RxBool
    _viewMode.close();

    // Dispose dos controllers e focus nodes
    scanController.dispose();
    quantidadeController.dispose();
    quantidadeFocusNode.dispose();
    displayController.dispose();
    scanFocusNode.dispose();
    formFocusNode.dispose();

    // Deletar controllers do GetX (isso já chama onClose() automaticamente)
    Get.delete<ConferirGridController>();
    Get.delete<ConferenciaCarrinhoGridController>();
    Get.delete<ConferenciaController>();

    Get.find<AppEventState>().canCloseWindow = true;

    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (_processando) {
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f7) {
        onConferirTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f8) {
        onReconferirTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f12) {
        onSaveCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.escape) {
        DialogCloseGuard.popPage();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  ExpedicaoCarrinhoPercursoEstagioConsultaModel get percursoEstagio =>
      percursoEstagioConsulta;

  void onPressedCloseBar() {
    if (canClose) DialogCloseGuard.popPage();
  }

  void _listenFocusNode() {
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

  Future<void> _fillGridConferirItens() async {
    final conferirItens = await _conferirConsultasServices.itensConferir(
      codCarrinho: percursoEstagioConsulta.codCarrinho,
    );

    final conferirItensInids = await _conferirConsultasServices
        .itensConferirUnidades();

    final conferirItensCarrinho = conferirItens
        .where(
          (el) =>
              el.codCarrinhoPercurso ==
                  percursoEstagioConsulta.codCarrinhoPercurso &&
              el.codCarrinho == percursoEstagioConsulta.codCarrinho,
        )
        .toList();

    _conferirGridController.addAllGrid(conferirItensCarrinho);
    _conferirGridController.addAllUnidade(conferirItensInids);
  }

  Future<void> _fillGridConferidoItens() async {
    final conferidoItens = await _conferirConsultasServices.itensConferencia(
      codCarrinho: percursoEstagioConsulta.codCarrinho,
    );

    final conferidoItensCarrinho = conferidoItens
        .where(
          (el) =>
              el.codCarrinhoPercurso ==
                  percursoEstagioConsulta.codCarrinhoPercurso &&
              AppHelper.sameGridItem(
                el.itemCarrinhoPercurso,
                percursoEstagioConsulta.item,
              ),
        )
        .toList();

    _conferenciaGridController.addAllGrid(conferidoItensCarrinho);
  }

  bool get viewMode {
    if (percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.cancelada ||
        percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.conferido ||
        percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.agrupado) {
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
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite o codigo de barras do produto para fazer a pesquisa!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      return;
    }

    if (textQuantityValue.isEmpty) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Valor invalido!',
        detail: 'Digite a quantidade do produto para fazer a separação!',
      );

      quantidadeController.text = '1,000';
      quantidadeFocusNode.requestFocus();
      return;
    }

    final scanText = scanValue.trim();
    final codProdutoScan = AppHelper.tryStringToIntOrNull(scanText);

    final itemConferirConsulta =
        _conferirGridController.findBarCode(scanText) ??
        (codProdutoScan == null
            ? null
            : _conferirGridController.findCodProduto(codProdutoScan));

    if (itemConferirConsulta == null) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Produto não encontrado!',
        detail: 'Este produto não esta na lista de conferencia deste carrinho!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    // TESTE: validação de setor de conferência desligada temporariamente.
    // if (!AppHelper.setorPermitido(
    //   _processoExecutavel.codSetorConferencia,
    //   itemConferirConsulta.codSetorEstoque,
    // )) {
    //   AppAudioHelper().play('/error.wav');
    //   await MessageDialogView.show(
    //     context: Get.context!,
    //     message: 'Produto fora do setor conferência!',
    //     detail: 'Este produto não esta no seu setor de conferência!',
    //   );
    //
    //   displayController.text = '';
    //   scanFocusNode.requestFocus();
    //   scanController.clear();
    //   return;
    // }

    double qtdConfDigitada = AppHelper.qtdDisplayToDouble(
      quantidadeController.text,
    );

    final unidadeMedida = _conferirGridController.findUnidadeByCodigo(
      scanValue,
    );

    if (unidadeMedida != null &&
        unidadeMedida.codProduto == itemConferirConsulta.codProduto) {
      if (unidadeMedida.tipoFatorConversao != 'M') {
        qtdConfDigitada = qtdConfDigitada / unidadeMedida.fatorConversao;
      } else {
        qtdConfDigitada = qtdConfDigitada * unidadeMedida.fatorConversao;
      }
    }

    double qtdProductConferirGrid = _conferirGridController.totalQtdProduct(
      itemConferirConsulta.codProduto,
    );

    double qtdProductConferidaGrid =
        _conferirGridController.totalQtdProductChecked(
          itemConferirConsulta.codProduto,
        ) +
        qtdConfDigitada;

    final carrinhoPercursoAdicionarItemService =
        ConferenciaAdicionarItemService(
          percursoEstagioConsulta: percursoEstagioConsulta,
        );

    if (qtdProductConferidaGrid > qtdProductConferirGrid) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Quantidade excedida!',
        detail: 'Quantidade excedida para o produto!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    try {
      final conferenciaItemConsulta = await carrinhoPercursoAdicionarItemService
          .add(
            codProduto: itemConferirConsulta.codProduto,
            codUnidadeMedida: itemConferirConsulta.codUnidadeMedida,
            quantidade: qtdConfDigitada,
          );

      if (conferenciaItemConsulta == null) {
        AppAudioHelper().play('/error.wav');
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Não foi possível conferir o item',
          detail: 'O servidor não devolveu o item conferido. Tente novamente. Se o problema continuar, verifique a conexão.',
        );

        displayController.text = '';
        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      displayController.text = itemConferirConsulta.nomeProduto;
      _conferenciaGridController.addGrid(conferenciaItemConsulta);

      final itemSeparar = _findItemConferirGrid(
        conferenciaItemConsulta.codProduto,
      );
      if (itemSeparar == null) {
        AppAudioHelper().play('/error.wav');
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Produto não encontrado',
          detail: 'O item conferido não está na lista de conferência deste carrinho.',
        );
        scanController.text = '';
        scanFocusNode.requestFocus();
        return;
      }

      _conferirGridController.updateGrid(
        itemSeparar.copyWith(
          quantidadeConferida:
              itemSeparar.quantidadeConferida +
              conferenciaItemConsulta.quantidade,
        ),
      );

      _conferenciaGridController.highlightItem(conferenciaItemConsulta.item);
      _conferirGridController.highlightItem(
        itemSeparar.item,
        scrollMain: false,
      );

      scanController.text = '';
      quantidadeController.text = '1,000';
      AppAudioHelper().play('/success.wav');
      scanFocusNode.requestFocus();
    } catch (e) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.showError(context: Get.context!, error: e);
      scanFocusNode.requestFocus();
    }
  }

  bool validQuantitySeparate(String scanText, double value) {
    bool isBarCode = AppHelper.isBarCode(scanText);
    int? codProduto = isBarCode
        ? _conferirGridController.findcodProdutoFromBarCode(scanText.trim())
        : AppHelper.tryStringToIntOrNull(scanText.trim());

    if (codProduto == null) return false;

    final totalConferir = _conferirGridController.totalQtdProduct(codProduto);
    final totalSeparada = _conferirGridController.totalQtdProductChecked(
      codProduto,
    );
    if ((totalSeparada + value) > totalConferir) return false;
    return true;
  }

  Future<void> _onEditItemConferenciaGrid() async {
    _conferenciaGridController.onPressedEditItem = (el) async {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não implementado!',
        detail: 'Não é possível editar, funcionalidade não foi implementada.',
      );
    };
  }

  Future<void> _onRemoveItemConferenciaGrid() async {
    _conferenciaGridController.onPressedRemoveItem = (el) async {
      if (viewMode) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O carrinho esta em modo de visualização..',
        );

        return;
      }

      // TESTE: validação de setor de conferência desligada temporariamente.
      // final itemConferirSetor = _findItemConferirGrid(el.codProduto);
      // if (itemConferirSetor != null &&
      //     !AppHelper.setorPermitido(
      //       _processoExecutavel.codSetorConferencia,
      //       itemConferirSetor.codSetorEstoque,
      //     )) {
      //   await MessageDialogView.show(
      //     context: Get.context!,
      //     message: 'Não é possivel remover!',
      //     detail: 'O produto não esta no seu setor conferência!',
      //   );
      //
      //   return;
      // }

      final bool? confirmation = await ConfirmationDialogView.show(
        context: Get.context!,
        message: 'Deseja realmente excluir o item?',
        detail: 'O item será removido do carrinho.',
      );

      if (confirmation != null && confirmation) {
        try {
          await LoadingProcessDialogGenericWidget.show<bool>(
            context: Get.context!,
            process: () async {
              await ConferenciaRemoverItemService(
                percursoEstagioConsulta: percursoEstagioConsulta,
              ).remove(item: el.item);

              _conferenciaGridController.removeGrid(el);

              final itemConferir = _findItemConferirGrid(el.codProduto);
              if (itemConferir != null) {
                final quantidadeConferida =
                    itemConferir.quantidadeConferida - el.quantidade;
                _conferirGridController.updateGrid(
                  itemConferir.copyWith(
                    quantidadeConferida: quantidadeConferida < 0
                        ? 0.00
                        : quantidadeConferida,
                  ),
                );
              }

              _conferenciaGridController.update();
              _conferirGridController.clearHighlight();
              return true;
            },
          );
        } catch (_) {
          // O snackbar do loading já mostrou AppError.display.
        }
      }

      if (scanFocusNode.canRequestFocus) {
        scanFocusNode.requestFocus();
      }
    };
  }

  Future<void> onConferirTudo() async {
    if (_processando) {
      return;
    }

    final double totalSeparar = _conferirGridController.totalQuantity();
    final double totalSeparado = _conferirGridController
        .totalQuantitySeparetion();

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possivel conferir tudo!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (totalSeparado >= totalSeparar) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não existe itens para conferir!',
        detail: 'Todos os itens ja foram separados!',
      );

      return;
    }

    final confirmation = await IdentificacaoDialogView.show(
      context: Get.context!,
    );

    if (confirmation != null) {
      final carrinhoPercursoAdicionarItemService =
          ConferenciaAdicionarItemService(
            percursoEstagioConsulta: percursoEstagioConsulta,
          );

      _processando = true;
      try {
        await LoadingProcessDialogGenericWidget.show<bool>(
          context: Get.context!,
          process: () async {
            final response = await carrinhoPercursoAdicionarItemService
                .addAll();
            _conferenciaGridController.addAllGrid(response);

            final atualizados = <int, ExpedicaoConferirItemConsultaModel>{};
            for (final el in response) {
              final itemConferir =
                  atualizados[el.codProduto] ??
                  _findItemConferirGrid(el.codProduto);
              if (itemConferir == null) {
                continue;
              }

              atualizados[el.codProduto] = itemConferir.copyWith(
                quantidadeConferida:
                    itemConferir.quantidadeConferida + el.quantidade,
              );
            }

            _conferirGridController.updateAllGrid(atualizados.values.toList());
            _conferirGridController.clearHighlight();
            _conferenciaGridController.clearHighlight();
            _conferenciaGridController.update();
            _conferirGridController.update();
            return true;
          },
        );
      } catch (_) {
        // O snackbar do loading já mostrou AppError.display.
      } finally {
        _processando = false;
      }
    }

    if (scanFocusNode.canRequestFocus) {
      scanFocusNode.requestFocus();
    }
  }

  Future<void> onReconferirTudo() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possivel reconferir!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (_conferenciaGridController.totalQuantity() == 0) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não existe itens no carrinho!',
        detail: 'Não é possivel reconferir, pois não existe itens no carrinho!',
      );

      return;
    }

    final confirmation = await IdentificacaoDialogView.show(
      context: Get.context!,
    );

    if (confirmation != null) {
      _processando = true;
      try {
        await LoadingProcessDialogGenericWidget.show<bool>(
          context: Get.context!,
          process: () async {
            await ConferenciaRemoverItemService(
              percursoEstagioConsulta: percursoEstagioConsulta,
            ).removeAllItensCart();

            final atualizados = <int, ExpedicaoConferirItemConsultaModel>{};
            for (final el in List.of(_conferenciaGridController.itens)) {
              final itemConferir = _findItemConferirGrid(el.codProduto);
              if (itemConferir == null) {
                continue;
              }

              atualizados[el.codProduto] = itemConferir.copyWith(
                quantidadeConferida: 0.00,
              );
            }

            _conferirGridController.updateAllGrid(atualizados.values.toList());
            _conferenciaGridController.removeAllGrid();
            _conferirGridController.clearHighlight();
            _conferenciaGridController.update();
            return true;
          },
        );
      } catch (_) {
        // O snackbar do loading já mostrou AppError.display.
      } finally {
        _processando = false;
      }
    }

    if (scanFocusNode.canRequestFocus) {
      scanFocusNode.requestFocus();
    }
  }

  Future<void> onSaveCarrinho() async {
    final result = await _conferidoCarrinhosController.saveCart(
      percursoEstagioConsulta,
    );

    if (result) {
      DialogCloseGuard.popPage();
    }
  }

  Future<void> onSobraCarrinho() async {}

  void onVisibleTabChanged(int index) {
    if (index == 0) {
      _conferenciaGridController.ensureHighlightedVisible();
      return;
    }

    _conferirGridController.ensureHighlightedVisible(scrollMain: false);
  }

  ExpedicaoConferirItemConsultaModel? _findItemConferirGrid(int codProduto) {
    final el = _conferirGridController.findCodProduto(codProduto);
    return el;
  }

  void _aplicarSituacaoDocumento(String situacao) {
    if (Get.isRegistered<ExpedicaoConferirConsultaModel>()) {
      Get.find<ExpedicaoConferirConsultaModel>().situacao = situacao;
    }
    if (Get.isRegistered<ConferirController>()) {
      Get.find<ConferirController>().aplicarSituacao(situacao);
    }
    AppSocketListenLog.applied(
      origem: 'ConferenciaController.documento',
      situacao: situacao,
    );
  }

  void _liteners() {
    const uuid = Uuid();
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;

    final conferenciaItemEvent = ConferenciaItemEventRepository.instancia;
    final conferirItemEvent = ConferirItemEventRepository.instancia;
    final conferirEvent = ConferirEventRepository.instancia;

    final updateCarrinhoPercurso = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: true,
      callback: (data) async {
        final propriaSessao = AppSocketListenLog.isOwnSession(
          envelopeSession: data.session,
          socketId: Get.find<AppSocketConfig>().sessionId,
        );

        for (var el in data.mutation) {
          late final ExpedicaoCarrinhoPercursoEstagioConsultaModel itemConsulta;
          try {
            itemConsulta =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);
          } catch (error) {
            AppSocketListenLog.error('ConferenciaController.carrinho', error);
            continue;
          }

          if (itemConsulta.codEmpresa != percursoEstagioConsulta.codEmpresa ||
              itemConsulta.codCarrinhoPercurso !=
                  percursoEstagioConsulta.codCarrinhoPercurso ||
              itemConsulta.item != percursoEstagioConsulta.item) {
            continue;
          }

          setSituacao = itemConsulta.situacao;
          AppSocketListenLog.applied(
            origem: 'ConferenciaController.carrinho',
            situacao: itemConsulta.situacao,
            extra:
                'carrinho=${itemConsulta.codCarrinho} item=${itemConsulta.item} propriaSessao=$propriaSessao',
          );

          if (itemConsulta.situacao == ExpedicaoSituacaoModel.conferindo ||
              itemConsulta.situacao == ExpedicaoSituacaoModel.emAndamento ||
              itemConsulta.situacao == ExpedicaoSituacaoModel.emConverencia) {
            _viewMode.value = false;
            update();
          }

          if (itemConsulta.situacao == ExpedicaoSituacaoModel.conferido ||
              itemConsulta.situacao == ExpedicaoSituacaoModel.agrupado) {
            _viewMode.value = true;
            update();
          }

          if (itemConsulta.situacao == ExpedicaoSituacaoModel.cancelada) {
            _viewMode.value = true;
            update();

            if (!propriaSessao) {
              final cancelamentos = await CancelamentoService()
                  .selectOrigemWithItem(
                    codEmpresa: itemConsulta.codEmpresa,
                    origem: ExpedicaoOrigemModel.carrinhoPercurso,
                    codOrigem: itemConsulta.codCarrinhoPercurso,
                    itemOrigem: itemConsulta.item,
                  );

              if (cancelamentos != null) {
                await MessageDialogView.show(
                  context: Get.context!,
                  message: 'Carrinho cancelado!',
                  detail:
                      'Cancelado pelo usuario: ${cancelamentos.nomeUsuarioCancelamento}!',
                );
              } else {
                await MessageDialogView.show(
                  context: Get.context!,
                  message: 'Carrinho cancelado!',
                  detail: 'O carrinho foi cancelado. Não possivel identificar usuario cancelamento!',
                );
              }
            }
          }

          update();
        }
      },
    );

    final conferir = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: true,
      callback: (data) async {
        for (var el in data.mutation) {
          final codEmpresa = AppSocketListenLog.asInt(el['CodEmpresa']);
          final codConferir = AppSocketListenLog.asInt(el['CodConferir']);
          final situacao = AppSocketListenLog.asString(el['Situacao']);

          if (codEmpresa != percursoEstagioConsulta.codEmpresa ||
              codConferir != percursoEstagioConsulta.codOrigem ||
              percursoEstagioConsulta.origem !=
                  ExpedicaoOrigemModel.conferencia ||
              situacao == null) {
            continue;
          }

          _aplicarSituacaoDocumento(situacao);

          if (situacao == ExpedicaoSituacaoModel.cancelada ||
              situacao == ExpedicaoSituacaoModel.conferido ||
              situacao == ExpedicaoSituacaoModel.agrupado) {
            _viewMode.value = true;
          }

          update();
        }
      },
    );

    final updateConferirItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: false,
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
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);
          if (AppSocketListenLog.isOwnSession(
            envelopeSession: data.session,
            socketId: Get.find<AppSocketConfig>().sessionId,
            rowSessionId: item.sessionId,
          )) {
            continue;
          }

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
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);
          if (AppSocketListenLog.isOwnSession(
            envelopeSession: data.session,
            socketId: Get.find<AppSocketConfig>().sessionId,
            rowSessionId: item.sessionId,
          )) {
            continue;
          }

          if (item.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.conferencia ==
                  percursoEstagioConsulta.origem &&
              item.codConferir == percursoEstagioConsulta.codOrigem &&
              item.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            _conferenciaGridController.updateGrid(item);
            _conferenciaGridController.update();
          }
        }
      },
    );

    final deleteConferenciaItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.delete,
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaConferenciaItemConsultaModel.fromJson(el);

          _conferenciaGridController.removeGrid(item);
          _conferenciaGridController.update();
        }
      },
    );

    conferirItemEvent.addListener(updateConferirItem);
    conferirEvent.addListener(conferir);
    carrinhoPercursoEvent.addListener(updateCarrinhoPercurso);
    conferenciaItemEvent.addListener(insertConferenciaItem);
    conferenciaItemEvent.addListener(updateConferenciaItem);
    conferenciaItemEvent.addListener(deleteConferenciaItem);

    _pageListerner.add(updateCarrinhoPercurso);
    _pageListerner.add(conferir);
    _pageListerner.add(updateConferenciaItem);
    _pageListerner.add(insertConferenciaItem);
    _pageListerner.add(deleteConferenciaItem);
    _pageListerner.add(updateConferirItem);
  }

  void _removeliteners() {
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;

    final conferenciaItemEvent = ConferenciaItemEventRepository.instancia;
    final conferirItemEvent = ConferirItemEventRepository.instancia;
    final conferirEvent = ConferirEventRepository.instancia;

    carrinhoPercursoEvent.removeListeners(_pageListerner);
    conferenciaItemEvent.removeListeners(_pageListerner);
    conferirItemEvent.removeListeners(_pageListerner);
    conferirEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }
}
