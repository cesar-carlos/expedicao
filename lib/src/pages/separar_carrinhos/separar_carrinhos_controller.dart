import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_cancelar_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class SepararCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;
  late SepararGridController _separarGridController;
  late SepararCarrinhoGridController _separarCarrinhoGridController;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late SepararConsultaServices _separarServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();

    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarGridController = Get.find<SepararGridController>();
    _separarCarrinhoGridController = Get.find<SepararCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    _separarServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    await _fillGridSepararCarrinhos();
    _onRemoveItemSepararCarrinhoGrid();
    _litenerCarrinhoPercurso();
  }

  Future<void> _fillGridSepararCarrinhos() async {
    final separarCarrinhos = await _separarServices.carrinhosPercurso();

    for (var el in separarCarrinhos) {
      _separarCarrinhoGridController.add(el);
    }
  }

  void addCarrinho(ExpedicaoCarrinhoPercursoConsultaModel model) {
    _separarCarrinhoGridController.add(model);
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
      ).execute();

      final carrinhoPercurso =
          item.copyWith(situacao: ExpedicaoSituacaoModel.cancelada);

      _separarCarrinhoGridController.updateItem(carrinhoPercurso);

      final separacaoItens = await SeparacaoItemConsultaRepository().select(
        ''' CodEmpresa = ${_separarConsulta.codEmpresa} 
        AND CodSepararEstoque = ${_separarConsulta.codSepararEstoque} 
        AND Situacao = '${ExpedicaoItemSituacaoModel.separado}'
        
        ''',
      );

      final separarItens = _separarGridController.itens;
      for (var separarItem in separarItens) {
        final separado = separacaoItens
            .where((el) => el.codProduto == separarItem.codProduto);

        if (separado.isEmpty) {
          _separarGridController.updateItem(separarItem.copyWith(
            quantidadeSeparacao: 0.00,
          ));

          continue;
        }

        final totalSeparacao =
            separado.fold<double>(0.00, (acm, e) => acm + e.quantidade);

        _separarGridController.updateItem(separarItem.copyWith(
          quantidadeSeparacao: totalSeparacao,
        ));
      }
    };
  }

  _litenerCarrinhoPercurso() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    const uuid = Uuid();

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            if (car.codEmpresa == _processoExecutavel.codEmpresa &&
                car.origem == _processoExecutavel.origem &&
                car.codOrigem == _processoExecutavel.codOrigem) {
              _separarCarrinhoGridController.add(car);
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
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            _separarCarrinhoGridController.updateItem(car);
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
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);
            _separarCarrinhoGridController.remove(car);
          }
        },
      ),
    );
  }
}
