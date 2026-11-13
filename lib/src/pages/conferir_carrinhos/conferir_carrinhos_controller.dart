import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_event_repository.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_event_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';

class ConferirCarrinhosController extends GetxController {
  late String _expedicaoSituacao;
  late ProcessoExecutavelModel _processoExecutavel;

  final _conferirEvent = ConferirEventRepository.instancia;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  final _carrinhoPercursoEstagioEvent =
      CarrinhoPercursoEstagioEventRepository.instancia;

  late ConferirConsultaServices _conferirServices;
  late ConferirCarrinhoGridController _conferirCarrinhoGridController;
  late ExpedicaoConferirConsultaModel _conferirConsulta;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoConferirConsultaModel get conferirConsulta => _conferirConsulta;

  String get expedicaoSituacaoDisplay {
    return _expedicaoSituacao;
  }

  void aplicarSituacao(String situacao) {
    if (situacao.isEmpty) return;
    if (_expedicaoSituacao == situacao &&
        _conferirConsulta.situacao == situacao) {
      AppSocketListenLog.applied(
        origem: 'ConferirCarrinhosController',
        situacao: situacao,
        extra: 'sem mudanca',
      );
      return;
    }

    _expedicaoSituacao = situacao;
    _conferirConsulta.situacao = situacao;
    AppSocketListenLog.applied(
      origem: 'ConferirCarrinhosController',
      situacao: situacao,
    );
    update();
  }

  Color get colorIndicator {
    switch (_expedicaoSituacao) {
      case ExpedicaoSituacaoModel.cancelada:
        return Colors.red;
      case ExpedicaoSituacaoModel.conferido:
        return Colors.green;
      case ExpedicaoSituacaoModel.embalando:
      case ExpedicaoSituacaoModel.entregue:
      case ExpedicaoSituacaoModel.emEntrega:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();

    _conferirCarrinhoGridController =
        Get.find<ConferirCarrinhoGridController>();

    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    _conferirServices = ConferirConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codConferir: _processoExecutavel.codOrigem,
    );

    _expedicaoSituacao = _conferirConsulta.situacao;
  }

  @override
  onReady() async {
    super.onReady();
    _liteners();
  }

  @override
  void onClose() {
    _removeliteners();
    super.onClose();
  }

  void addCarrinho(ExpedicaoCarrinhoConferirConsultaModel model) {
    _conferirCarrinhoGridController.addGrid(model);
    _conferirCarrinhoGridController.update();
  }

  void addAllCarrinho(List<ExpedicaoCarrinhoConferirConsultaModel> models) {
    _conferirCarrinhoGridController.addAllGrid(models);
    _conferirCarrinhoGridController.update();
  }

  void replaceCarrinhos(List<ExpedicaoCarrinhoConferirConsultaModel> models) {
    if (isClosed) return;
    _conferirCarrinhoGridController.removeAllGrid();
    _conferirCarrinhoGridController.addAllGrid(models);
    _conferirCarrinhoGridController.update();
  }

  void _liteners() {
    const uuid = Uuid();

    final conferir = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: true,
      callback: (data) async {
        for (var el in data.mutation) {
          final codEmpresa = AppSocketListenLog.asInt(el['CodEmpresa']);
          final codConferir = AppSocketListenLog.asInt(el['CodConferir']);
          final situacao = AppSocketListenLog.asString(el['Situacao']);

          if (codEmpresa != _processoExecutavel.codEmpresa ||
              codConferir != _processoExecutavel.codOrigem ||
              situacao == null) {
            continue;
          }

          aplicarSituacao(situacao);
        }
      },
    );

    final insertCarrinho = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.insert,
      allEvent: false,
      callback: (data) async {
        await _aplicarCarrinhoPercurso(
          data,
          origem: 'ConferirCarrinhosController.insert',
        );
      },
    );

    final updateCarrinho = RepositoryEventListenerModel(
      id: uuid.v4(),
      event: Event.update,
      allEvent: true,
      callback: (data) async {
        await _aplicarCarrinhoPercurso(
          data,
          origem: 'ConferirCarrinhosController.update',
        );
      },
    );

    _conferirEvent.addListener(conferir);
    _carrinhoPercursoEstagioEvent.addListener(insertCarrinho);
    _carrinhoPercursoEstagioEvent.addListener(updateCarrinho);
    _pageListerner.add(conferir);
    _pageListerner.add(insertCarrinho);
    _pageListerner.add(updateCarrinho);
  }

  Future<void> _aplicarCarrinhoPercurso(
    BasicEventModel data, {
    required String origem,
  }) async {
    final propriaSessao = AppSocketListenLog.isOwnSession(
      envelopeSession: data.session,
      socketId: Get.find<AppSocketConfig>().sessionId,
    );

    for (var el in data.mutation) {
      try {
        final event = ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(
          el,
        );

        if (event.codEmpresa != _processoExecutavel.codEmpresa ||
            event.origem != _processoExecutavel.origem ||
            event.codOrigem != _processoExecutavel.codOrigem) {
          continue;
        }

        AppSocketListenLog.applied(
          origem: origem,
          situacao: event.situacao,
          extra:
              'carrinho=${event.codCarrinho} item=${event.item} propriaSessao=$propriaSessao',
        );

        final value = await _conferirServices.carrinhoConferir(
          event.codCarrinho,
        );
        final alreadyInGrid = _conferirCarrinhoGridController.itens.any(
          (el) => el.itemCarrinhoPercurso == value.itemCarrinhoPercurso,
        );
        if (alreadyInGrid) {
          _conferirCarrinhoGridController.updateGrid(value);
        } else if (!propriaSessao) {
          _conferirCarrinhoGridController.addGrid(value);
        }
        _conferirCarrinhoGridController.update();
      } catch (error) {
        AppSocketListenLog.error(origem, error);
      }
    }
  }

  void _removeliteners() {
    _conferirEvent.removeListeners(_pageListerner);
    _carrinhoPercursoEstagioEvent.removeListeners(_pageListerner);
    _pageListerner.clear();
  }
}
