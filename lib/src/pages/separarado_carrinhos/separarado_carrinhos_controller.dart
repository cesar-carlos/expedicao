import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/service/separacao_finalizar_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_event_repository.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/service/separacao_cancelar_item_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';

class SeparadoCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  late SepararGridController _separarGridController;
  late SeparadoCarrinhoGridController _separadoCarrinhoGridController;
  late SepararConsultaServices _separarConsultaServices;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late UsuarioConsultaMoldel _usuarioLogado;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  Future<void> onInit() async {
    super.onInit();
    _usuarioLogado = Get.find<UsuarioConsultaMoldel>();
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

  void addCart(ExpedicaoCarrinhoPercursoEstagioConsultaModel model) {
    _separadoCarrinhoGridController.addGrid(model);
    _separadoCarrinhoGridController.update();
  }

  Future<void> removeCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    if (_separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Não é possível remover um carrinho já cancelada!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível cancelar um carrinho já finalizado!',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja realmente cancelar?',
      detail: 'Ao cancelar, os itens serão removido do carrinho!',
    );

    if (confirmation != null && confirmation) {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            final carrinho = await CarrinhoService().select(
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
              await MessageDialogView.show(
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
                    _processoExecutavel.codUsuario &&
                _usuarioLogado.excluiCarrinhoOutroUsuario != 'S') {
              await MessageDialogView.show(
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
  }

  Future<void> editCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    bool _viewMode = [
          ExpedicaoSituacaoModel.cancelada,
          ExpedicaoSituacaoModel.separado,
        ].contains(item.situacao) ||
        _separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada;

    final carrinho = await CarrinhoService().select('''
            CodEmpresa = ${item.codEmpresa} 
          AND CodCarrinho = ${item.codCarrinho} ''');

    final carrinhosPercursoEstagio =
        await CarrinhoPercursoEstagioServices().select('''
              CodEmpresa = ${item.codEmpresa}
            AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
            AND CodCarrinho = ${item.codCarrinho}
            AND Item = ${item.item} ''');

    if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: 'Carrinho não encontrado na tabela percurso estagio!',
      );

      return;
    }

    //TOOD:: ADD SOLICITACAO DE SENHA
    final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;

    final _editViewMode =
        (_usuarioLogado.editaCarrinhoOutroUsuario == 'S' || _viewMode);

    final _editUsuario = (carrinhoPercursoEstagio.codUsuarioInicio !=
        _processoExecutavel.codUsuario);

    if (_editUsuario && !_editViewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não pertence a você!',
        detail:
            '''Carrinho não pode ser editado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} editar!''',
      );

      return;
    }

    await SeparacaoPage.show(
      size: Get.size,
      canCloseWindow: false,
      context: Get.context!,
      percursoEstagioConsulta: item,
    );
  }

  FutureOr<bool> saveCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    if (_separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Não é possível salvar um carrinho já cancelada!',
      );

      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salva um carrinho que esteja finalizado!',
      );

      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salva um carrinho que esteja cancelado!',
      );

      return false;
    }

    final itensSeparacao = await _separarConsultaServices.itensSeparacao();
    final itensSeparacaoCarrinho = itensSeparacao
        .where((el) =>
            el.codEmpresa == item.codEmpresa &&
            el.codCarrinho == item.codCarrinho &&
            el.situacao != ExpedicaoItemSituacaoModel.cancelado)
        .toList();

    if (itensSeparacaoCarrinho.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho vazio!',
        detail: 'Adicione itens ao carrinho para finalizar!',
      );

      return false;
    }

    final bool? confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja Salva?',
      detail: 'Ao salvar, o carrinho não podera ser mais alterado!',
    );

    if (confirmation != null && confirmation) {
      return await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          try {
            final cartIsValid =
                await _separarConsultaServices.cartIsValid(item.codCarrinho);

            if (!cartIsValid) {
              final itens = await _separarConsultaServices.itensSaparar();
              _separarGridController.updateAllGrid(itens);
              _separarGridController.update();

              await MessageDialogView.show(
                context: Get.context!,
                message: 'Carrinho não pode ser salvo!',
                detail: 'Quantidade separada maior que a quantidade a separar!',
              );

              return false;
            }

            final carrinho = await CarrinhoService().select('''
                    CodEmpresa = ${item.codEmpresa} 
                  AND CodCarrinho = ${item.codCarrinho} ''');

            final carrinhosPercursoEstagio =
                await CarrinhoPercursoEstagioServices().select('''
                    CodEmpresa = ${item.codEmpresa}
                  AND CodCarrinhoPercurso = ${item.codCarrinhoPercurso}
                  AND CodCarrinho = ${item.codCarrinho}
                  AND Item = ${item.item} ''');

            if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
              await MessageDialogView.show(
                context: Get.context!,
                message: 'Carrinho não encontrado!',
                detail: 'Carrinho não encontrado na tabela percurso estagio!',
              );

              return false;
            }

            //TOOD:: ADD SOLICITACAO DE SENHA
            final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;
            if (carrinhoPercursoEstagio.codUsuarioInicio !=
                    _processoExecutavel.codUsuario &&
                _usuarioLogado.salvaCarrinhoOutroUsuario != 'S') {
              await MessageDialogView.show(
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

            final newCarrinhoPercursoEstagio = carrinhoPercursoEstagio.copyWith(
              situacao: ExpedicaoCarrinhoSituacaoModel.separado,
            );

            await CarrinhoPercursoEstagioFinalizarService(
              carrinho: newCarrinho,
              carrinhoPercursoEstagio: newCarrinhoPercursoEstagio,
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

    return false;
  }

  _evetsCarrinhoGrid() {
    _separadoCarrinhoGridController.onPressedRemove = (item) async {
      await removeCart(item);
    };

    _separadoCarrinhoGridController.onPressedEdit = (item) async {
      await editCart(item);
    };

    _separadoCarrinhoGridController.onPressedSave = (item) async {
      await saveCart(item);
    };
  }

  _liteners() {
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;
    const uuid = Uuid();

    //insert carrinho
    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final car =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

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
            final car =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

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
            final car =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

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
