import 'package:get/get.dart';

import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_cancelar_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consulta_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class SepararCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;
  late SepararCarrinhoGridController _separarCarrinhoGridController;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late SepararConsultaServices _separarServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  void onInit() {
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarCarrinhoGridController = Get.find<SepararCarrinhoGridController>();

    _separarServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    _fillGridSepararCarrinhos();
    _onRemoveItemSepararCarrinhoGrid();
    _litenerCarrinhoPercurso();
    super.onInit();
  }

  Future<void> _fillGridSepararCarrinhos() async {
    final separarCarrinhos = await _separarServices.carrinhosPercurso();
    for (var el in separarCarrinhos) {
      _separarCarrinhoGridController.addItem(el);
    }
  }

  void addCarrinho(ExpedicaoPercursoEstagioConsultaModel model) {
    _separarCarrinhoGridController.addItem(model);
  }

  _onRemoveItemSepararCarrinhoGrid() {
    _separarCarrinhoGridController.onPressedRemoveItem = (item) async {
      final carrinho = await CarrinhoServices().select(
        "CodEmpresa = ${item.codEmpresa} AND CodCarrinho = ${item.codCarrinho}",
      );

      final carrinhoPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''
                  CodEmpresa = ${item.codEmpresa}
              AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
              AND CodPercursoEstagio = ${item.codPercursoEstagio}
              AND CodCarrinho = ${item.codCarrinho}
              AND Item = ${item.item}

            ''');

      if (carrinho.isEmpty || carrinhoPercursoEstagio.isEmpty) return;

      await CarrinhoPercursoCancelarService(
        carrinho: carrinho.first,
        percursoEstagio: carrinhoPercursoEstagio.first,
        processo: _processoExecutavel,
      ).execute();

      final newItem = item.copyWith(situacao: 'CA');
      _separarCarrinhoGridController.updateItem(newItem);
    };
  }

  _litenerCarrinhoPercurso() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            _separarCarrinhoGridController.addItem(car);
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            _separarCarrinhoGridController.updateItem(car);
          }
        },
      ),
    );

    carrinhoPercursoEvent.addListener(
      RepositoryEventListerModel(
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoPercursoEstagioConsultaModel.fromJson(el);
            _separarCarrinhoGridController.removeItem(car);
          }
        },
      ),
    );
  }
}
