import 'dart:async';
import 'dart:io' as io;

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/service/conferir_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/observacao_dialog_view.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_event_repository.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar_assistente/carrinhos_agrupar_assistente_view.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar_assistente/model/carrinhos_agrupar_assistente_view_model.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/model/observacao_dialog_view_model.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/common/carrinho_dialog/carrinho_dialog_view.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/carrinhos_agrupar_page.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/conferencia_finalizar_service.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';

class ConferirController extends GetxController {
  bool _iniciada = false;

  late FocusNode formFocusNode;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late String _expedicaoSituacao;
  late ConferirConsultaServices _conferirConsultaServices;
  late ConferirCarrinhosController _conferirCarrinhosController;
  late ConferidoCarrinhosController _conferidoCarrinhosController;

  late ExpedicaoConferirConsultaModel _conferirConsulta;
  late ProcessoExecutavelModel _processoExecutavel;

  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;

  ExpedicaoConferirConsultaModel get conferirConsulta => _conferirConsulta;

  bool get iniciada {
    if (_carrinhoPercurso == null) {
      _iniciada = false;
      return _iniciada;
    } else {
      _iniciada = true;
      return _iniciada;
    }
  }

  String get expedicaoSituacaoModel => _expedicaoSituacao;
  String get expedicaoSituacaoDisplay {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      return ExpedicaoSituacaoModel.finalizada;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.agrupado) {
      return ExpedicaoSituacaoModel.agrupado;
    }

