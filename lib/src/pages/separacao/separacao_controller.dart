import '../../service/socket_mutation_action.dart';

import 'package:get/get.dart';
import 'package:app_expedicao/src/app/app_error.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/app/app_dialog_close.dart';

import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/service/separacao_carrinho_validacao.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/separacao_consulta_service.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/separacao_remover_item_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_event_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_event_repository.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/identificacao_dialog_view.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/service/cancelamento_service.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/app/app_audio_helper.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class SeparacaoController extends GetxController {
  final RxBool _viewMode = false.obs;

  void setViewMode({bool value = true}) {
    _viewMode.value = value;
    indicator.value = colorIndicator;
  }

  late ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late SeparadoCarrinhosController _separadoCarrinhosController;
  late SeparacaoCarrinhoGridController _separacaoGridController;
  late SepararConsultaServices _separarConsultaServices;
  Rx<Color> indicator = Colors.white.obs;

  late TextEditingController quantidadeController;
  late TextEditingController displayController;
  late TextEditingController scanController;

  late FocusNode formFocusNode;
  late FocusNode quantidadeFocusNode;
  late FocusNode displayFocusNode;
  late FocusNode scanFocusNode;

  bool _isComplit = false;
  bool _processando = false;
  bool get isComplit => _isComplit;

  SeparacaoController(this.percursoEstagioConsulta);

  String get title {
    return _viewMode.value ? 'Separação  - Visualização' : 'Separação - Edição';
  }

  String get fullCartName {
    return '${percursoEstagioConsulta.codCarrinho} - ${percursoEstagioConsulta.nomeCarrinho}';
  }

  String get displaySituacao {
    return percursoEstagioConsulta.situacao;
  }

  set setSituacao(String situacao) {
    percursoEstagioConsulta.situacao = situacao;
    indicator.value = colorIndicator;
  }

  void _aplicarSituacaoDocumento(String situacao) {
    if (Get.isRegistered<ExpedicaoSepararConsultaModel>()) {
      Get.find<ExpedicaoSepararConsultaModel>().situacao = situacao;
    }
    if (Get.isRegistered<SepararController>()) {
      Get.find<SepararController>().aplicarSituacao(situacao);
    }
    AppSocketListenLog.applied(
      origem: 'SeparacaoController.documento',
      situacao: situacao,
    );
  }

  Color get colorIndicator {
    final isComplit = _separarGridController.isComplit();
    if (isComplit) return Colors.green;

    switch (percursoEstagioConsulta.situacao) {
      case ExpedicaoSituacaoModel.cancelada:
        return Colors.red;
      case ExpedicaoSituacaoModel.separado:
        return Colors.green;
      case ExpedicaoSituacaoModel.separando:
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => SeparacaoCarrinhoGridController());

    _separarGridController = Get.find<SepararGridController>();
    _separacaoGridController = Get.find<SeparacaoCarrinhoGridController>();
    _separadoCarrinhosController = Get.find<SeparadoCarrinhosController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    scanController = TextEditingController();
    displayController = TextEditingController(text: '');
    quantidadeController = TextEditingController(text: '1,000');

    formFocusNode = FocusNode();
    scanFocusNode = FocusNode();
    quantidadeFocusNode = FocusNode();
    displayFocusNode = FocusNode();

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    _fillGridSeparacaoItens();

    _separarGridController.isComplitListiner.listen((value) {
      if (_isComplit != value) {
        _isComplit = value;
        indicator.value = colorIndicator;
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    Get.find<AppSocketConfig>().recovery.register(this, _reloadAfterConnection);

    if (_viewMode.value) {
      formFocusNode.requestFocus();
    } else {
      scanFocusNode.requestFocus();
    }

    _onEditItemSeparacaoGrid();
    _onRemoveItemSeparacaoGrid();
    _listenFocusNode();
    _liteners();
  }

  @override
  void onClose() {
    Get.find<AppSocketConfig>().recovery.unregister(this);
    _viewMode.close();
    scanController.dispose();
    quantidadeController.dispose();
    displayController.dispose();

    formFocusNode.dispose();
    quantidadeFocusNode.dispose();
    displayFocusNode.dispose();
    scanFocusNode.dispose();
    _removeliteners();

    indicator.close();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (_processando) {
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f7) {
        onSepararTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f8) {
        onReconferirTudo();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f11) {
        onRecuperarItens();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f6) {
        onReopenCarrinho();
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

  void onPressedCloseBar() {
    DialogCloseGuard.popPage();
  }

  ExpedicaoCarrinhoPercursoEstagioConsultaModel get percursoEstagio =>
      percursoEstagioConsulta;

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

  Future<void> _reloadAfterConnection() async {
    final stages = await CarrinhoPercursoEstagioServices().select(
      QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals(
            'CodCarrinhoPercurso',
            percursoEstagioConsulta.codCarrinhoPercurso,
          )
          .equals(
            'Item',
            AppHelper.itemSequenceKey(percursoEstagioConsulta.item),
          ),
    );
    if (isClosed) return;
    if (stages.isEmpty) {
      _viewMode.value = true;
      update();
      throw AppError(
        'O estágio do carrinho não existe mais. Feche o carrinho e confira o documento.',
      );
    }
    setSituacao = stages.single.situacao;
    _viewMode.value =
        !(stages.single.situacao == ExpedicaoSituacaoModel.separando ||
            stages.single.situacao == ExpedicaoSituacaoModel.emAndamento ||
            stages.single.situacao == ExpedicaoSituacaoModel.emSeparacao);
    await _fillGridSeparacaoItens();
    if (!isClosed) update();
  }

  Future<void> _fillGridSeparacaoItens() async {
    final separar = await _separarConsultaServices.separar();
    final separacaoItens = await _separarConsultaServices.itensSeparacao();

    final separacaoItensFiltrados = separacaoItens.where((el) {
      return (el.codEmpresa == percursoEstagioConsulta.codEmpresa &&
          el.codCarrinhoPercurso ==
              percursoEstagioConsulta.codCarrinhoPercurso &&
          AppHelper.sameGridItem(
            el.itemCarrinhoPercurso,
            percursoEstagioConsulta.item,
          ));
    }).toList();

    if (isClosed) return;
    _separacaoGridController.removeAllGrid();
    _separacaoGridController.addAllGrid(separacaoItensFiltrados);
    _separacaoGridController.update();
    _isComplit = _separarGridController.isComplit();

    indicator.value = colorIndicator;

    if (separar != null &&
        separar.situacao == ExpedicaoSituacaoModel.cancelada) {
      _viewMode.value = true;
    }

    update();
  }

  bool get viewMode {
    if (Get.isRegistered<ExpedicaoSepararConsultaModel>()) {
      final situacao = Get.find<ExpedicaoSepararConsultaModel>().situacao;
      if (situacao == ExpedicaoSituacaoModel.cancelada ||
          situacao == ExpedicaoSituacaoModel.separado) {
        return true;
      }
    }
    if (percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.cancelada ||
        percursoEstagioConsulta.situacao == ExpedicaoSituacaoModel.separado) {
      _viewMode.value = true;
    } else if (percursoEstagioConsulta.situacao ==
            ExpedicaoSituacaoModel.separando ||
        percursoEstagioConsulta.situacao ==
            ExpedicaoSituacaoModel.emAndamento ||
        percursoEstagioConsulta.situacao ==
            ExpedicaoSituacaoModel.emSeparacao) {
      _viewMode.value = false;
    }

    return _viewMode.value;
  }

  bool get canReopenCarrinho {
    if (!Get.isRegistered<ExpedicaoSepararConsultaModel>()) {
      return false;
    }

    return SeparacaoCarrinhoValidacao.podeReabrir(
      situacaoSeparacao: Get.find<ExpedicaoSepararConsultaModel>().situacao,
      situacaoCarrinho: percursoEstagioConsulta.situacao,
    );
  }

  Future<void> onSubmittedScan(String? value) async {
    if (value != null) _addItemSeparacao();
  }

  Future<void> onSubmittedQuantity(String? value) async {
    if (value != null) _addItemSeparacao();
  }

  Future<void> _addItemSeparacao() async {
    try {
      await Get.find<AppSocketConfig>().recovery.beforeMutation();
    } catch (e) {
      if (!isClosed) {
        await MessageDialogView.showError(context: Get.context!, error: e);
      }
      return;
    }
    if (isClosed) return;
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

    if (!_separarGridController.existsBarCode(scanValue.trim()) &&
        !_separarGridController.existsCodProduto(
          AppHelper.tryStringToIntOrZero(scanValue.trim()),
        )) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
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
    final codProdutoScan = AppHelper.tryStringToIntOrNull(scanText);

    final itemSepararConsulta =
        _separarGridController.findBarCode(scanText) ??
        (codProdutoScan == null
            ? null
            : _separarGridController.findCodProduto(codProdutoScan));

    if (itemSepararConsulta == null) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Produto não encontrado!',
        detail: 'Este produto não esta na lista de separação!',
      );

      displayController.text = '';
      scanFocusNode.requestFocus();
      scanController.clear();
      return;
    }

    if (!AppHelper.setorPermitido(
      _processoExecutavel.codSetorEstoque,
      itemSepararConsulta.codSetorEstoque,
    )) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Produto fora do setor estoque!',
        detail: 'Este produto não esta no seu setor de setor estoque!',
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
    final unidadeMedida = _separarGridController.findUnidadeByCodigo(scanValue);

    if (unidadeMedida != null &&
        unidadeMedida.codProduto == itemSepararConsulta.codProduto) {
      if (unidadeMedida.tipoFatorConversao != 'M') {
        qtdConferencia = qtdConfDigitada / unidadeMedida.fatorConversao;
      } else {
        qtdConferencia = qtdConfDigitada * unidadeMedida.fatorConversao;
      }
    }

    if ((qtdConferencia + itemSepararConsulta.quantidadeSeparacao) >
        itemSepararConsulta.quantidade) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Quantidade invalida!',
        detail:
            '''A quantidade informada ${qtdConferencia.toStringAsFixed(3)}, é maior que a quantidade a separar! ''',
      );

      quantidadeController.text = '1,000';

      scanController.clear();
      scanFocusNode.requestFocus();

      return;
    }

    //ADD ITEM DATABASE
    try {
      final separacaoItemConsulta = await carrinhoPercursoAdicionarItemService
          .add(
            codProduto: itemSepararConsulta.codProduto,
            codUnidadeMedida: itemSepararConsulta.codUnidadeMedida,
            quantidade: qtdConferencia,
          );

      if (separacaoItemConsulta == null) {
        AppAudioHelper().play('/error.wav');
        await MessageDialogView.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Não foi possível adicionar o item',
          detail: 'O servidor não devolveu o item separado. Tente novamente. Se o problema continuar, verifique a conexão.',
        );

        displayController.text = '';
        scanFocusNode.requestFocus();
        scanController.clear();
        return;
      }

      displayController.text = itemSepararConsulta.nomeProduto;
      _separacaoGridController.addGrid(separacaoItemConsulta);

      final itemSeparar = _findItemSepararGrid(
        separacaoItemConsulta.codProduto,
      );
      if (itemSeparar == null) {
        AppAudioHelper().play('/error.wav');
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Erro ao adicionar item!',
          detail: 'Produto não encontrado na lista de separação!',
        );
        scanController.clear();
        scanFocusNode.requestFocus();
        return;
      }

      _separarGridController.updateGrid(
        itemSeparar.copyWith(
          quantidadeSeparacao:
              itemSeparar.quantidadeSeparacao +
              separacaoItemConsulta.quantidade,
        ),
      );
      _separarGridController.highlightItem(itemSeparar.item, scrollMain: false);

      _separacaoGridController.setSelectedRow(
        _separacaoGridController.findIndexItem(separacaoItemConsulta.item),
        scroll: false,
      );

      scanController.clear();
      quantidadeController.text = '1,000';
      scanFocusNode.requestFocus();

      AppAudioHelper().play('/success.wav');
    } catch (e) {
      AppAudioHelper().play('/error.wav');
      await MessageDialogView.showError(context: Get.context!, error: e);
      scanFocusNode.requestFocus();
    }
  }

  bool validQuantitySeparate(String scanText, double value) {
    bool isBarCode = AppHelper.isBarCode(scanText);
    int? codProduto = isBarCode
        ? _separarGridController.findCodProdutoFromBarCode(scanText.trim())
        : AppHelper.tryStringToIntOrNull(scanText.trim());

    if (codProduto == null) return false;

    final totalSeparar = _separarGridController.totalQtdProduct(codProduto);
    final totalSeparada = _separarGridController.totalQtdProductSeparation(
      codProduto,
    );
    if ((totalSeparada + value) > totalSeparar) return false;
    return true;
  }

  Future<void> _onEditItemSeparacaoGrid() async {
    _separacaoGridController.onPressedEditItem = (el) async {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não implementado!',
        detail: 'Não é possível editar, funcionalidade não foi implementada.',
      );
    };
  }

  Future<void> _onRemoveItemSeparacaoGrid() async {
    _separacaoGridController.onPressedRemoveItem = (el) async {
      if (viewMode) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O carrinho esta em modo de visualização..',
        );

        return;
      }

      if (!AppHelper.setorPermitido(
        _processoExecutavel.codSetorEstoque,
        el.codSetorEstoque,
      )) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Não é possivel remover!',
          detail: 'O produto não esta no seu setor estoque!',
        );

        return;
      }

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
              try {
                await SeparacaoRemoverItemService(
                  percursoEstagioConsulta: percursoEstagioConsulta,
                ).remove(item: el.item);

                _separacaoGridController.removeGrid(el);

                final itemSeparar = _findItemSepararGrid(el.codProduto);
                if (itemSeparar != null) {
                  final quantidadeSeparacao =
                      itemSeparar.quantidadeSeparacao - el.quantidade;
                  _separarGridController.updateGrid(
                    itemSeparar.copyWith(
                      quantidadeSeparacao: quantidadeSeparacao < 0
                          ? 0.00
                          : quantidadeSeparacao,
                    ),
                  );
                }

                return true;
              } catch (err) {
                rethrow;
              }
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

  Future<void> onSepararTudo() async {
    if (_processando) {
      return;
    }

    final double totalSeparar = _separarGridController.totalQuantity();
    final double totalSeparado = _separarGridController
        .totalQuantitySeparetion();

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possivel separar tudo!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    if (totalSeparado >= totalSeparar) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não existe itens para separar!',
        detail: 'Todos os itens ja foram separados!',
      );

      scanFocusNode.requestFocus();
      return;
    }

    final confirmation = await IdentificacaoDialogView.show(
      context: Get.context!,
    );

    if (confirmation != null) {
      final carrinhoPercursoAdicionarItemService =
          SeparacaoAdicionarItemService(
            percursoEstagioConsulta: percursoEstagioConsulta,
          );

      _processando = true;
      try {
        await LoadingProcessDialogGenericWidget.show<bool>(
          context: Get.context!,
          process: () async {
            final response = await carrinhoPercursoAdicionarItemService
                .addAll();
            _separacaoGridController.addAllGrid(response);

            final atualizados = <int, ExpedicaoSepararItemConsultaModel>{};
            for (final el in response) {
              final itemSeparar =
                  atualizados[el.codProduto] ??
                  _findItemSepararGrid(el.codProduto);
              if (itemSeparar == null) {
                continue;
              }

              atualizados[el.codProduto] = itemSeparar.copyWith(
                quantidadeSeparacao:
                    itemSeparar.quantidadeSeparacao + el.quantidade,
              );
            }

            _separarGridController.updateAllGrid(atualizados.values.toList());
            _separacaoGridController.update();
            _separarGridController.update();
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

    if (_separacaoGridController.totalQuantity() == 0) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não existe itens no carrinho!',
        detail: 'Não é possivel reconferir, pois não existe itens no carrinho!',
      );

      scanFocusNode.requestFocus();
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
            await SeparacaoRemoverItemService(
              percursoEstagioConsulta: percursoEstagioConsulta,
            ).removeAllItensCart();

            final atualizados = <int, ExpedicaoSepararItemConsultaModel>{};
            for (final el in List.of(_separacaoGridController.itens)) {
              final itemSeparar = _findItemSepararGrid(el.codProduto);
              if (itemSeparar == null) {
                continue;
              }
              atualizados[el.codProduto] = itemSeparar.copyWith(
                quantidadeSeparacao: 0.00,
              );
            }

            _separarGridController.updateAllGrid(atualizados.values.toList());
            _separacaoGridController.removeAllGrid();
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

  Future<void> onRecuperarItens() async {
    if (_processando) {
      return;
    }

    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possivel recuperar itens!',
        detail: 'O carrinho esta em modo de visualização..',
      );

      return;
    }

    final confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja realmente recuperar?',
      detail: 'O sistema localiza os itens do penúltimo carrinho cancelado!',
    );

    if (confirmation != null && confirmation) {
      _processando = true;
      try {
        await _recuperarItensConfirmado();
      } finally {
        _processando = false;
      }
    }
  }

  Future<void> _recuperarItensConfirmado() async {
    final carrinhoPercursoEstagioServices = CarrinhoPercursoEstagioServices();
    final carrinhoService = CarrinhoService();

    final queryBuilder = QueryBuilder()
        .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
        .equals('CodCarrinho', percursoEstagioConsulta.codCarrinho);

    final carrinhos = await carrinhoService.select(queryBuilder);

    if (carrinhos.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: 'Carrinho não encontrado, verifique.',
      );

      return;
    }

    if (carrinhos.first.situacao !=
        ExpedicaoCarrinhoSituacaoModel.emSeparacao) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não esta em separação!',
        detail: 'Carrinho não esta em separação, verifique.',
      );

      return;
    }

    final carrinhosPercurso = await carrinhoPercursoEstagioServices.select(
      queryBuilder,
    );

    if (carrinhosPercurso.isEmpty || carrinhosPercurso.length < 2) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado.',
        detail: 'Verifique. Carrinho nunca esteve em percurso anteriores!.',
      );

      return;
    }

    final penultimoCarrinhoPercurso =
        carrinhosPercurso[carrinhosPercurso.length - 2];

    if (penultimoCarrinhoPercurso.situacao !=
        ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não cancelado!',
        detail: 'Carrinho não foi cancelado na separação.',
      );

      return;
    }

    if (penultimoCarrinhoPercurso.origem != ExpedicaoOrigemModel.separacao) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Origem não é separação!',
        detail: 'Origem do carrinho cancelado não é separação.',
      );

      return;
    }

    if (penultimoCarrinhoPercurso.codOrigem !=
        percursoEstagioConsulta.codOrigem) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho de outro documento!',
        detail: 'O estágio cancelado não pertence a esta separação. Não é possível recuperar.',
      );

      return;
    }

    final separacaoItens =
        await SeparacaoConsultaService.getSeparacaoItensCarrinho(
          codEmpresa: penultimoCarrinhoPercurso.codEmpresa,
          codCarrinhoPercurso: penultimoCarrinhoPercurso.codCarrinhoPercurso,
          itemCarrinhoPercurso: penultimoCarrinhoPercurso.item,
        );

    if (separacaoItens.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Itens não encontrados!',
        detail: 'Itens não encontrados no carrinho cancelado.',
      );

      return;
    }

    try {
      await adicionarItensRecuperadoSeparacao(
        percursoEstagioConsulta,
        separacaoItens,
      );
    } catch (_) {
      return;
    }
  }

  Future<bool> adicionarItensRecuperadoSeparacao(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagio,
    List<ExpedicaoSeparacaoItemModel> separacaoItensRecuperado,
  ) async {
    return await LoadingProcessDialogGenericWidget.show<bool>(
      context: Get.context!,
      process: () => runSocketMutation(() async {
        await SeparacaoAdicionarItemService(
          percursoEstagioConsulta: percursoEstagio,
        ).addRecuperados(separacaoItensRecuperado);

        final newSepararItens = await _separarConsultaServices.itensSaparar();
        _separarGridController.updateAllGrid(newSepararItens);

        await _fillGridSeparacaoItens();
        return true;
      }),
    );
  }

  Future<void> onSaveCarrinho() async {
    if (viewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possível salvar!',
        detail: 'O carrinho está em modo de visualização.',
      );
      return;
    }

    final result = await _separadoCarrinhosController.saveCart(
      percursoEstagioConsulta,
    );

    if (result) {
      DialogCloseGuard.popPage();
    }
  }

  Future<void> onReopenCarrinho() async {
    if (!canReopenCarrinho) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possível reabrir!',
        detail: 'Só é possível reabrir um carrinho finalizado enquanto a separação estiver em andamento.',
      );
      return;
    }

    final result = await _separadoCarrinhosController.reopenCart(
      percursoEstagioConsulta,
    );

    if (result) {
      percursoEstagioConsulta = percursoEstagioConsulta.reabrir();
      _viewMode.value = false;
      indicator.value = colorIndicator;
      update();
    }
  }

  ExpedicaoSepararItemConsultaModel? _findItemSepararGrid(int codProduto) {
    final el = _separarGridController.findCodProduto(codProduto);
    return el;
  }

  void _liteners() {
    const uuid = Uuid();
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;

    final separacaoItemEvent = SeparacaoItemEventRepository.instancia;
    final separarEvent = SepararEventRepository.instancia;

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
            AppSocketListenLog.error('SeparacaoController.carrinho', error);
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
            origem: 'SeparacaoController.carrinho',
            situacao: itemConsulta.situacao,
            extra:
                'carrinho=${itemConsulta.codCarrinho} item=${itemConsulta.item} propriaSessao=$propriaSessao',
          );

          if (itemConsulta.situacao == ExpedicaoSituacaoModel.separando ||
              itemConsulta.situacao == ExpedicaoSituacaoModel.emAndamento ||
              itemConsulta.situacao == ExpedicaoSituacaoModel.emSeparacao) {
            _viewMode.value = false;
            update();
          }

          if (itemConsulta.situacao == ExpedicaoSituacaoModel.separado) {
            _viewMode.value = true;
            update();

            if (!propriaSessao) {
              await MessageDialogView.show(
                context: Get.context!,
                message: 'Carrinho finalizado!',
                detail:
                    'finalizado pelo usuario ${itemConsulta.nomeUsuarioFinalizacao}!',
              );
            }
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
                  detail: 'O carrinho cancelado. Não possivel identificar usuario cancelamento!',
                );
              }
            }
          }

          update();
        }
      },
    );

    final insertSeparacaoItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.insert,
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          final itemConsulta = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          if (AppSocketListenLog.isOwnSession(
            envelopeSession: data.session,
            socketId: Get.find<AppSocketConfig>().sessionId,
            rowSessionId: itemConsulta.sessionId,
          )) {
            continue;
          }
          if (itemConsulta.codEmpresa == percursoEstagioConsulta.codEmpresa &&
              ExpedicaoOrigemModel.separacao ==
                  percursoEstagioConsulta.origem &&
              itemConsulta.codSepararEstoque ==
                  percursoEstagioConsulta.codOrigem &&
              itemConsulta.codCarrinho == percursoEstagioConsulta.codCarrinho) {
            final alreadyInGrid = _separacaoGridController.itens.any(
              (el) => AppHelper.sameGridItem(el.item, itemConsulta.item),
            );
            if (alreadyInGrid) {
              continue;
            }

            _separacaoGridController.addGrid(itemConsulta);
          }
        }
      },
    );

    final deleteSeparacaoItem = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.delete,
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          final sep = ExpedicaSeparacaoItemConsultaModel.fromJson(el);
          _separacaoGridController.removeGrid(sep);
        }
      },
    );

    final separar = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: true,
      callback: (data) async {
        for (var el in data.mutation) {
          final codEmpresa = AppSocketListenLog.asInt(el['CodEmpresa']);
          final codSepararEstoque = AppSocketListenLog.asInt(
            el['CodSepararEstoque'],
          );
          final situacao = AppSocketListenLog.asString(el['Situacao']);

          if (codEmpresa != percursoEstagioConsulta.codEmpresa ||
              codSepararEstoque != percursoEstagioConsulta.codOrigem ||
              percursoEstagioConsulta.origem !=
                  ExpedicaoOrigemModel.separacao ||
              situacao == null) {
            continue;
          }

          _aplicarSituacaoDocumento(situacao);

          if (situacao == ExpedicaoSituacaoModel.cancelada ||
              situacao == ExpedicaoSituacaoModel.separado) {
            setViewMode();
          }

          update();
        }
      },
    );

    carrinhoPercursoEvent.addListener(updateCarrinhoPercurso);
    separacaoItemEvent.addListener(insertSeparacaoItem);
    separacaoItemEvent.addListener(deleteSeparacaoItem);
    separarEvent.addListener(separar);

    _pageListerner.add(updateCarrinhoPercurso);
    _pageListerner.add(insertSeparacaoItem);
    _pageListerner.add(deleteSeparacaoItem);
    _pageListerner.add(separar);
  }

  void _removeliteners() {
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;
    final separacaoItemEvent = SeparacaoItemEventRepository.instancia;
    final separarEvent = SepararEventRepository.instancia;

    carrinhoPercursoEvent.removeListeners(_pageListerner);
    separacaoItemEvent.removeListeners(_pageListerner);
    separarEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }
}
