import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/separacao_finalizar_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_event_repository.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/service/separacao_cancelar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';
import 'package:app_expedicao/src/service/carrinho_services.dart';

class SeparadoCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  late SepararGridController _separarGridController;
  late SeparadoCarrinhoGridController _separadoCarrinhoGridController;
  late SepararConsultaServices _separarConsultaServices;
  late ExpedicaoSepararConsultaModel _separarConsulta;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();

    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarGridController = Get.find<SepararGridController>();
    _separadoCarrinhoGridController =
        Get.find<SeparadoCarrinhoGridController>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );

    await _fillGridSeparadoCarrinhos();
  }

  @override
  onReady() async {
    super.onReady();
    _evetsCarrinhoGrid();
    _liteners();
  }

  Future<void> _fillGridSeparadoCarrinhos() async {
    final separadoCarrinhos =
        await _separarConsultaServices.carrinhosPercurso();
    _separadoCarrinhoGridController.addAllGrid(separadoCarrinhos);
    _separadoCarrinhoGridController.update();
  }

  void addCarrinho(ExpedicaoCarrinhoPercursoConsultaModel model) {
    _separadoCarrinhoGridController.addGrid(model);
    _separadoCarrinhoGridController.update();
  }

  _evetsCarrinhoGrid() {
    _separadoCarrinhoGridController.onPressedEdit = (item) async {
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
              '''Carrinho não pode ser editado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} editar! ''',
        );

        return;
      }

      await SeparacaoPage.show(
        size: Get.size,
        canCloseWindow: false,
        context: Get.context!,
        percursoEstagioConsulta: item,
      );
    };

    _separadoCarrinhoGridController.onPressedSave = (item) async {
      final itensSeparacao = await _separarConsultaServices.itensSeparacao();
      final itensSeparacaoCarrinho = itensSeparacao
          .where((el) =>
              el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
              el.codCarrinho == item.codCarrinho)
          .toList();

      if (item.situacao == ExpedicaoSituacaoModel.separado) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já finalizado!',
          detail: 'Não é possível salva um carrinho que esteja finalizado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível salva um carrinho que esteja cancelado!',
        );

        return;
      }

      if (itensSeparacaoCarrinho.isEmpty) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho vazio!',
          detail: 'Adicione itens ao carrinho para finalizar!',
        );

        return;
      }

      final bool? confirmation = await ConfirmationDialogWidget.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Deseja Salva?',
        detail: 'Ao salvar, o carrinho não podera ser mais alterado!',
      );

      //SAVE CART
      if (confirmation != null && confirmation) {
        await LoadingProcessDialogGenericWidget.show<bool>(
          canCloseWindow: false,
          context: Get.context!,
          process: () async {
            try {
              final carrinho = await CarrinhoServices().select(''' 
                    CodEmpresa = ${item.codEmpresa} 
                  AND CodCarrinho = ${item.codCarrinho} 

                ''');

              final carrinhosPercursoEstagio =
                  await CarrinhoPercursoEstagioServices().select('''
                    CodEmpresa = ${item.codEmpresa}
                  AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
                  AND CodCarrinho = ${item.codCarrinho}
                  AND Item = ${item.item}

                  ''');

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
                      '''Carrinho não pode ser salvo. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} salvar! ''',
                );

                return false;
              }

              final newCarrinho = carrinho.last.copyWith(
                situacao: ExpedicaoCarrinhoSituacaoModel.separado,
              );

              carrinhoPercursoEstagio.copyWith(
                  situacao: ExpedicaoCarrinhoSituacaoModel.separado);

              await CarrinhoPercursoEstagioFinalizarService(
                carrinho: newCarrinho,
                carrinhoPercursoEstagio: carrinhoPercursoEstagio,
              ).execute();

              await SeparacaoFinalizarItemService()
                  .updateAll(itensSeparacaoCarrinho);
              final newCarrinhoPercursoConsulta = item.copyWith(
                situacao: ExpedicaoSituacaoModel.separado,
              );

              _separadoCarrinhoGridController
                  .updateGrid(newCarrinhoPercursoConsulta);
              _separadoCarrinhoGridController.update();

              final isComplete = await _separarConsultaServices.isComplete();
              final existsOpenCart =
                  await _separarConsultaServices.existsOpenCart();

              //FINALIZAR CONFERENCIA AUTOMATICAMENTE
              if (isComplete && !existsOpenCart) {
                final separarController = Get.find<SepararController>();
                await separarController.finalizarSeparacao();
                await Future.delayed(Duration(seconds: 1));
              }

              return true;
            } catch (err) {
              return false;
            }
          },
        );
      }
    };

    /// Cancelar carrinho
    _separadoCarrinhoGridController.onPressedRemove = (item) async {
      if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
        await ConfirmationDialogMessageWidget.show(
          canCloseWindow: false,
          context: Get.context!,
          message: 'Carrinho já cancelado!',
          detail: 'Não é possível cancelar um carrinho já cancelado!',
        );

        return;
      }

      if (item.situacao == ExpedicaoSituacaoModel.separado) {
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
                situacao: ExpedicaoCarrinhoSituacaoModel.liberado,
              );

              await CarrinhoPercursoEstagioCancelarService(
                carrinho: newCarrinho,
                percursoEstagio: carrinhoPercursoEstagio,
              ).execute();

              final carrinhoPercursoConsulta = item.copyWith(
                situacao: ExpedicaoSituacaoModel.cancelada,
              );

              await SeparacaoCancelarItemService(
                percursoEstagioConsulta: carrinhoPercursoConsulta,
              ).cancelarAllItensCart();

              final newSepararItens =
                  await _separarConsultaServices.itensSaparar();
              _separadoCarrinhoGridController
                  .updateGrid(carrinhoPercursoConsulta);
              _separarGridController.updateAllGrid(newSepararItens);
              _separadoCarrinhoGridController.update();
              _separarGridController.update();
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

    //insert carrinho
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
              _separadoCarrinhoGridController.addGrid(car);
              _separadoCarrinhoGridController.update();
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
              _separadoCarrinhoGridController.updateGrid(car);
              _separadoCarrinhoGridController.update();
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
              _separadoCarrinhoGridController.removeGrid(car);
              _separadoCarrinhoGridController.update();
            }
          }
        },
      ),
    );
  }
}
