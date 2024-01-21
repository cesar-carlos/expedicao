import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_binding.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/service/conferencia_cancelar_item_service.dart';
import 'package:app_expedicao/src/service/conferencia_finalizar_item_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_page.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class ConferidoCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  // ignore: unused_field
  late ExpedicaoConferirConsultaModel _conferirConsulta;
  late ConferidoCarrinhoGridController _conferidoCarrinhoGridController;

  late ConferirConsultaServices _conferirConsultaServices;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;

  @override
  Future<void> onInit() async {
    super.onInit();

    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _conferirConsulta = Get.find<ExpedicaoConferirConsultaModel>();

    _conferidoCarrinhoGridController =
        Get.find<ConferidoCarrinhoGridController>();

    _conferirConsultaServices = ConferirConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codConferir: _processoExecutavel.codOrigem,
    );

    await _fillGridConferidoCarrinhos();
  }

  @override
  onReady() async {
    super.onReady();
    _evetsCarrinhoGrid();
    _liteners();
  }

  Future<void> _fillGridConferidoCarrinhos() async {
    final conferidoCarrinhos =
        await _conferirConsultaServices.carrinhosPercurso();
    _conferidoCarrinhoGridController.addAllGrid(conferidoCarrinhos);
    _conferidoCarrinhoGridController.update();
  }

  void addCarrinho(ExpedicaoCarrinhoPercursoConsultaModel model) {
    _conferidoCarrinhoGridController.addGrid(model);
    _conferidoCarrinhoGridController.update();
  }

  _evetsCarrinhoGrid() {
    _conferidoCarrinhoGridController.onPressedEdit = (item) async {
      ConferenciaBinding(item).dependencies();
      final dialog = ConferenciaPage(item);
      await dialog.show();
    };

    _conferidoCarrinhoGridController.onPressedSave = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível salva um carrinho que esteja cancelado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.conferido) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho já finalizado!',
          detail: 'Não é possível salva um carrinho que esteja finalizado!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        context: Get.context!,
        message: 'Deseja Salva?',
        detail: 'Ao salvar, o carrinho não podera ser mais alterado!',
      );

      if (confirmation != null && confirmation) {
        final itensConferir = await _conferirConsultaServices.itensConferir();
        final itensConferencia =
            await _conferirConsultaServices.itensConferencia();

        final itensConferenciaCarrinho = itensConferencia
            .where((el) =>
                el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
                el.codCarrinho == item.codCarrinho)
            .toList();

        final itensConferirCarrinho =
            itensConferir.where((el) => el.codCarrinho == item.codCarrinho);

        final isComplitCart =
            itensConferirCarrinho.every((el) => el.isComplited());

        if (itensConferenciaCarrinho.isEmpty) {
          await ConfirmationDialogMessageWidget.show(
            context: Get.context!,
            message: 'Carrinho não conferido!',
            detail:
                'Não é possível salva um carrinho que não esteja conferido!',
          );

          return;
        }

        if (!isComplitCart) {
          await ConfirmationDialogMessageWidget.show(
            context: Get.context!,
            message: 'Carrinho não conferido!',
            detail:
                'Existem itens com conferencia incorreta, não é possível salva!',
          );

          return;
        }

        final newPercursoEstagio = ExpedicaoPercursoEstagioModel(
          codEmpresa: item.codEmpresa,
          codCarrinhoPercurso: item.codCarrinhoPercurso,
          item: item.item,
          origem: item.origem,
          codOrigem: item.codOrigem,
          codPercursoEstagio: item.codPercursoEstagio,
          codCarrinho: item.codCarrinho,
          situacao: ExpedicaoSituacaoModel.conferido,
          dataInicio: item.dataInicio,
          horaInicio: item.horaInicio,
          codUsuarioInicio: item.codUsuarioInicio,
          nomeUsuarioInicio: item.nomeUsuarioInicio,
        );

        final newCarrinho = ExpedicaoCarrinhoModel(
          codEmpresa: item.codEmpresa,
          codCarrinho: item.codCarrinho,
          descricao: item.nomeCarrinho,
          ativo: item.ativo,
          codigoBarras: item.codigoBarrasCarrinho,
          situacao: ExpedicaoCarrinhoSituacaoModel.conferido,
        );

        await CarrinhoPercursoEstagioFinalizarService(
          carrinhoPercursoEstagio: newPercursoEstagio,
          carrinho: newCarrinho,
        ).execute();

        await ConferenciaFinalizarItemService()
            .updateAll(itensConferenciaCarrinho);

        for (var el in itensConferenciaCarrinho) {
          _conferidoCarrinhoGridController.updateGridSituationItem(
              el.itemCarrinhoPercurso, ExpedicaoSituacaoModel.conferido);
        }

        _conferidoCarrinhoGridController.update();

        //Finalizar separação automaticamente
        final isComplete = await _conferirConsultaServices.isComplete();
        final existsOpenCart = await _conferirConsultaServices.existsOpenCart();

        if (isComplete && !existsOpenCart) {
          Future.delayed(Duration(microseconds: 500), () async {
            final separarController = Get.find<ConferirController>();
            separarController.finalizarConferencia();
          });
        }
      }
    };

    // Cancelar carrinho
    _conferidoCarrinhoGridController.onPressedRemove = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível cancelar um carrinho já cancelado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.conferido) {
        await ConfirmationDialogMessageWidget.show(
          context: Get.context!,
          message: 'Carrinho já finalizado!',
          detail: 'Não é possível cancelar um carrinho já finalizado!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        context: Get.context!,
        message: 'Deseja realmente cancelar?',
        detail: 'Ao cancelar, os itens serão removido do carrinho!',
      );

      if (confirmation != null && confirmation) {
        final carrinho = await CarrinhoServices().select(
          '''CodEmpresa = ${item.codEmpresa} 
           AND CodCarrinho = ${item.codCarrinho}''',
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
        final newCarrinho = carrinho.last.copyWith(
          situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
        );

        await CarrinhoPercursoEstagioCancelarService(
          carrinho: newCarrinho,
          percursoEstagio: carrinhoPercursoEstagio.last,
        ).execute();

        final carrinhoPercurso = item.copyWith(
          situacao: ExpedicaoSituacaoModel.cancelada,
        );

        ConferenciaCancelarItemService(
          percursoEstagioConsulta: carrinhoPercurso,
        ).cancelarAllItensCart();

        _conferidoCarrinhoGridController.updateGrid(carrinhoPercurso);
        _conferidoCarrinhoGridController.update();
      }
    };
  }

  _liteners() {
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
              _conferidoCarrinhoGridController.addGrid(car);
              _conferidoCarrinhoGridController.update();
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
            _conferidoCarrinhoGridController.updateGrid(car);
            _conferidoCarrinhoGridController.update();
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
            _conferidoCarrinhoGridController.removeGrid(car);
            _conferidoCarrinhoGridController.update();
          }
        },
      ),
    );
  }
}