    return ExpedicaoSituacaoModel.situacao[_expedicaoSituacao] ?? '';
  }

  @override
  onInit() async {
    super.onInit();
    formFocusNode = FocusNode();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();
    _conferirCarrinhosController = Get.find<ConferirCarrinhosController>();
    _conferidoCarrinhosController = Get.find<ConferidoCarrinhosController>();
    _expedicaoSituacao = _conferirConsulta.situacao;

    _conferirConsultaServices = ConferirConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codConferir: _processoExecutavel.codOrigem,
    );
  }

  @override
  onReady() async {
    formFocusNode.requestFocus();
    await _fillCarrinhoConferir();
    await _fillCarrinhoPercurso();
    _liteners();
    super.onReady();
  }

  @override
  onClose() {
    _removeAllliteners();
    formFocusNode.dispose();
    Get.find<AppEventState>()..canCloseWindow = true;
    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f4) {
        btnConferirCarrinho();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f5) {
        btnAdicionarObservacao();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f7) {
        btnAssistenteAgrupamento();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f12) {
        btnFinalizarConferencia();
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

  Future<void> _fillCarrinhoConferir() async {
    final carrinhoConferirConsulta =
        await _conferirConsultaServices.carrinhosConferir();
    _conferirCarrinhosController.addAllCarrinho(carrinhoConferirConsulta);

    _conferirCarrinhosController.update();
  }

  Future<void> _fillCarrinhoPercurso() async {
    final params = '''
        CodEmpresa = ${_conferirConsulta.codEmpresa}
      AND Origem = '${_conferirConsulta.origem}'
      AND CodOrigem = ${_conferirConsulta.codOrigem} ''';

    final carrinhoPercursos = await CarrinhoPercursoServices().select(params);

    if (carrinhoPercursos.isNotEmpty) {
      _carrinhoPercurso = carrinhoPercursos.first;
    }
  }

  Future<void> iniciarConferencia() async {
    _iniciada = !_iniciada;
    if (_carrinhoPercurso == null) await _fillCarrinhoPercurso();

    final conferir = ExpedicaoConferirModel.fromConsulta(_conferirConsulta);
    _expedicaoSituacao = conferir.situacao;

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.emPausa ||
        _expedicaoSituacao == ExpedicaoSituacaoModel.aguardando) {
      _conferirConsulta.situacao = ExpedicaoSituacaoModel.emConverencia;
      await ConferirServices(conferir).iniciar();
      update();
    }
  }

  Future<void> pausarConferencia() async {
    await MessageDialogView.show(
      context: Get.context!,
      message: 'Não implementado!',
      detail: 'Não é possível pausar, funcionalidade não foi implementada.',
    );
  }

  FutureOr<void> btnConferirCarrinho() async {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia já finalizada!',
        detail: 'Conferencia já finalizada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia já embalada!',
        detail: 'Conferencia embalada, não é possível adicionar carrinhos.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia cancelada!',
        detail: 'Conferencia cancelada, não é possível adicionar carrinhos.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.entregue) {
      await MessageDialogView.show(
          context: Get.context!,
          message: 'Conferencia entregue!',
          detail: 'Conferencia entregue, não é possível adicionar carrinhos.');

      return;
    }

    final carrinhoConsulta = await CarrinhoDialogView.show(
      context: Get.context!,
    );

    if (carrinhoConsulta != null) {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            await iniciarConferencia();

            final carrinho = ExpedicaoCarrinhoModel(
              codEmpresa: carrinhoConsulta.codEmpresa,
              codCarrinho: carrinhoConsulta.codCarrinho,
              descricao: carrinhoConsulta.descricaoCarrinho,
              ativo: carrinhoConsulta.ativo,
              codigoBarras: carrinhoConsulta.codigoBarras,
              situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
            );

            final percursoEstagio =
                await CarrinhoPercursoEstagioAdicionarService(
              carrinho: carrinho,
              carrinhoPercurso: _carrinhoPercurso!,
            ).execute();

            if (percursoEstagio != null) {
              final percursoEstagioConsulta =
                  (await _conferirConsultaServices.carrinhosPercurso())
                      .where((el) => el.item == percursoEstagio.item)
                      .toList();

              _conferidoCarrinhosController
                  .addCarrinho(percursoEstagioConsulta.last);

              _conferidoCarrinhosController.editCart(
                percursoEstagioConsulta.last,
              );

              _conferidoCarrinhosController.update();
              update();
            }

            return true;
          } catch (err) {
            return false;
          }
        },
      );
    }
  }

  Future<void> btnAdicionarObservacao() async {
    final currentConferir = await _conferirConsultaServices.conferir();
    if (currentConferir == null) return;

    _conferirConsulta = _conferirConsulta.copyWith(
      historico: currentConferir.historico,
      observacao: currentConferir.observacao,
    );

    final result = await ObservacaoDialogView.show(
      context: Get.context!,
      viewModel: ObservacaoDialogViewModel(
        title: 'Adicionar Observação',
        historico: currentConferir.historico,
        observacao: currentConferir.observacao,
      ),
    );

    if (result != null) {
      _conferirConsulta = _conferirConsulta.copyWith(
        historico: result.historico,
        observacao: result.observacao,
      );

      final separar = ExpedicaoConferirModel.fromConsulta(_conferirConsulta);
      ConferirServices.atualizar(separar);
    }
  }

  Future<void> btnAssistenteAgrupamento() async {
    bool _isValidGroupCart = [
      ExpedicaoSituacaoModel.emAndamento,
      ExpedicaoSituacaoModel.emConverencia,
      ExpedicaoSituacaoModel.conferindo
    ].contains(conferirConsulta.situacao);

    if (!_isValidGroupCart) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia finalizada!',
        detail: 'Conferencia finalizada, não é possível agrupar carrinhos.',
      );

      return;
    }

    final result = await CarrinhosAgruparAssistenteView.show(
      context: Get.context!,
      input: CarrinhosAgruparAssistenteViewModel(
        codEmpresa: _processoExecutavel.codEmpresa,
        origem: _processoExecutavel.origem,
        codOrigem: _processoExecutavel.codOrigem,
      ),
    );

    if (result != null) {
      await CarrinhosAgruparPage.show(
        size: Get.size,
        viewMode: false,
        context: Get.context!,
        carrinhoPercursoAgrupamento: result,
      );
    }
  }

  Future<void> btnFinalizarConferencia() async {
    final isComplete = await _conferirConsultaServices.isComplete();
    final existsOpenCart = await _conferirConsultaServices.existsOpenCart();

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia cancelada!',
        detail: 'Conferencia cancelada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia embalada!',
        detail: 'Conferencia embalada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.entregue) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia entregue!',
        detail: 'Conferencia entregue, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia já finalizada!',
        detail: 'Conferencia já finalizada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia já embalada!',
        detail: 'Conferencia já embalada, não é possível finalizar novamente.',
      );

      return;
    }

    if (!isComplete) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia não finalizada!',
        detail: 'Conferencia não finalizada, existem itens não separados.',
      );

      return;
    }

    if (existsOpenCart) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia não finalizada!',
        detail: 'Conferencia não finalizada, existem carrinhos em aberto.',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja realmente finalizar?',
      detail: 'Não será possível adicionar ou alterar mais os carrinhos.',
    );

    if (confirmation != null && confirmation) await finalizarConferencia();
  }

  Future<void> finalizarConferencia() async {
    await ConferirFinalizarService(
      codEmpresa: _conferirConsulta.codEmpresa,
      codConferir: _conferirConsulta.codConferir,
    ).execute();

    _expedicaoSituacao = ExpedicaoSituacaoModel.conferido;
    _conferirConsulta.situacao = ExpedicaoSituacaoModel.conferido;
    update();
  }

  _liteners() {
    const uuid = Uuid();
    final conferirEvent = ConferirEventRepository.instancia;

    // _socketClient.isConnect.listen((event) {
    //   if (event) return;
    //   LoadingSeverDialogWidget.show(
    //     context: Get.context!,
    //     canCloseWindow: true,
    //   );
    // });

    final conferir = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoConferirModel.fromJson(el);

          if (_conferirConsulta.codEmpresa == item.codEmpresa &&
              _conferirConsulta.origem == item.origem &&
              _conferirConsulta.codConferir == item.codConferir) {
            _expedicaoSituacao = item.situacao;
            _conferirConsulta.situacao = item.situacao;
            update();
          }
        }
      },
    );

    conferirEvent.addListener(conferir);
    _pageListerner.add(conferir);
  }

  void _removeAllliteners() {
    final conferirEvent = ConferirEventRepository.instancia;
    conferirEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }
}
