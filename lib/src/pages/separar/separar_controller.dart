import 'dart:io' as io;

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/service/conferir_separacao_adicionar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog_widget.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';
import 'package:app_expedicao/src/pages/Identificacao/wedgets/identificacao_dialog_widget.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_event_repository.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/pages/separar/widget/separar_obs_dialog_widget.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/pages/carrinho/carrinho_controller.dart';
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
  late AppSocketConfig _socketClient;

  late TextEditingController historicoController;
  late TextEditingController observacaoController;

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
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.separado) {
      return ExpedicaoSituacaoModel.finalizada;
    }

    return ExpedicaoSituacaoModel.situacao[_expedicaoSituacao] ?? '';
  }

  @override
  onInit() async {
    super.onInit();
    _socketClient = Get.find<AppSocketConfig>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarCarrinhosController = Get.find<SeparadoCarrinhosController>();
    _separarGridController = Get.find<SepararGridController>();
    _expedicaoSituacao = _separarConsulta.situacao;

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    historicoController = TextEditingController();
    observacaoController = TextEditingController();

    historicoController.addListener(() {
      final txt = historicoController.text.toUpperCase();
      historicoController.value = historicoController.value.copyWith(
        text: txt,
        selection:
            TextSelection(baseOffset: txt.length, extentOffset: txt.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  onReady() async {
    super.onReady();
    await _fillGridSepararItens();
    await _fillCarrinhoPercurso();
    _liteners();
  }

  @override
  onClose() {
    _removeAllliteners();
    historicoController.dispose();
    observacaoController.dispose();
    super.onClose();
  }

  KeyEventResult handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      ConfirmationDialogWidget.show(
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
      AND CodOrigem = ${_processoExecutavel.codOrigem}
      
    ''';

    final carrinhoPercursos = await CarrinhoPercursoServices().select(params);

    if (carrinhoPercursos.isNotEmpty) {
      _carrinhoPercurso = carrinhoPercursos.first;
    }
  }

  Future<void> iniciarSeparacao() async {
    _iniciada = !_iniciada;
    if (_carrinhoPercurso == null) {
      await _fillCarrinhoPercurso();
    }

    final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
    await SepararServices(separar).iniciar();
    _expedicaoSituacao = ExpedicaoSituacaoModel.emAndamento;
    _separarConsulta.situacao = ExpedicaoSituacaoModel.emAndamento;
    update();
  }

  Future<void> pausarSeparacao() async {
    await ConfirmationDialogMessageWidget.show(
      context: Get.context!,
      message: 'Não implementado!',
      detail: 'Não é possível pausar, funcionalidade não foi implementada.',
    );
  }

  Future<void> adicionarCarrinho() async {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.separado) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível finalizar novamente.',
      );

      return;
    }

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.cancelada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Separação cancelada, não é possível adicionar carrinho.',
      );

      return;
    }

    final carrinhoController = CarrinhoController();
    final dialog = AdicionarCarrinhoDialogWidget(carrinhoController);
    final carrinhoConsulta = await dialog.show();

    if (carrinhoConsulta != null) {
      await iniciarSeparacao();
      await _fillCarrinhoPercurso();

      final carrinho = ExpedicaoCarrinhoModel(
        codEmpresa: carrinhoConsulta.codEmpresa,
        codCarrinho: carrinhoConsulta.codCarrinho,
        descricao: carrinhoConsulta.descricaoCarrinho,
        ativo: carrinhoConsulta.ativo,
        codigoBarras: carrinhoConsulta.codigoBarras,
        situacao: ExpedicaoCarrinhoSituacaoModel.emSeparacao,
      );

      final percursoEstagio = await CarrinhoPercursoEstagioAdicionarService(
        carrinho: carrinho,
        carrinhoPercurso: _carrinhoPercurso!,
      ).execute();

      if (percursoEstagio != null) {
        final percursoEstagioConsulta =
            await _separarConsultaServices.carrinhosPercurso()
              ..where((el) => el.item == percursoEstagio.item).toList();

        _separarCarrinhosController.addCarrinho(percursoEstagioConsulta.last);
        _separarCarrinhosController.update();
        update();
      }
    }
  }

  Future<void> btnAdicionarObservacao() async {
    final currentSeparar = await _separarConsultaServices.separar();

    historicoController.text = currentSeparar?.historico
            ?.toLowerCase()
            .replaceAll('null', '')
            .trim() ??
        '';

    observacaoController.text = currentSeparar?.observacao
            ?.toLowerCase()
            .replaceAll('null', '')
            .trim() ??
        '';

    final result = await SepararOBsDialogWidget().show();
    if (result != null) {
      _separarConsulta.historico = historicoController.text;
      _separarConsulta.observacao = observacaoController.text;

      final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
      SepararServices(separar).atualizar();
    }
  }

  Future<void> btnFinalizarSeparacao() async {
    final isComplete = await _separarConsultaServices.isComplete();
    final existsOpenCart = await _separarConsultaServices.existsOpenCart();

    if (_expedicaoSituacao == ExpedicaoSituacaoModel.separado) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível finalizar novamente.',
      );

      return;
    }

    if (!isComplete) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem itens não separados.',
      );

      return;
    }

    if (existsOpenCart) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem carrinhos em aberto.',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
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
    await SepararFinalizarService(
      codEmpresa: _separarConsulta.codEmpresa,
      codSepararEstoque: _separarConsulta.codSepararEstoque,
    ).execute();

    _expedicaoSituacao = ExpedicaoSituacaoModel.separado;
    _separarConsulta.situacao = ExpedicaoSituacaoModel.separado;

    await ConferirSeparacaoAdicionarService(
      carrinhoPercurso: _carrinhoPercurso!,
    ).execute();

    update();
  }

  Future<void> configuracao() async {
    final confirmation = await IdentificacaoDialogWidget().show();
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

    _socketClient.isConnect.listen((event) {
      if (event) return;
      LoadingSeverDialogWidget.show(context: Get.context!);
    });

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

    _pageListerner.add(separar);
    _pageListerner.add(separarItemConsulta);

    carrinhoPercursoEvent.addListener(separarItemConsulta);
    separarEvent.addListener(separar);
  }
}
