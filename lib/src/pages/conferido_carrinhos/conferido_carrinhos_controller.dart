import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/service/conferencia_cancelar_item_service.dart';
import 'package:app_expedicao/src/service/conferencia_finalizar_item_service.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/carrinhos_agrupar_page.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_event_repository.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/common/confirmation_dialog/confirmation_dialog_view.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_cancelar_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_agrupar_service.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_page.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

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

  void addCarrinho(ExpedicaoCarrinhoPercursoEstagioConsultaModel model) {
    _conferidoCarrinhoGridController.addGrid(model);
    _conferidoCarrinhoGridController.update();
  }

  Future<void> removeCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível cancelar um carrinho já cancelado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível cancelar um carrinho já finalizado!',
      );

      return;
    }

    if (item.situacao == ExpedicaoSituacaoModel.agrupado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível cancelar um carrinho já agrupado',
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
            final carrinhoQueryBuilder = QueryBuilder()
                .equals('CodEmpresa', item.codEmpresa)
                .equals('CodCarrinho', item.codCarrinho);

            final carrinho =
                await CarrinhoService().select(carrinhoQueryBuilder);

            final carrinhosPercursoEstagioQueryBuilder = QueryBuilder()
                .equals('CodEmpresa', item.codEmpresa)
                .equals('CodCarrinhoPercurso', item.codCarrinhoPercurso)
                .equals('CodPercursoEstagio', item.codPercursoEstagio)
                .equals('CodCarrinho', item.codCarrinho)
                .equals('Item', item.item);

            final carrinhosPercursoEstagio =
                await CarrinhoPercursoEstagioServices()
                    .select(carrinhosPercursoEstagioQueryBuilder);

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

            final _editViewMode =
                (_usuarioLogado.editaCarrinhoOutroUsuario == 'S');

            final _editUsuario = (carrinhoPercursoEstagio.codUsuarioInicio !=
                _processoExecutavel.codUsuario);

            if (_editUsuario && !_editViewMode) {
              await MessageDialogView.show(
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
  }

  Future<void> editCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    bool _viewMode = [
      ExpedicaoSituacaoModel.conferido,
      ExpedicaoSituacaoModel.cancelada,
      ExpedicaoSituacaoModel.agrupado,
      ExpedicaoSituacaoModel.emEntrega,
      ExpedicaoSituacaoModel.embalando
    ].contains(item.situacao);

    final carrinhoQueryBuilder = QueryBuilder()
        .equals('CodEmpresa', item.codEmpresa)
        .equals('CodCarrinho', item.codCarrinho);

    final carrinho = await CarrinhoService().select(carrinhoQueryBuilder);

    final carrinhosPercursoEstagioQueryBuilder = QueryBuilder()
        .equals('CodEmpresa', item.codEmpresa)
        .equals('CodCarrinhoPercurso', item.codCarrinhoPercurso)
        .equals('CodCarrinho', item.codCarrinho)
        .equals('Item', item.item);

    final carrinhosPercursoEstagio = await CarrinhoPercursoEstagioServices()
        .select(carrinhosPercursoEstagioQueryBuilder);

    if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: '''Carrinho não encontrado na tabela percurso estagio!''',
      );

      return;
    }

    final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;

    final _editViewMode =
        (_usuarioLogado.editaCarrinhoOutroUsuario == 'S' || _viewMode);

    final _editUsuario = (carrinhoPercursoEstagio.codUsuarioInicio !=
        _processoExecutavel.codUsuario);

    //TOOD:: ADD SOLICITACAO DE SENHA
    if (_editUsuario && !_editViewMode) {
      await MessageDialogView.show(
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
  }

  Future<void> groupCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    final conferirConsulta = await _conferirConsultaServices.conferir();

    if (conferirConsulta == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Conferencia não encontrada!',
        detail: 'Conferencia não encontrada na tabela conferencia!',
      );

      return;
    }

    bool _isValidGroup = [
      ExpedicaoSituacaoModel.conferido,
    ].contains(item.situacao);

    if (!_isValidGroup) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho ${item.situacao.toLowerCase()}!',
        detail:
            '''Não é possível agrupar um carrinho que estaja ${item.situacao}!''',
      );

      return;
    }

    final _carrinhoAgruparService = CarrinhoPercursoEstagioAgruparService(
      codEmpresa: item.codEmpresa,
      codCarrinhoPercurso: item.codCarrinhoPercurso,
    );

    final _carrinhoPercurso =
        await _carrinhoAgruparService.carrinhoPercurso(item.item);

    if (_carrinhoPercurso == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: 'Carrinho não encontrado na tabela percurso estagio!',
      );

      return;
    }

    bool _isViewMode = ![
          ExpedicaoSituacaoModel.emAndamento,
          ExpedicaoSituacaoModel.emConverencia
        ].contains(conferirConsulta.situacao) ||
        ![
          ExpedicaoSituacaoModel.conferido,
          ExpedicaoSituacaoModel.cancelada,
          ExpedicaoSituacaoModel.cancelada,
          ExpedicaoSituacaoModel.emEntrega,
          ExpedicaoSituacaoModel.embalando
        ].contains(item.situacao);

    await CarrinhosAgruparPage.show(
      size: Get.size,
      viewMode: _isViewMode,
      context: Get.context!,
      carrinhoPercursoAgrupamento: _carrinhoPercurso,
    );
  }

  Future<bool> saveCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salva um carrinho que esteja cancelado!',
      );

      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.conferido) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salva um carrinho que esteja finalizado!',
      );

      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.agrupado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho agrupado!',
        detail: 'Não é possível salva um carrinho que esteja finalizado!',
      );

      return false;
    }

    final itensConferir = await _conferirConsultaServices.itensConferir();
    final itensConferencia = await _conferirConsultaServices.itensConferencia();

    final itensConferenciaCarrinho = itensConferencia
        .where((el) =>
            el.situacao != ExpedicaoItemSituacaoModel.cancelado &&
            el.codCarrinho == item.codCarrinho)
        .toList();

    final itensConferirCarrinho = itensConferir.where(
      (el) => el.codCarrinho == item.codCarrinho,
    );

    final isComplitCart = itensConferirCarrinho.every((el) => el.isComplited());

    if (itensConferenciaCarrinho.isEmpty) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não conferido!',
        detail: 'Não é possível salva um carrinho que não esteja conferido!',
      );

      return false;
    }

    final carrinhoQueryBuilder = QueryBuilder()
        .equals('CodEmpresa', item.codEmpresa)
        .equals('CodCarrinho', item.codCarrinho);

    final carrinho = await CarrinhoService().select(carrinhoQueryBuilder);

    final carrinhosPercursoEstagioQueryBuilder = QueryBuilder()
        .equals('CodEmpresa', item.codEmpresa)
        .equals('CodCarrinhoPercurso', item.codCarrinhoPercurso)
        .equals('CodCarrinho', item.codCarrinho)
        .equals('Item', item.item);

    final carrinhosPercursoEstagio = await CarrinhoPercursoEstagioServices()
        .select(carrinhosPercursoEstagioQueryBuilder);

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
    final _editViewMode = (_usuarioLogado.editaCarrinhoOutroUsuario == 'S');

    final _editUsuario = (carrinhoPercursoEstagio.codUsuarioInicio !=
        _processoExecutavel.codUsuario);

    if (_editUsuario && !_editViewMode) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não pertence a você!',
        detail:
            '''Carrinho não pode ser editado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} salvar! ''',
      );

      return false;
    }

    if (!isComplitCart) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não conferido!',
        detail:
            'Existem itens com conferencia incorreta, não é possível salva!',
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
            final newPercursoEstagio = ExpedicaoCarrinhoPercursoEstagioModel(
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

            await ConferenciaFinalizarItemService().updateAll(
              itensConferenciaCarrinho,
            );

            for (var el in itensConferenciaCarrinho) {
              _conferidoCarrinhoGridController.updateGridSituationItem(
                el.itemCarrinhoPercurso,
                ExpedicaoSituacaoModel.conferido,
              );
            }

            _conferidoCarrinhoGridController.update();

            // //FINALIZAR CONFERENCIA AUTOMATICAMENTE
            // final isComplete = await _conferirConsultaServices.isComplete();
            // final existsOpenCart =
            //     await _conferirConsultaServices.existsOpenCart();

            // if (isComplete && !existsOpenCart) {
            //   await LoadingProcessDialogGenericWidget.show<bool>(
            //     context: Get.context!,
            //     process: () async {
            //       try {
            //         final separarController = Get.find<ConferirController>();
            //         await separarController.finalizarConferencia();
            //         await Future.delayed(Duration(seconds: 1));
            //         return true;
            //       } catch (err) {
            //         return false;
            //       }
            //     },
            //   );
            // }

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
    _conferidoCarrinhoGridController.onPressedRemove = (item) async {
      await removeCart(item);
    };

    _conferidoCarrinhoGridController.onPressedEdit = (item) async {
      await editCart(item);
    };

    _conferidoCarrinhoGridController.onPressedGroup = (item) async {
      await groupCart(item);
    };

    _conferidoCarrinhoGridController.onPressedSave = (item) async {
      await saveCart(item);
    };
  }

  _liteners() {
    final carrinhoPercursoEvent =
        CarrinhoPercursoEstagioEventRepository.instancia;

    const uuid = Uuid();

    //Insert carrinho
    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        allEvent: false,
        event: Event.insert,
        callback: (data) async {
          for (var el in data.mutation) {
            final event =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.origem == _processoExecutavel.origem &&
                event.codOrigem == _processoExecutavel.codOrigem) {
              _conferidoCarrinhoGridController.addGrid(event);
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
        allEvent: true,
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final event =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.origem == _processoExecutavel.origem &&
                event.codOrigem == _processoExecutavel.codOrigem) {
              _conferidoCarrinhoGridController.updateGrid(event);
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
        allEvent: false,
        event: Event.delete,
        callback: (data) async {
          for (var el in data.mutation) {
            final event =
                ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(el);

            if (event.codEmpresa == _processoExecutavel.codEmpresa &&
                event.origem == _processoExecutavel.origem &&
                event.codOrigem == _processoExecutavel.codOrigem) {
              _conferidoCarrinhoGridController.removeGrid(event);
              _conferidoCarrinhoGridController.update();
            }
          }
        },
      ),
    );
  }
}
