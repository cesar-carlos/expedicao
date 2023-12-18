import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_event_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_event_repository.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';

class ConferirCarrinhosController extends GetxController {
  late String _expedicaoSituacao;
  late ProcessoExecutavelModel _processoExecutavel;
  final List<RepositoryEventListenerModel> _pageListerner = [];

  late ConferirConsultaServices _conferirServices;
  late ConferirCarrinhoGridController _conferirCarrinhoGridController;
  late ExpedicaoConferirConsultaModel _conferirConsulta;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoConferirConsultaModel get conferirConsulta => _conferirConsulta;

  String get expedicaoSituacaoDisplay {
    if (_expedicaoSituacao == ExpedicaoSituacaoModel.conferido) {
      return ExpedicaoSituacaoModel.finalizada;
    }

    return ExpedicaoSituacaoModel.situacao[_expedicaoSituacao] ?? '';
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
    _evetsCarrinhoGrid();
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

  _evetsCarrinhoGrid() {}

  _liteners() {
    const uuid = Uuid();
    final carrinhoEvent = CarrinhoEventRepository.instancia;
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final conferirEventRepository = ConferirEventRepository.instancia;

    carrinhoEvent.addListener(RepositoryEventListenerModel(
      id: uuid.v4(),
      allEvent: true,
      event: Event.update,
      callback: (data) async {
        for (var el in data.mutation) {
          final carrinho = ExpedicaoCarrinhoConsultaModel.fromJson(el);
          _conferirCarrinhoGridController.updateGridSituationCarrinho(
            carrinho.codCarrinho,
            carrinho.situacao,
          );

          _conferirCarrinhoGridController.update();
        }
      },
    ));

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            if (item.codEmpresa == _processoExecutavel.codEmpresa &&
                item.origem == _processoExecutavel.origem &&
                item.codOrigem == _processoExecutavel.codOrigem) {
              // _conferirCarrinhoGridController.addGrid(item);
              // _conferirCarrinhoGridController.update();
            }
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            //_conferirCarrinhoGridController.updateGrid(item);
            //_conferirCarrinhoGridController.update();
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            //_conferirCarrinhoGridController.removeGrid(item);
            // _conferirCarrinhoGridController.update();
          }
        },
      ),
    );

    conferirEventRepository.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        allEvent: true,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoConferirConsultaModel.fromJson(el);
            _conferirConsulta = item;
            _expedicaoSituacao = item.situacao;
            update();
          }
        },
      ),
    );
  }

  void _removeliteners() {
    final carrinhoEvent = CarrinhoEventRepository.instancia;
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    final conferirEventRepository = ConferirEventRepository.instancia;

    carrinhoEvent.removeListeners(_pageListerner);
    conferirEventRepository.removeListeners(_pageListerner);
    carrinhoPercursoEvent.removeListeners(_pageListerner);
  }
}
