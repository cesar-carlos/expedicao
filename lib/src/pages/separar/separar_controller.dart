import '../../service/socket_mutation_action.dart';

import 'package:app_expedicao/src/service/carrinho_recovery_validation.dart';

import 'dart:async';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_error.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_expedicao/src/app/app_encerrar.dart';
import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/service/separacao_consulta_service.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/separacao_adicionar_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/carrinho_dialog/carrinho_dialog_view.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/model/observacao_dialog_view_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_event_repository.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/identificacao_dialog_view.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/observacao_dialog_view.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/separar_finalizar_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/separar_services.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class SepararController extends GetxController {
  bool _iniciada = false;

  late String _expedicaoSituacao;
  late SepararGridController _separarGridController;
  late SepararConsultaServices _separarConsultaServices;
  late SeparadoCarrinhosController _separarCarrinhosController;

  final List<RepositoryEventListenerModel> _pageListerner = [];
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late ProcessoExecutavelModel _processoExecutavel;
  late FocusNode formFocusNode;

  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;

  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  int? get codSetorEstoque => _processoExecutavel.codSetorEstoque;

  String get expedicaoSituacaoModel => _expedicaoSituacao;

  bool get iniciada {
    if (_carrinhoPercurso == null) {
      _iniciada = false;
      return _iniciada;
    } else {
      _iniciada = true;
      return _iniciada;
    }
  }

  String get expedicaoSituacaoDisplay {
    return _expedicaoSituacao;
  }

  void aplicarSituacao(String situacao) {
    if (situacao.isEmpty) return;
    if (_expedicaoSituacao == situacao &&
        _separarConsulta.situacao == situacao) {
      AppSocketListenLog.applied(
        origem: 'SepararController',
        situacao: situacao,
        extra: 'sem mudanca',
      );
      return;
    }

    _expedicaoSituacao = situacao;
    _separarConsulta.situacao = situacao;
    AppSocketListenLog.applied(origem: 'SepararController', situacao: situacao);
    update();
  }

  Color get colorIndicator {
    switch (_expedicaoSituacao) {
      case ExpedicaoSituacaoModel.cancelada:
        return Colors.red;
      case ExpedicaoSituacaoModel.separado:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  onInit() async {
    super.onInit();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarCarrinhosController = Get.find<SeparadoCarrinhosController>();
    _separarGridController = Get.find<SepararGridController>();
    _expedicaoSituacao = _separarConsulta.situacao;
    formFocusNode = FocusNode()..requestFocus();

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );
  }

  @override
  onReady() async {
    super.onReady();
    Get.find<AppSocketConfig>().recovery.register(this, _reloadAfterConnection);
    Get.find<AppSocketConfig>().recovery.registerValidator(this, () async {
      if (isClosed) return;
      await CarrinhoRecoveryValidation.reloadAndValidate(
        codEmpresa: _processoExecutavel.codEmpresa,
        codDocumento: _processoExecutavel.codOrigem,
        conferencia: false,
      );
    });
    _fillGridSepararItens();
    _fillCarrinhoPercurso();
    _liteners();
  }

  @override
  onClose() {
    Get.find<AppSocketConfig>().recovery.unregister(this);
    _removeAllliteners();
    formFocusNode.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.f4) {
        onAdicionarCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f5) {
        btnAdicionarObservacao();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f6) {
        btnReabrirCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f9) {
        btnEditarCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f10) {
        btnSalvarCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.delete) {
        btnExcluirCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f11) {
        recuperarCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f12) {
        btnFinalizarSeparacao();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.escape) {
        ConfirmationDialogView.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Deseja realmente sair?',
          detail: 'A tela será fechada e a separação não será  cancelada.',
        ).then((value) {
          if (value != null && value) unawaited(AppEncerrar.agora());
        });
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _reloadAfterConnection() async {
    final documento = await _separarConsultaServices.separar();
    if (isClosed) return;
    if (documento == null) {
      throw AppError('Documento de separação não encontrado. Reabra a tela.');
    }
    _separarConsulta = documento;
    Get.find<ExpedicaoSepararConsultaModel>().situacao = documento.situacao;
    aplicarSituacao(documento.situacao);
    await _fillGridSepararItens();
    if (isClosed) return;
    await _fillCarrinhoPercurso();
    if (isClosed) return;
    await _separarCarrinhosController.reloadFromServer();
  }

  Future<void> _fillGridSepararItens() async {
    final separarItens = await _separarConsultaServices.itensSaparar();
    final separarUnid = await _separarConsultaServices.itensSapararUnidades();

    if (isClosed) return;
    _separarGridController.removeAllGrid();
    _separarGridController.addAllGrid(separarItens);
    _separarGridController.addAllUnidade(separarUnid);
    _separarGridController.update();
  }

  Future<void> _fillCarrinhoPercurso() async {
    final queryBuilder = QueryBuilder()
        .equals('CodEmpresa', _processoExecutavel.codEmpresa)
        .equals('Origem', _processoExecutavel.origem)
        .equals('CodOrigem', _processoExecutavel.codOrigem);

    final carrinhoPercursos = await CarrinhoPercursoServices().select(
      queryBuilder,
    );

    if (isClosed) return;
    _carrinhoPercurso = carrinhoPercursos.firstOrNull;
  }

  Future<void> iniciarSeparacao() async {
    if (_carrinhoPercurso == null) await _fillCarrinhoPercurso();

    final separacaoJaIniciada =
        _expedicaoSituacao == ExpedicaoSituacaoModel.separando &&
        _carrinhoPercurso != null;

    if (!separacaoJaIniciada) {
      final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
      await SepararServices(separar).iniciar();

      _expedicaoSituacao = ExpedicaoSituacaoModel.separando;
      _separarConsulta.situacao = ExpedicaoSituacaoModel.separando;

      if (_carrinhoPercurso == null) await _fillCarrinhoPercurso();
      update();
    }

    _iniciada = _carrinhoPercurso != null;
  }

  Future<void> pausarSeparacao() async {
    await MessageDialogView.show(
      context: Get.context!,
      message: 'Não implementado!',
      detail: 'Não é possível pausar, funcionalidade não foi implementada.',
    );
  }

  FutureOr<void> onAdicionarCarrinho() async {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível finalizar novamente.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Separação cancelada, não é possível adicionar carrinho.',
      );

      return;
    }

    final carrinhoConsulta = await CarrinhoDialogView.show(
      context: Get.context!,
    );

    if (carrinhoConsulta != null) {
      try {
        final carrinhoPercursoEstagioConsulta = await adicionarCarrinho(
          carrinhoConsulta,
        );

        if (carrinhoPercursoEstagioConsulta != null) {
          _separarCarrinhosController.editCart(carrinhoPercursoEstagioConsulta);
        } else {
          await MessageDialogView.show(
            context: Get.context!,
            message: 'Erro ao adicionar carrinho!',
            detail: 'Erro ao adicionar carrinho, verifique.',
          );
        }
      } catch (_) {
        // O snackbar do loading já mostrou AppError.display.
      }
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioConsultaModel?> adicionarCarrinho(
    ExpedicaoCarrinhoConsultaModel carrinhoConsulta,
  ) async {
    return await LoadingProcessDialogGenericWidget.show<
      ExpedicaoCarrinhoPercursoEstagioConsultaModel?
    >(
      context: Get.context!,
      process: () =>
          runSocketMutation(() => _adicionarCarrinho(carrinhoConsulta)),
    );
  }

  Future<ExpedicaoCarrinhoPercursoEstagioConsultaModel?> _adicionarCarrinho(
    ExpedicaoCarrinhoConsultaModel carrinhoConsulta,
  ) async {
    await iniciarSeparacao();

    final carrinho = ExpedicaoCarrinhoModel.fromConsulta(carrinhoConsulta)
        .copyWith(situacao: ExpedicaoCarrinhoSituacaoModel.emSeparacao);

    final percursoEstagio = await CarrinhoPercursoEstagioAdicionarService(
      carrinho: carrinho,
      carrinhoPercurso: _carrinhoPercurso!,
    ).execute();

    if (percursoEstagio != null) {
      final percursoEstagioConsulta =
          (await _separarConsultaServices.carrinhosPercurso(
            codCarrinhoPercurso: percursoEstagio.codCarrinhoPercurso,
            item: percursoEstagio.item,
          )).where((el) => el.item == percursoEstagio.item).toList();

      _separarCarrinhosController.addCart(percursoEstagioConsulta.last);
      _separarCarrinhosController.update();
      update();

      return percursoEstagioConsulta.last;
    }

    return null;
  }

  Future<void> btnEditarCarrinho() async {
    await _separarCarrinhosController.editCartFromShortcut();
  }

  Future<void> btnSalvarCarrinho() async {
    await _separarCarrinhosController.saveCartFromShortcut();
  }

  Future<void> btnReabrirCarrinho() async {
    await _separarCarrinhosController.reopenCartFromShortcut();
  }

  Future<void> btnExcluirCarrinho() async {
    await _separarCarrinhosController.removeCartFromShortcut();
  }

  FutureOr<void> recuperarCarrinho() async {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível recuperar carrinho.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Separação cancelada, não é possível recuperar carrinho.',
      );

      return;
    }

    final carrinhoConsulta = await CarrinhoDialogView.show(
      context: Get.context!,
      title: 'Recuperar Carrinho',
    );

    if (carrinhoConsulta != null) {
      final carrinhoPercursoEstagioServices = CarrinhoPercursoEstagioServices();
      final carrinhoService = CarrinhoService();

      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoConsulta.codEmpresa)
          .equals('CodCarrinho', carrinhoConsulta.codCarrinho);

      final carrinhos = await carrinhoService.select(queryBuilder);

      if (carrinhos.isEmpty) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho não encontrado!',
          detail: 'Carrinho não encontrado, verifique.',
        );

        return;
      }

      if (carrinhos.first.situacao != ExpedicaoCarrinhoSituacaoModel.liberado) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho não liberado!',
          detail: 'Carrinho não liberado, verifique.',
        );

        return;
      }

      final carrinhosPercurso = await carrinhoPercursoEstagioServices.select(
        queryBuilder,
      );

      if (carrinhosPercurso.isEmpty) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho não encontrado.',
          detail: 'Verifique. Carrinho nunca esteve em percurso!.',
        );

        return;
      }

      final carrinhoPercurso = carrinhosPercurso.last;

      if (carrinhoPercurso.situacao != ExpedicaoSituacaoModel.cancelada) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho ${carrinhoPercurso.situacao.toLowerCase()}',
          detail: 'O último estágio do carrinho precisa estar cancelado para recuperar.',
        );

        return;
      }

      if (carrinhoPercurso.origem != ExpedicaoOrigemModel.separacao) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Origem não é separação!',
          detail: 'O estágio cancelado não é de separação. Não é possível recuperar.',
        );

        return;
      }

      if (carrinhoPercurso.codOrigem != _separarConsulta.codSepararEstoque) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho de outro documento!',
          detail: 'O último estágio cancelado não pertence a esta separação.',
        );

        return;
      }

      final separacaoItens =
          await SeparacaoConsultaService.getSeparacaoItensCarrinho(
            codEmpresa: carrinhoPercurso.codEmpresa,
            codCarrinhoPercurso: carrinhoPercurso.codCarrinhoPercurso,
            itemCarrinhoPercurso: carrinhoPercurso.item,
          );

      final ExpedicaoCarrinhoPercursoEstagioConsultaModel?
      carrinhoPercursoEstagioConsulta;
      try {
        carrinhoPercursoEstagioConsulta =
            await LoadingProcessDialogGenericWidget.show<
              ExpedicaoCarrinhoPercursoEstagioConsultaModel?
            >(
              context: Get.context!,
              process: () => runSocketMutation(() async {
                final documento = await _separarConsultaServices.separar();
                if (documento == null ||
                    documento.situacao == ExpedicaoSituacaoModel.separado ||
                    documento.situacao == ExpedicaoSituacaoModel.cancelada) {
                  throw AppError('Documento não permite recuperar carrinho.');
                }
                if (separacaoItens.isEmpty) {
                  throw AppError('Não há itens cancelados para recuperar.');
                }
                await CarrinhoRecoveryValidation.assertLatestStage(
                  carrinhoPercurso,
                );
                await CarrinhoRecoveryValidation.reloadAndValidate(
                  codEmpresa: carrinhoPercurso.codEmpresa,
                  codDocumento: carrinhoPercurso.codOrigem,
                  conferencia: false,
                );
                final stage = await _adicionarCarrinho(carrinhoConsulta);
                if (stage == null) {
                  throw AppError('Não foi possível abrir o carrinho.');
                }
                await SeparacaoAdicionarItemService(
                  percursoEstagioConsulta: stage,
                ).addRecuperados(separacaoItens);
                final itens = await _separarConsultaServices.itensSaparar();
                _separarGridController.updateAllGrid(itens);
                _separarGridController.update();
                return stage;
              }),
            );
      } catch (_) {
        return;
      }

      if (carrinhoPercursoEstagioConsulta == null) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Erro ao adicionar carrinho!',
          detail: 'Erro ao adicionar carrinho recuperado, verifique.',
        );

        return;
      }

      _separarCarrinhosController.editCart(carrinhoPercursoEstagioConsulta);
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
        _separarGridController.update();

        return true;
      }),
    );
  }

  Future<void> btnAdicionarObservacao() async {
    final currentSeparar = await _separarConsultaServices.separar();
    if (currentSeparar == null) return;

    _separarConsulta = _separarConsulta.copyWith(
      historico: currentSeparar.historico,
      observacao: currentSeparar.observacao,
    );

    final result = await ObservacaoDialogView.show(
      context: Get.context!,
      viewModel: ObservacaoDialogViewModel(
        title: 'Adicionar Observação',
        historico: currentSeparar.historico,
        observacao: currentSeparar.observacao,
      ),
    );

    if (result != null) {
      _separarConsulta = _separarConsulta.copyWith(
        historico: result.historico,
        observacao: result.observacao,
      );

      final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
      SepararServices.atualizar(separar);
    }
  }

  Future<void> btnFinalizarSeparacao() async {
    final isComplete = await _separarConsultaServices.isComplete();
    final existsOpenCart = await _separarConsultaServices.existsOpenCart();

    final notValidFinalize = [
      ExpedicaoSituacaoModel.cancelada,
      ExpedicaoSituacaoModel.separado,
    ].contains(_expedicaoSituacao);

    if (notValidFinalize) {
      await MessageDialogView.show(
        context: Get.context!,
        message: '$_expedicaoSituacao!',
        detail: '$_expedicaoSituacao, não é possível finalizar.',
      );

      return;
    }

    if (!isComplete) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem itens não separados.',
      );

      return;
    }

    if (existsOpenCart) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem carrinhos em aberto.',
      );

      return;
    }

    // Valida quantidade de todos os carrinhos antes de finalizar
    final carrinhosPercurso = await _separarConsultaServices
        .carrinhosPercurso();
    final carrinhosParaValidar = carrinhosPercurso
        .where((el) => el.situacao != ExpedicaoSituacaoModel.cancelada)
        .toList();

    for (var carrinho in carrinhosParaValidar) {
      final cartIsValid = await _separarConsultaServices.cartIsValid(
        carrinho.codCarrinho,
        itemCarrinhoPercurso: carrinho.item,
      );

      if (!cartIsValid) {
        final itens = await _separarConsultaServices.itensSaparar();
        _separarGridController.updateAllGrid(itens);
        _separarGridController.update();

        await MessageDialogView.show(
          context: Get.context!,
          message: 'Separação não pode ser finalizada!',
          detail:
              'Carrinho "${carrinho.nomeCarrinho}" (${carrinho.codCarrinho}) possui quantidade separada maior que a quantidade a separar. Verifique e corrija antes de finalizar.',
        );

        return;
      }
    }

    final bool? confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja realmente finalizar?',
      detail: 'Não será possível adicionar ou alterar mais os carrinhos.',
    );

    if (confirmation != null && confirmation) {
      await finalizarSeparacao();
      update();
    }
  }

  Future<void> finalizarSeparacao() async {
    try {
      await SepararFinalizarService(
        separarConsulta: _separarConsulta,
        carrinhoPercurso: _carrinhoPercurso!,
      ).execute();

      _separarConsulta.situacao = ExpedicaoSituacaoModel.separado;
      _expedicaoSituacao = ExpedicaoSituacaoModel.separado;
      update();
    } catch (e) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Erro ao finalizar separação!',
        detail: e.toString(),
      );
    }
  }

  Future<void> configuracao() async {
    final confirmation = await IdentificacaoDialogView.show(
      context: Get.context!,
    );

    if (confirmation != null) {
      Get.offNamed(AppRouter.apiConfig);
    }
  }

  void _removeAllliteners() {
    final separarEvent = SepararEventRepository.instancia;
    final carrinhoPercursoEvent = SepararItemEventRepository.instancia;

    separarEvent.removeListeners(_pageListerner);
    carrinhoPercursoEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }

  void _liteners() {
    const uuid = Uuid();
    final separarEvent = SepararEventRepository.instancia;
    final carrinhoPercursoEvent = SepararItemEventRepository.instancia;

    final separarItemConsulta = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: false,
      callback: (data) async {
        for (var el in data.mutation) {
          try {
            final item = ExpedicaoSepararItemConsultaModel.fromJson(el);

            if (_separarConsulta.codEmpresa == item.codEmpresa &&
                _separarConsulta.codSepararEstoque == item.codSepararEstoque) {
              _separarGridController.updateGrid(item);
              _separarGridController.update();
            }
          } catch (error) {
            AppSocketListenLog.error('SepararController.item', error);
          }
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

          if (codEmpresa != _separarConsulta.codEmpresa ||
              codSepararEstoque != _separarConsulta.codSepararEstoque ||
              situacao == null) {
            continue;
          }

          aplicarSituacao(situacao);
        }
      },
    );

    carrinhoPercursoEvent.addListener(separarItemConsulta);
    separarEvent.addListener(separar);

    _pageListerner.add(separar);
    _pageListerner.add(separarItemConsulta);
  }
}
