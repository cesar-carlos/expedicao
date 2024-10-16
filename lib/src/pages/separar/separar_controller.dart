import 'dart:async';

import 'dart:io' as io;

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/send_query_socket_model.dart';
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
    _fillGridSepararItens();
    _fillCarrinhoPercurso();
    _liteners();
  }

  @override
  onClose() {
    _removeAllliteners();
    formFocusNode.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f4) {
        onAdicionarCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f5) {
        btnAdicionarObservacao();
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
          if (value != null && value) io.exit(0);
        });
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _fillGridSepararItens() async {
    final separarItens = await _separarConsultaServices.itensSaparar();
    final separarUnid = await _separarConsultaServices.itensSapararUnidades();

    _separarGridController.addAllGrid(separarItens);
    _separarGridController.addAllUnidade(separarUnid);
    _separarGridController.update();
  }

  Future<void> _fillCarrinhoPercurso() async {
    final params = '''
        CodEmpresa = ${_processoExecutavel.codEmpresa} 
      AND Origem = '${_processoExecutavel.origem}' 
      AND CodOrigem = ${_processoExecutavel.codOrigem} ''';

    final carrinhoPercursos = await CarrinhoPercursoServices().select(params);

    if (carrinhoPercursos.isNotEmpty)
      _carrinhoPercurso = carrinhoPercursos.first;
  }

  Future<void> iniciarSeparacao() async {
    _iniciada = !_iniciada;

    if (_carrinhoPercurso == null) await _fillCarrinhoPercurso();

    final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
    await SepararServices(separar).iniciar();

    _expedicaoSituacao = ExpedicaoSituacaoModel.separando;
    _separarConsulta.situacao = ExpedicaoSituacaoModel.separando;
    update();
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

    final carrinhoConsulta =
        await CarrinhoDialogView.show(context: Get.context!);

    if (carrinhoConsulta != null) {
      final carrinhoPercursoEstagioConsulta =
          await adicionarCarrinho(carrinhoConsulta);

      if (carrinhoPercursoEstagioConsulta != null) {
        _separarCarrinhosController.editCart(carrinhoPercursoEstagioConsulta);
      } else {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Erro ao adicionar carrinho!',
          detail: 'Erro ao adicionar carrinho, verifique.',
        );
      }
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioConsultaModel?> adicionarCarrinho(
    ExpedicaoCarrinhoConsultaModel carrinhoConsulta,
  ) async {
    return await LoadingProcessDialogGenericWidget.show<
        ExpedicaoCarrinhoPercursoEstagioConsultaModel?>(
      context: Get.context!,
      process: () async {
        try {
          await iniciarSeparacao();
          await _fillCarrinhoPercurso();

          final carrinho =
              ExpedicaoCarrinhoModel.fromConsulta(carrinhoConsulta).copyWith(
            situacao: ExpedicaoCarrinhoSituacaoModel.emSeparacao,
          );

          final percursoEstagio = await CarrinhoPercursoEstagioAdicionarService(
            carrinho: carrinho,
            carrinhoPercurso: _carrinhoPercurso!,
          ).execute();

          if (percursoEstagio != null) {
            final percursoEstagioConsulta =
                (await _separarConsultaServices.carrinhosPercurso())
                    .where((el) => el.item == percursoEstagio.item)
                    .toList();

            _separarCarrinhosController.addCart(percursoEstagioConsulta.last);
            _separarCarrinhosController.update();
            update();

            return percursoEstagioConsulta.last;
          }

          return null;
        } catch (err) {
          return null;
        }
      },
    );
  }

  FutureOr<void> recuperarCarrinho() async {
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
      title: 'Recuperar Carrinho',
    );

    if (carrinhoConsulta != null) {
      final carrinhoPercursoEstagioServices = CarrinhoPercursoEstagioServices();
      final carrinhoService = CarrinhoService();

      final params = '''
          CodEmpresa = ${carrinhoConsulta.codEmpresa} 
            AND CodCarrinho = ${carrinhoConsulta.codCarrinho} ''';

      final carrinhos = await carrinhoService.select(params);

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

      final carrinhosPercurso =
          await carrinhoPercursoEstagioServices.select(params, 1, OrderBy.DESC);

      if (carrinhosPercurso.isEmpty) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho não encontrado.',
          detail: 'Verifique. Carrinho nunca esteve em percurso!.',
        );

        return;
      }

      final carrinhoPercuro = carrinhosPercurso.first;

      if (carrinhoPercuro.situacao != ExpedicaoSituacaoModel.cancelada &&
          carrinhoPercuro.situacao != ExpedicaoOrigemModel.separacao) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Carrinho ${carrinhoPercuro.situacao.toLowerCase()}',
          detail:
              'Carrinho percurso com situação diferente de cancelado. Não é possível recuperar.',
        );

        return;
      }

      final separacaoItens =
          await SeparacaoConsultaService.getSeparacaoItensCarrinho(
        codEmpresa: carrinhoPercuro.codEmpresa,
        codCarrinhoPercurso: carrinhoPercuro.codCarrinhoPercurso,
        itemCarrinhoPercurso: carrinhoPercuro.item,
      );

      final carrinhoPercursoEstagioConsulta =
          await adicionarCarrinho(carrinhoConsulta);

      if (carrinhoPercursoEstagioConsulta == null) {
        await MessageDialogView.show(
          context: Get.context!,
          message: 'Erro ao adicionar carrinho!',
          detail: 'Erro ao adicionar carrinho recuperado, verifique.',
        );

        return;
      }

      await adicionarItensRecuperadoSeparacao(
        carrinhoPercursoEstagioConsulta,
        separacaoItens,
      );

      _separarCarrinhosController.editCart(carrinhoPercursoEstagioConsulta);
    }
  }

  Future<bool> adicionarItensRecuperadoSeparacao(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagio,
    List<ExpedicaoSeparacaoItemModel> separacaoItensRecuperado,
  ) async {
    return await LoadingProcessDialogGenericWidget.show<bool>(
      context: Get.context!,
      process: () async {
        try {
          final separarItens = await _separarConsultaServices.itensSaparar();

          final carrinhoPercursoAdicionarItemService =
              SeparacaoAdicionarItemService(
            percursoEstagioConsulta: percursoEstagio,
          );

          for (var item in separacaoItensRecuperado) {
            final existsSepararItem = separarItens.any((el) {
              return el.codProduto == item.codProduto &&
                  el.codUnidadeMedida == item.codUnidadeMedida;
            });

            if (existsSepararItem) {
              await carrinhoPercursoAdicionarItemService.add(
                codProduto: item.codProduto,
                codUnidadeMedida: item.codUnidadeMedida,
                quantidade: item.quantidade,
              );
            }
          }

          final newSepararItens = await _separarConsultaServices.itensSaparar();
          _separarGridController.updateAllGrid(newSepararItens);
          _separarGridController.update();

          return true;
        } catch (err) {
          return false;
        }
      },
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
      ExpedicaoSituacaoModel.separado
    ].contains(_expedicaoSituacao);

    if (notValidFinalize) {
      await MessageDialogView.show(
        context: Get.context!,
        message: '${_expedicaoSituacao}!',
        detail: '${_expedicaoSituacao}, não é possível finalizar.',
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

  _liteners() {
    const uuid = Uuid();
    final separarEvent = SepararEventRepository.instancia;
    final carrinhoPercursoEvent = SepararItemEventRepository.instancia;

    final separarItemConsulta = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoSepararItemConsultaModel.fromJson(el);

          if (_separarConsulta.codEmpresa == item.codEmpresa &&
              _separarConsulta.codSepararEstoque == item.codSepararEstoque) {
            _separarGridController.updateGrid(item);
            _separarGridController.update();
          }
        }
      },
    );

    final separar = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoSepararModel.fromJson(el);

          if (_separarConsulta.codEmpresa == item.codEmpresa &&
              _separarConsulta.codSepararEstoque == item.codSepararEstoque) {
            _expedicaoSituacao = item.situacao;
            _separarConsulta.situacao = item.situacao;
            update();
          }
        }
      },
    );

    carrinhoPercursoEvent.addListener(separarItemConsulta);
    separarEvent.addListener(separar);

    _pageListerner.add(separar);
    _pageListerner.add(separarItemConsulta);
  }
}
