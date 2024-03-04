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
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class ConferirCarrinhosController extends GetxController {
  late String _expedicaoSituacao;
  late ProcessoExecutavelModel _processoExecutavel;

  final _conferirEvent = ConferirEventRepository.instancia;

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

  Color get colorIndicator {
    if (_conferirConsulta.situacao == ExpedicaoSituacaoModel.cancelada)
      return Colors.red;

    if (_conferirConsulta.situacao == ExpedicaoSituacaoModel.conferido)
      return Colors.green;

    return Colors.orange;
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

  _liteners() {
    const uuid = Uuid();

    _conferirEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        allEvent: true,
        callback: (data) async {
          for (var el in data.mutation) {
            final event = ExpedicaoConferirConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.codConferir == _processoExecutavel.codOrigem) {
              _conferirConsulta = event;
              _expedicaoSituacao = event.situacao;
              update();
            }
          }
        },
      ),
    );

    _carrinhoPercursoEstagioEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.insert,
        allEvent: true,
        callback: (data) async {
          for (var el in data.mutation) {
            final event =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.origem == _processoExecutavel.origem &&
                event.codOrigem == _processoExecutavel.codOrigem) {
              _conferirServices
                  .carrinhoConferir(event.codCarrinho)
                  .then((value) {
                _conferirCarrinhoGridController.updateGrid(value);
                _conferirCarrinhoGridController.update();
              });
            }
          }
        },
      ),
    );

    _carrinhoPercursoEstagioEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        allEvent: true,
        callback: (data) async {
          for (var el in data.mutation) {
            final event =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.origem == _processoExecutavel.origem &&
                event.codOrigem == _processoExecutavel.codOrigem) {
              _conferirServices
                  .carrinhoConferir(event.codCarrinho)
                  .then((value) {
                _conferirCarrinhoGridController.updateGrid(value);
                _conferirCarrinhoGridController.update();
              });
            }
          }
        },
      ),
    );
  }

  void _removeliteners() {}
}
