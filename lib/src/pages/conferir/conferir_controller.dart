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
import 'package:app_expedicao/src/pages/conferir/widget/conferir_obs_dialog_widget.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_event_repository.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/conferencia_finalizar_service.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ConferirController extends GetxController {
  bool _iniciada = false;
  final List<RepositoryEventListenerModel> _pageListerner = [];
  late AppSocketConfig _socketClient;

  late String _expedicaoSituacao;

  late TextEditingController historicoController;
  late TextEditingController observacaoController;

  late ConferirConsultaServices _conferirConsultaServices;
  late ConferirCarrinhosController _conferirCarrinhosController;
  late ConferidoCarrinhosController _conferidoCarrinhosController;

  late ExpedicaoConferirConsultaModel _conferirConsulta;
  late ProcessoExecutavelModel _processoExecutavel;

  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;

  ExpedicaoConferirConsultaModel get conferirConsulta => _conferirConsulta;

  final FocusNode keyressFocusNode = FocusNode();

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

    return ExpedicaoSituacaoModel.situacao[_expedicaoSituacao] ?? '';
  }

  @override
  onInit() async {
    super.onInit();

    _socketClient = Get.find<AppSocketConfig>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();
    _conferirCarrinhosController = Get.find<ConferirCarrinhosController>();
    _conferidoCarrinhosController = Get.find<ConferidoCarrinhosController>();
    _expedicaoSituacao = _conferirConsulta.situacao;

    _conferirConsultaServices = ConferirConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codConferir: _processoExecutavel.codOrigem,
    );

    historicoController = TextEditingController();
    observacaoController = TextEditingController();
  }

  @override
  onReady() async {
    super.onReady();

    await _fillCarrinhoConferir();
    await _fillCarrinhoPercurso();
    _liteners();
  }

  @override
  onClose() {
    _removeAllliteners();
    historicoController.dispose();
    observacaoController.dispose();
    keyressFocusNode.dispose();
    Get.find<AppEventState>()..canCloseWindow = true;
    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      ConfirmationDialogWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Deseja realmente sair?',
        detail: 'A tela será fechada e a separação não será  cancelada.',
      ).then((value) {
        if (value != null && value) {
          io.exit(0);
        }
      });
    }

    return KeyEventResult.ignored;
  }

  Future<void> _fillCarrinhoConferir() async {
    final conferirCarr = await _conferirConsultaServices.carrinhosConferir();
    _conferirCarrinhosController.addAllCarrinho(conferirCarr);
    _conferirCarrinhosController.update();
  }

  Future<void> _fillCarrinhoPercurso() async {
    final params = '''
        CodEmpresa = ${_conferirConsulta.codEmpresa}
      AND Origem = '${_conferirConsulta.origem}'
      AND CodOrigem = ${_conferirConsulta.codOrigem}

    ''';

    final carrinhoPercursos = await CarrinhoPercursoServices().select(params);

    if (carrinhoPercursos.isNotEmpty) {
      _carrinhoPercurso = carrinhoPercursos.first;
    }
  }

  Future<void> iniciarConferencia() async {
    _iniciada = !_iniciada;
    if (_carrinhoPercurso == null) {
      await _fillCarrinhoPercurso();
    }

    final conferir = ExpedicaoConferirModel.fromConsulta(_conferirConsulta);
    _expedicaoSituacao = conferir.situacao;

    if (_expedicaoSituacao != ExpedicaoSituacaoModel.conferido) {
      _conferirConsulta.situacao = ExpedicaoSituacaoModel.emAndamento;
      await ConferirServices(conferir).iniciar();
      update();
    }
  }

  Future<void> pausarConferencia() async {
    await ConfirmationDialogMessageWidget.show(
      canCloseWindow: false,
      context: Get.context!,
      message: 'Não implementado!',
      detail: 'Não é possível pausar, funcionalidade não foi implementada.',
    );
  }

  Future<void> btnAdicionarCarrinho() async {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Conferencia já finalizada!',
        detail: 'Conferencia já finalizada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Conferencia já embalada!',
        detail: 'Conferencia já embalada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Conferencia cancelada!',
        detail: 'Conferencia cancelada, não é possível adicionar carrinhos.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.entregue) {
      await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Conferencia entregue!',
          detail: 'Conferencia entregue, não é possível adicionar carrinhos.');

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Conferencia em andamento!',
        detail: 'Conferencia embalada, não é possível adicionar carrinhos.',
      );

      return;
    }

    await iniciarConferencia();

    final dialog = AdicionarCarrinhoDialogWidget(canCloseWindow: false);

    final carrinhoConsulta = await dialog.show();

    if (carrinhoConsulta != null) {
      final carrinho = ExpedicaoCarrinhoModel(
        codEmpresa: carrinhoConsulta.codEmpresa,
        codCarrinho: carrinhoConsulta.codCarrinho,
        descricao: carrinhoConsulta.descricaoCarrinho,
        ativo: carrinhoConsulta.ativo,
        codigoBarras: carrinhoConsulta.codigoBarras,
        situacao: ExpedicaoCarrinhoSituacaoModel.conferindo,
      );

      final percursoEstagio = await CarrinhoPercursoEstagioAdicionarService(
        carrinho: carrinho,
        carrinhoPercurso: _carrinhoPercurso!,
      ).execute();

      if (percursoEstagio != null) {
        final percursoEstagioConsulta =
            (await _conferirConsultaServices.carrinhosPercurso())
                .where((el) => el.item == percursoEstagio.item)
                .toList();

        _conferidoCarrinhosController.addCarrinho(percursoEstagioConsulta.last);
        _conferidoCarrinhosController.update();
        update();
      }
    }
  }

  Future<void> btnAdicionarObservacao() async {
    final currentConferir = await _conferirConsultaServices.conferir();

    historicoController.text = currentConferir?.historico
            ?.toLowerCase()
            .replaceAll('null', '')
            .trim() ??
        '';

    observacaoController.text = currentConferir?.observacao
            ?.toLowerCase()
            .replaceAll('null', '')
            .trim() ??
        '';

    final result = await ConferirOBsDialogWidget(canCloseWindow: false).show();
    if (result != null) {
      _conferirConsulta.historico = historicoController.text;
      _conferirConsulta.observacao = observacaoController.text;

      final conferir = ExpedicaoConferirModel.fromConsulta(_conferirConsulta);
      ConferirServices(conferir).atualizar();
    }
  }

  Future<void> btnFinalizarConferencia() async {
    final isComplete = await _conferirConsultaServices.isComplete();
    final existsOpenCart = await _conferirConsultaServices.existsOpenCart();

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia cancelada!',
        detail: 'Conferencia cancelada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia embalada!',
        detail: 'Conferencia embalada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.entregue) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia entregue!',
        detail: 'Conferencia entregue, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia já finalizada!',
        detail: 'Conferencia já finalizada, não é possível finalizar.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.embalando) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia já embalada!',
        detail: 'Conferencia já embalada, não é possível finalizar novamente.',
      );

      return;
    }

    if (!isComplete) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia não finalizada!',
        detail: 'Conferencia não finalizada, existem itens não separados.',
      );

      return;
    }

    if (existsOpenCart) {
      await ConfirmationDialogMessageWidget.show(
        canCloseWindow: true,
        context: Get.context!,
        message: 'Conferencia não finalizada!',
        detail: 'Conferencia não finalizada, existem carrinhos em aberto.',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      canCloseWindow: true,
      context: Get.context!,
      message: 'Deseja realmente finalizar?',
      detail: 'Não será possível adicionar ou alterar mais os carrinhos.',
    );

    if (confirmation != null && confirmation) {
      await finalizarConferencia();
    }
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

    _socketClient.isConnect.listen((event) {
      if (event) return;
      LoadingSeverDialogWidget.show(
        context: Get.context!,
        canCloseWindow: true,
      );
    });

    final conferir = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final item = ExpedicaoConferirModel.fromJson(el);
          if (_conferirConsulta.codEmpresa == item.codEmpresa &&
              _conferirConsulta.codConferir == item.codConferir) {
            _expedicaoSituacao = item.situacao;
            _conferirConsulta.situacao = item.situacao;
            update();
          }
        }
      },
    );

    _pageListerner.add(conferir);
    conferirEvent.addListener(conferir);
  }

  void _removeAllliteners() {
    final conferirEvent = ConferirEventRepository.instancia;

    conferirEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }
}
