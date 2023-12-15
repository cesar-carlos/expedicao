import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_event_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/service/carrinho_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';

class ConferirCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  final List<RepositoryEventListenerModel> _pageListerner = [];
  //late ConferirGridController _conferirGridController;
  late ConferirCarrinhoGridController _conferirCarrinhoGridController;
  late ExpedicaoConferirConsultaModel _conferirConsulta;
  late ConferirConsultaServices _conferirServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoConferirConsultaModel get conferirConsulta => _conferirConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();

    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();
    //_conferirGridController = Get.find<ConferirGridController>();
    _conferirCarrinhoGridController =
        Get.find<ConferirCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    // _conferirServices = ConferirConsultaServices(
    //   codEmpresa: _processoExecutavel.codEmpresa,
    //   codConferirEstoque: _processoExecutavel.codOrigem,
    // );

    await _fillGridConferirCarrinhos();
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

  Future<void> _fillGridConferirCarrinhos() async {
    // final conferirCarrinhos = await _conferirServices.carrinhosPercurso();
    // _conferirCarrinhoGridController.addAllGrid(conferirCarrinhos);
    // _conferirCarrinhoGridController.update();
  }

  void addCarrinho(ExpedicaoCarrinhoConferirConsultaModel model) {
    _conferirCarrinhoGridController.addGrid(model);
    _conferirCarrinhoGridController.update();
  }

  void addAllCarrinho(List<ExpedicaoCarrinhoConferirConsultaModel> models) {
    _conferirCarrinhoGridController.addAllGrid(models);
    _conferirCarrinhoGridController.update();
  }

  _evetsCarrinhoGrid() {
    // _conferirCarrinhoGridController.onPressedSave = (item) async {
    //   final itensSeparacao = await _conferirServices.itensSeparacao();
    //   final itensSeparacaoCarrinho = itensSeparacao
    //       .where((el) =>
    //           el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
    //           el.codCarrinho == item.codCarrinho)
    //       .toList();

    //   if (itensSeparacaoCarrinho.isEmpty) {
    //     await ConfirmationDialogMessageWidget.show(
    //       context: Get.context!,
    //       message: 'Carrinho vazio!',
    //       detail: 'Adicione itens ao carrinho para finalizar!',
    //     );

    //     return;
    //   }

    //   final carrinho = await CarrinhoServices().select(
    //     "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
    //   );

    //   final carrinhoPercurso =
    //       ExpedicaoCarrinhoPercursoModel.fromConsulta(item);

    //   final carrinhoPercursoEstagio =
    //       await CarrinhoPercursoEstagioServices().select('''
    //               CodEmpresa = ${item.codEmpresa}
    //           AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
    //           AND CodPercursoEstagio = ${item.codPercursoEstagio}
    //           AND CodCarrinho = ${item.codCarrinho}
    //           AND Item = ${item.item}

    //         ''');

    //   if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;
    //   final newCarrinho = carrinho.first.copyWith(
    //     situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
    //   );

    //   await CarrinhoPercursoEstagioFinalizarService(
    //     carrinho: newCarrinho,
    //     carrinhoPercurso: carrinhoPercurso,
    //     carrinhoPercursoEstagio: carrinhoPercursoEstagio.first,
    //   ).execute();

    //   await SeparacaoFinalizarItemService().updateAll(itensSeparacaoCarrinho);
    //   final newCarrinhoPercursoConsulta = item.copyWith(
    //     situacao: ExpedicaoSituacaoModel.separando,
    //   );

    //   _conferirCarrinhoGridController.updateGrid(newCarrinhoPercursoConsulta);
    //   _conferirCarrinhoGridController.update();
    // };

    // Cancelar carrinho
    _conferirCarrinhoGridController.onPressedRemove = (item) async {
      // final carrinho = await CarrinhoServices().select(
      //   "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
      // );

      // final carrinhoPercursoEstagio =
      //     await CarrinhoPercursoEstagioServices().select('''
      //             CodEmpresa = ${item.codEmpresa}
      //           AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
      //           AND CodPercursoEstagio = ${item.codPercursoEstagio}
      //           AND CodCarrinho = ${item.codCarrinho}
      //           AND Item = ${item.item}

      //         ''');

      // if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;

      // await CarrinhoPercursoEstagioCancelarService(
      //   carrinho: carrinho.first,
      //   percursoEstagio: carrinhoPercursoEstagio.first,
      // ).execute();

      // final carrinhoPercurso = item.copyWith(
      //   situacao: ExpedicaoSituacaoModel.cancelada,
      // );

      // final newConferirItens = await _conferirServices.itensSaparar();
      // _conferirCarrinhoGridController.updateGrid(carrinhoPercurso);
      // _conferirGridController.updateAllGrid(newConferirItens);
      // _conferirCarrinhoGridController.update();
      // _conferirGridController.update();
    };
  }

  _liteners() {
    const uuid = Uuid();
    final carrinhoEvent = CarrinhoEventRepository.instancia;

    //final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;

    final updateCarrinho = RepositoryEventListenerModel(
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
    );

    // carrinhoPercursoEvent.addListener(
    //   RepositoryEventListenerModel(
    //     id: uuid.v4(),
    //     event: Event.insert,
    //     callback: (data) async {
    //       for (var el in data.mutation) {
    //         final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //         if (car.codEmpresa == _processoExecutavel.codEmpresa &&
    //             car.origem == _processoExecutavel.origem &&
    //             car.codOrigem == _processoExecutavel.codOrigem) {
    //           _conferirCarrinhoGridController.addGrid(car);
    //           _conferirCarrinhoGridController.update();
    //         }
    //       }
    //     },
    //   ),
    // );

    // carrinhoPercursoEvent.addListener(
    //   RepositoryEventListenerModel(
    //     id: uuid.v4(),
    //     event: Event.update,
    //     callback: (data) async {
    //       for (var el in data.mutation) {
    //         final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //         _conferirCarrinhoGridController.updateGrid(car);
    //         _conferirCarrinhoGridController.update();
    //       }
    //     },
    //   ),
    // );

    // carrinhoPercursoEvent.addListener(
    //   RepositoryEventListenerModel(
    //     id: uuid.v4(),
    //     event: Event.delete,
    //     callback: (data) async {
    //       for (var el in data.mutation) {
    //         final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
    //         _conferirCarrinhoGridController.removeGrid(car);
    //         _conferirCarrinhoGridController.update();
    //       }
    //     },
    //   ),
    // );

    carrinhoEvent.addListener(updateCarrinho);
    _pageListerner.add(updateCarrinho);
  }

  void _removeliteners() {
    final carrinhoEvent = CarrinhoEventRepository.instancia;
    carrinhoEvent.removeListeners(_pageListerner);
  }
}
