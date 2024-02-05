import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/conferencia_cancelar_item_service.dart';
import 'package:app_expedicao/src/service/conferencia_finalizar_item_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
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
  late ConferidoCarrinhoGridController _conferidoCarrinhoGridController;
  late ConferirConsultaServices _conferirConsultaServices;
  late UsuarioConsultaMoldel _usuarioLogado;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;

  @override
  Future<void> onInit() async {
    super.onInit();
    _usuarioLogado = Get.find<UsuarioConsultaMoldel>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

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
    _conferidoCarrinhoGridController.onPressedRemove = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível cancelar um carrinho já cancelado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.conferido) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já finalizado!',
          detail: 'Não é possível cancelar um carrinho já finalizado!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Deseja realmente cancelar?',
        detail: 'Ao cancelar, os itens serão removido do carrinho!',
      );

      if (confirmation != null && confirmation) {
        await LoadingProcessDialogGenericWidget.show<bool>(
          canCloseWindow: false,
          context: Get.context!,
          process: () async {
            try {
              final carrinho = await CarrinhoServices().select(
                '''CodEmpresa = ${item.codEmpresa} 
                  AND CodCarrinho = ${item.codCarrinho} ''',
              );

              final carrinhosPercursoEstagio =
                  await CarrinhoPercursoEstagioServices().select('''
                    CodEmpresa = ${item.codEmpresa}
                      AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
                      AND CodPercursoEstagio = ${item.codPercursoEstagio}
                      AND CodCarrinho = ${item.codCarrinho}
                      AND Item = ${item.item} ''');

              if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
                await ConfirmationDialogMessageWidget.show(
                  canCloseWindow: false,
                  context: Get.context!,
                  message: 'Carrinho não encontrado!',
                  detail: 'Carrinho não encontrado na tabela percurso estagio!',
                );

                return false;
              }

              //TOOD:: ADD SOLICITACAO DE SENHA
              final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;
              if (carrinhoPercursoEstagio.codUsuarioInicio !=
                  _processoExecutavel.codUsuario) {
                await ConfirmationDialogMessageWidget.show(
                  canCloseWindow: false,
                  context: Get.context!,
                  message: 'Carrinho não pertence a você!',
                  detail:
                      '''Carrinho não pode ser cancelado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} fazer o cancelamento! ''',
                );

                return false;
              }

              final newCarrinho = carrinho.last.copyWith(
                situacao: ExpedicaoCarrinhoSituacaoModel.emConferencia,
              );

              await CarrinhoPercursoEstagioCancelarService(
                carrinho: newCarrinho,
                percursoEstagio: carrinhosPercursoEstagio.last,
              ).execute();

              final carrinhoPercurso = item.copyWith(
                situacao: ExpedicaoSituacaoModel.cancelada,
              );

              ConferenciaCancelarItemService(
                percursoEstagioConsulta: carrinhoPercurso,
              ).cancelarAllItensCart();

              _conferidoCarrinhoGridController.updateGrid(carrinhoPercurso);
              _conferidoCarrinhoGridController.update();

              return true;
            } catch (err) {
              return false;
            }
          },
        );
      }
    };

    _conferidoCarrinhoGridController.onPressedEdit = (item) async {
      bool _viewMode = [
        ExpedicaoSituacaoModel.cancelada,
        ExpedicaoSituacaoModel.conferido,
      ].contains(item.situacao);

      final carrinho = await CarrinhoServices().select(''' 
            CodEmpresa = ${item.codEmpresa} 
          AND CodCarrinho = ${item.codCarrinho} ''');

      final carrinhosPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''
              CodEmpresa = ${item.codEmpresa}
            AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
            AND CodCarrinho = ${item.codCarrinho}
            AND Item = ${item.item} ''');

      if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não encontrado!',
          detail: 'Carrinho não encontrado na tabela percurso estagio!',
        );

        return;
      }

      final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;

      final _editViewMode =
          (_usuarioLogado.editaCarrinhoOutroUsuario == 'S' || _viewMode);

      final _editUsuario = (carrinhoPercursoEstagio.codUsuarioInicio !=
          _processoExecutavel.codUsuario);

      print(_editViewMode);

      //TOOD:: ADD SOLICITACAO DE SENHA
      if (_editUsuario && !_editViewMode) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não pertence a você!',
          detail:
              '''Carrinho não pode ser editado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} editar! ''',
        );

        return;
      }

      await ConferenciaPage.show(
        size: Get.size,
        canCloseWindow: false,
        context: Get.context!,
        percursoEstagioConsulta: item,
      );
    };

    _conferidoCarrinhoGridController.onPressedSave = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível salva um carrinho que esteja cancelado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.conferido) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já finalizado!',
          detail: 'Não é possível salva um carrinho que esteja finalizado!',
        );

        return;
      }

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
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não conferido!',
          detail: 'Não é possível salva um carrinho que não esteja conferido!',
        );

        return;
      }

      final carrinho = await CarrinhoServices().select(''' 
            CodEmpresa = ${item.codEmpresa} 
          AND CodCarrinho = ${item.codCarrinho} ''');

      final carrinhosPercursoEstagio =
          await CarrinhoPercursoEstagioServices().select('''
              CodEmpresa = ${item.codEmpresa}
            AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
            AND CodCarrinho = ${item.codCarrinho}
            AND Item = ${item.item} ''');

      if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não encontrado!',
          detail: 'Carrinho não encontrado na tabela percurso estagio!',
        );

        return;
      }

      //TOOD:: ADD SOLICITACAO DE SENHA
      final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;
      if (carrinhoPercursoEstagio.codUsuarioInicio !=
          _processoExecutavel.codUsuario) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não pertence a você!',
          detail:
              '''Carrinho não pode ser editado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} salvar! ''',
        );

        return;
      }

      if (!isComplitCart) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho não conferido!',
          detail:
              'Existem itens com conferencia incorreta, não é possível salva!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Deseja Salva?',
        detail: 'Ao salvar, o carrinho não podera ser mais alterado!',
      );

      ///CONFIRMAÇÃO DE SALVAR
      if (confirmation != null && confirmation) {
        await LoadingProcessDialogGenericWidget.show<bool>(
          canCloseWindow: false,
          context: Get.context!,
          process: () async {
            try {
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

              //FINALIZAR CONFERENCIA AUTOMATICAMENTE
              final isComplete = await _conferirConsultaServices.isComplete();
              final existsOpenCart =
                  await _conferirConsultaServices.existsOpenCart();

              if (isComplete && !existsOpenCart) {
                await LoadingProcessDialogGenericWidget.show<bool>(
                  canCloseWindow: false,
                  context: Get.context!,
                  process: () async {
                    try {
                      final separarController = Get.find<ConferirController>();
                      await separarController.finalizarConferencia();
                      await Future.delayed(Duration(seconds: 1));
                      return true;
                    } catch (err) {
                      return false;
                    }
                  },
                );
              }

              return true;
            } catch (err) {
              return false;
            }
          },
        );
      }
    };
  }

  _liteners() {
    final carrinhoPercursoEvent = CarrinhoPercursoEventRepository.instancia;
    const uuid = Uuid();

    //Insert carrinho
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

    //Update carrinho
    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);

            if (car.codEmpresa == _processoExecutavel.codEmpresa &&
                car.origem == _processoExecutavel.origem &&
                car.codOrigem == _processoExecutavel.codOrigem) {
              _conferidoCarrinhoGridController.updateGrid(car);
              _conferidoCarrinhoGridController.update();
            }
          }
        },
      ),
    );

    //Delete carrinho
    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final car = ExpedicaoCarrinhoPercursoConsultaModel.fromJson(el);

            if (car.codEmpresa == _processoExecutavel.codEmpresa &&
                car.origem == _processoExecutavel.origem &&
                car.codOrigem == _processoExecutavel.codOrigem) {
              _conferidoCarrinhoGridController.removeGrid(car);
              _conferidoCarrinhoGridController.update();
            }
          }
        },
      ),
    );
  }
}
