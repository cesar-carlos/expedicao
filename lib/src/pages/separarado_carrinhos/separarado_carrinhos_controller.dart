import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/service/carrinho_service.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/service/separacao_finalizar_item_service.dart';
import 'package:app_expedicao/src/service/separacao_reabrir_item_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_services.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_finalizar_service.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_reabrir_service.dart';
import 'package:app_expedicao/src/service/separacao_carrinho_validacao.dart';
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
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_page.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class _SaveCartResultado {
  const _SaveCartResultado.ok()
    : sucesso = true,
      message = null,
      detail = null,
      atualizarItens = false;

  const _SaveCartResultado.erro(
    this.message,
    this.detail, {
    this.atualizarItens = false,
  }) : sucesso = false;

  final bool sucesso;
  final String? message;
  final String? detail;
  final bool atualizarItens;
}

class SeparadoCarrinhosController extends GetxController {
  late ProcessoExecutavelModel _processoExecutavel;

  late SepararGridController _separarGridController;
  late SeparadoCarrinhoGridController _separadoCarrinhoGridController;
  late SepararConsultaServices _separarConsultaServices;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late UsuarioConsultaMoldel _usuarioLogado;
  bool _processando = false;

  ProcessoExecutavelModel get processoExecutavel => _processoExecutavel;
  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  @override
  void onInit() {
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

    _evetsCarrinhoGrid();
    _fillGridSeparadoCarrinhos();
  }

  @override
  void onReady() {
    super.onReady();
    _liteners();
  }

  Future<void> _fillGridSeparadoCarrinhos() async {
    final separadoCarrinhos = await _separarConsultaServices
        .carrinhosPercurso();
    _separadoCarrinhoGridController.addAllGrid(separadoCarrinhos);
    _separadoCarrinhoGridController.update();
    _separadoCarrinhoGridController.highlightFirstRow();
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

    if (confirmation != true) {
      return;
    }

    try {
      await LoadingProcessDialogGenericWidget.show<bool>(
        context: Get.context!,
        process: () async {
          final carrinhoQueryBuilder = QueryBuilder()
              .equals('CodEmpresa', item.codEmpresa)
              .equals('CodCarrinho', item.codCarrinho);

          final carrinho = await CarrinhoService().select(carrinhoQueryBuilder);

          final carrinhosPercursoEstagioQueryBuilder = QueryBuilder()
              .equals('CodEmpresa', item.codEmpresa)
              .equals('CodCarrinhoPercurso', item.codCarrinhoPercurso)
              .equals('CodPercursoEstagio', item.codPercursoEstagio)
              .equals('CodCarrinho', item.codCarrinho)
              .equals('Item', item.item);

          final carrinhosPercursoEstagio =
              await CarrinhoPercursoEstagioServices().select(
                carrinhosPercursoEstagioQueryBuilder,
              );

          if (carrinho.isEmpty || carrinhosPercursoEstagio.isEmpty) {
            throw Exception(
              'Carrinho não encontrado na tabela percurso estagio!',
            );
          }

          final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;
          if (carrinhoPercursoEstagio.codUsuarioInicio !=
                  _processoExecutavel.codUsuario &&
              _usuarioLogado.excluiCarrinhoOutroUsuario != 'S') {
            throw Exception(
              'Carrinho não pode ser cancelado. Solicite para o usuario ${carrinhoPercursoEstagio.nomeUsuarioInicio} fazer o cancelamento!',
            );
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

          final newSepararItens = await _separarConsultaServices.itensSaparar();

          _separadoCarrinhoGridController.updateGrid(carrinhoPercursoConsulta);
          _separarGridController.updateAllGrid(newSepararItens);
          _separadoCarrinhoGridController.update();
          _separarGridController.update();
          return true;
        },
      );
    } catch (_) {}
  }

  Future<void> editCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    bool viewMode =
        [
          ExpedicaoSituacaoModel.cancelada,
          ExpedicaoSituacaoModel.separado,
        ].contains(item.situacao) ||
        _separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada;

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

      return;
    }

    //TOOD:: ADD SOLICITACAO DE SENHA
    final carrinhoPercursoEstagio = carrinhosPercursoEstagio.last;

    final editViewMode =
        (_usuarioLogado.editaCarrinhoOutroUsuario == 'S' || viewMode);

    final editUsuario =
        (carrinhoPercursoEstagio.codUsuarioInicio !=
        _processoExecutavel.codUsuario);

    if (editUsuario && !editViewMode) {
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
    if (_processando) {
      return false;
    }

    if (_separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail: 'Não é possível salvar um carrinho de uma separação cancelada!',
      );
      return false;
    }

    if (_separarConsulta.situacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail:
            'Não é possível salvar um carrinho de uma separação finalizada!',
      );
      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salvar um carrinho que esteja finalizado!',
      );
      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salvar um carrinho que esteja cancelado!',
      );
      return false;
    }

    final carrinhoEstagio = await _carregarCarrinhoEstagio(item);
    if (carrinhoEstagio == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: 'Carrinho não encontrado na tabela percurso estágio!',
      );
      return false;
    }

    final carrinhoPercursoEstagio = carrinhoEstagio.estagio;
    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        canCloseWindow: false,
        context: Get.context!,
        message: 'Carrinho já finalizado!',
        detail: 'Não é possível salvar um carrinho que esteja finalizado!',
      );
      return false;
    }

    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível salvar um carrinho que esteja cancelado!',
      );
      return false;
    }

    if (carrinhoPercursoEstagio.codUsuarioInicio !=
            _processoExecutavel.codUsuario &&
        _usuarioLogado.salvaCarrinhoOutroUsuario != 'S') {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não pertence a você!',
        detail:
            'Carrinho não pode ser salvo. Solicite para o usuário ${carrinhoPercursoEstagio.nomeUsuarioInicio} salvar!',
      );
      return false;
    }

    final itensSeparacaoCarrinho = await _itensNaoCanceladosDoCarrinho(item);
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
      message: 'Deseja salvar?',
      detail: 'Ao salvar, o carrinho não poderá ser mais alterado!',
    );

    if (confirmation != true) {
      return false;
    }

    if (_processando) {
      return false;
    }

    _processando = true;
    late _SaveCartResultado resultado;
    try {
      resultado =
          await LoadingProcessDialogGenericWidget.show<_SaveCartResultado>(
            context: Get.context!,
            process: () async {
              try {
                return await _persistirSaveCart(item);
              } catch (err) {
                return _SaveCartResultado.erro(
                  'Erro ao salvar carrinho!',
                  err.toString(),
                );
              }
            },
          );
    } catch (err) {
      resultado = _SaveCartResultado.erro(
        'Erro ao salvar carrinho!',
        err.toString(),
      );
    } finally {
      _processando = false;
    }

    if (resultado.atualizarItens) {
      final itens = await _separarConsultaServices.itensSaparar();
      _separarGridController.updateAllGrid(itens);
      _separarGridController.update();
    }

    if (!resultado.sucesso) {
      await MessageDialogView.show(
        context: Get.context!,
        message: resultado.message ?? 'Erro ao salvar carrinho!',
        detail: resultado.detail ?? 'Não foi possível salvar o carrinho.',
      );
      return false;
    }

    return true;
  }

  Future<_SaveCartResultado> _persistirSaveCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    final carrinhoEstagio = await _carregarCarrinhoEstagio(item);
    if (carrinhoEstagio == null) {
      return const _SaveCartResultado.erro(
        'Carrinho não encontrado!',
        'Carrinho não encontrado na tabela percurso estágio!',
      );
    }

    final carrinhoPercursoEstagio = carrinhoEstagio.estagio;
    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.separado) {
      return const _SaveCartResultado.erro(
        'Carrinho já finalizado!',
        'Não é possível salvar um carrinho que esteja finalizado!',
      );
    }

    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.cancelada) {
      return const _SaveCartResultado.erro(
        'Carrinho já cancelado!',
        'Não é possível salvar um carrinho que esteja cancelado!',
      );
    }

    final itensSeparacaoCarrinho = await _itensNaoCanceladosDoCarrinho(item);
    if (itensSeparacaoCarrinho.isEmpty) {
      return const _SaveCartResultado.erro(
        'Carrinho vazio!',
        'Adicione itens ao carrinho para finalizar!',
      );
    }

    final cartIsValid = await _separarConsultaServices.cartIsValid(
      item.codCarrinho,
      itemCarrinhoPercurso: item.item,
    );

    if (!cartIsValid) {
      return const _SaveCartResultado.erro(
        'Carrinho não pode ser salvo!',
        'Quantidade separada maior que a quantidade a separar!',
        atualizarItens: true,
      );
    }

    await SeparacaoFinalizarItemService().updateAll(itensSeparacaoCarrinho);

    final newCarrinho = carrinhoEstagio.carrinho.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.separado,
    );
    final newCarrinhoPercursoEstagio = carrinhoPercursoEstagio.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.separado,
    );

    await CarrinhoPercursoEstagioFinalizarService(
      carrinho: newCarrinho,
      carrinhoPercursoEstagio: newCarrinhoPercursoEstagio,
    ).execute();

    final newCarrinhoPercursoConsulta = item.copyWith(
      situacao: ExpedicaoSituacaoModel.separado,
    );

    _separadoCarrinhoGridController.updateGrid(newCarrinhoPercursoConsulta);
    _separadoCarrinhoGridController.update();

    return const _SaveCartResultado.ok();
  }

  FutureOr<bool> reopenCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    if (_processando) {
      return false;
    }

    await _atualizarSituacaoSeparacao();

    if (_separarConsulta.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Separação cancelada!',
        detail:
            'Não é possível reabrir um carrinho de uma separação cancelada!',
      );
      return false;
    }

    if (_separarConsulta.situacao != ExpedicaoSituacaoModel.separando) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Não é possível reabrir!',
        detail: 'Só é possível reabrir o carrinho enquanto a separação estiver em andamento.',
      );
      return false;
    }

    if (item.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível reabrir um carrinho que esteja cancelado!',
      );
      return false;
    }

    if (item.situacao != ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não finalizado!',
        detail: 'Só é possível reabrir um carrinho que esteja finalizado!',
      );
      return false;
    }

    final carrinhoEstagio = await _carregarCarrinhoEstagio(item);
    if (carrinhoEstagio == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não encontrado!',
        detail: 'Carrinho não encontrado na tabela percurso estágio!',
      );
      return false;
    }

    final carrinhoPercursoEstagio = carrinhoEstagio.estagio;
    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.cancelada) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho já cancelado!',
        detail: 'Não é possível reabrir um carrinho que esteja cancelado!',
      );
      return false;
    }

    if (carrinhoPercursoEstagio.situacao != ExpedicaoSituacaoModel.separado) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não finalizado!',
        detail: 'Só é possível reabrir um carrinho que esteja finalizado!',
      );
      return false;
    }

    if (carrinhoPercursoEstagio.codUsuarioInicio !=
            _processoExecutavel.codUsuario &&
        _usuarioLogado.salvaCarrinhoOutroUsuario != 'S') {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Carrinho não pertence a você!',
        detail:
            'Carrinho não pode ser reaberto. Solicite para o usuário ${carrinhoPercursoEstagio.nomeUsuarioInicio} reabrir!',
      );
      return false;
    }

    final bool? confirmation = await ConfirmationDialogView.show(
      context: Get.context!,
      message: 'Deseja reabrir?',
      detail: 'Ao reabrir, o carrinho poderá ser alterado novamente.',
    );

    if (confirmation != true) {
      return false;
    }

    if (_processando) {
      return false;
    }

    _processando = true;
    late _SaveCartResultado resultado;
    try {
      resultado =
          await LoadingProcessDialogGenericWidget.show<_SaveCartResultado>(
            context: Get.context!,
            process: () async {
              try {
                return await _persistirReopenCart(item);
              } catch (err) {
                return _SaveCartResultado.erro(
                  'Erro ao reabrir carrinho!',
                  err.toString(),
                );
              }
            },
          );
    } catch (err) {
      resultado = _SaveCartResultado.erro(
        'Erro ao reabrir carrinho!',
        err.toString(),
      );
    } finally {
      _processando = false;
    }

    if (!resultado.sucesso) {
      await MessageDialogView.show(
        context: Get.context!,
        message: resultado.message ?? 'Erro ao reabrir carrinho!',
        detail: resultado.detail ?? 'Não foi possível reabrir o carrinho.',
      );
      return false;
    }

    return true;
  }

  Future<_SaveCartResultado> _persistirReopenCart(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    final headerOk = await _atualizarSituacaoSeparacao();
    if (!headerOk ||
        _separarConsulta.situacao != ExpedicaoSituacaoModel.separando) {
      return const _SaveCartResultado.erro(
        'Não é possível reabrir!',
        'Só é possível reabrir o carrinho enquanto a separação estiver em andamento.',
      );
    }

    final carrinhoEstagio = await _carregarCarrinhoEstagio(item);
    if (carrinhoEstagio == null) {
      return const _SaveCartResultado.erro(
        'Carrinho não encontrado!',
        'Carrinho não encontrado na tabela percurso estágio!',
      );
    }

    final carrinhoPercursoEstagio = carrinhoEstagio.estagio;
    if (carrinhoPercursoEstagio.situacao == ExpedicaoSituacaoModel.cancelada) {
      return const _SaveCartResultado.erro(
        'Carrinho já cancelado!',
        'Não é possível reabrir um carrinho que esteja cancelado!',
      );
    }

    if (carrinhoPercursoEstagio.situacao != ExpedicaoSituacaoModel.separado) {
      return const _SaveCartResultado.erro(
        'Carrinho não finalizado!',
        'Só é possível reabrir um carrinho que esteja finalizado!',
      );
    }

    if (carrinhoPercursoEstagio.codUsuarioInicio !=
            _processoExecutavel.codUsuario &&
        _usuarioLogado.salvaCarrinhoOutroUsuario != 'S') {
      return _SaveCartResultado.erro(
        'Carrinho não pertence a você!',
        'Carrinho não pode ser reaberto. Solicite para o usuário ${carrinhoPercursoEstagio.nomeUsuarioInicio} reabrir!',
      );
    }

    final itensSeparacaoCarrinho = await _itensNaoCanceladosDoCarrinho(item);

    final newCarrinho = carrinhoEstagio.carrinho.copyWith(
      situacao: ExpedicaoCarrinhoSituacaoModel.emSeparacao,
    );

    await CarrinhoPercursoEstagioReabrirService(
      carrinho: newCarrinho,
      carrinhoPercursoEstagio: carrinhoPercursoEstagio,
    ).execute();

    if (itensSeparacaoCarrinho.isNotEmpty) {
      await SeparacaoReabrirItemService().updateAll(itensSeparacaoCarrinho);
    }

    _separadoCarrinhoGridController.updateGrid(item.reabrir());
    _separadoCarrinhoGridController.update();

    return const _SaveCartResultado.ok();
  }

  Future<bool> _atualizarSituacaoSeparacao() async {
    final atual = await _separarConsultaServices.separar();
    if (atual == null) {
      return false;
    }

    _separarConsulta.situacao = atual.situacao;
    return true;
  }

  Future<
    ({
      ExpedicaoCarrinhoModel carrinho,
      ExpedicaoCarrinhoPercursoEstagioModel estagio,
    })?
  >
  _carregarCarrinhoEstagio(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
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
      return null;
    }

    return (carrinho: carrinho.last, estagio: carrinhosPercursoEstagio.last);
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>>
  _itensNaoCanceladosDoCarrinho(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) async {
    final itensSeparacao = await _separarConsultaServices.itensSeparacao();
    return itensSeparacao
        .where(
          (el) =>
              el.codEmpresa == item.codEmpresa &&
              el.codCarrinho == item.codCarrinho &&
              el.itemCarrinhoPercurso == item.item &&
              el.situacao != ExpedicaoItemSituacaoModel.cancelado,
        )
        .toList();
  }

  bool _podeSalvarCarrinho(ExpedicaoCarrinhoPercursoEstagioConsultaModel item) {
    return item.situacao != ExpedicaoSituacaoModel.cancelada &&
        item.situacao != ExpedicaoSituacaoModel.separado &&
        _separarConsulta.situacao != ExpedicaoSituacaoModel.cancelada &&
        _separarConsulta.situacao != ExpedicaoSituacaoModel.separado;
  }

  bool _podeReabrirCarrinho(
    ExpedicaoCarrinhoPercursoEstagioConsultaModel item,
  ) {
    return SeparacaoCarrinhoValidacao.podeReabrir(
      situacaoSeparacao: _separarConsulta.situacao,
      situacaoCarrinho: item.situacao,
    );
  }

  ExpedicaoCarrinhoPercursoEstagioConsultaModel? _carrinhoParaAtalho({
    bool somenteSalvavel = false,
  }) {
    final itens = _separadoCarrinhoGridController.itensSort;
    if (itens.isEmpty) {
      return null;
    }

    final candidatos = somenteSalvavel
        ? itens.where(_podeSalvarCarrinho).toList()
        : itens;
    if (candidatos.isEmpty) {
      return null;
    }

    final selecionado = _separadoCarrinhoGridController.selectedItem;
    if (selecionado != null &&
        (!somenteSalvavel || _podeSalvarCarrinho(selecionado))) {
      return selecionado;
    }

    if (candidatos.length == 1) {
      return candidatos.first;
    }

    final emSeparacao = candidatos.where(
      (el) =>
          el.situacao == ExpedicaoSituacaoModel.separando ||
          el.situacao == ExpedicaoSituacaoModel.emAndamento ||
          el.situacao == ExpedicaoSituacaoModel.emSeparacao,
    );
    if (emSeparacao.isNotEmpty) {
      return emSeparacao.first;
    }

    return candidatos.first;
  }

  Future<void> editCartFromShortcut() async {
    final item = _carrinhoParaAtalho();
    if (item == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Adicione um carrinho para editar.',
      );
      return;
    }

    await editCart(item);
  }

  Future<void> saveCartFromShortcut() async {
    final item = _carrinhoParaAtalho(somenteSalvavel: true);
    if (item == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Não há carrinho disponível para salvar.',
      );
      return;
    }

    await saveCart(item);
  }

  Future<void> reopenCartFromShortcut() async {
    final selecionado = _separadoCarrinhoGridController.selectedItem;
    if (selecionado != null && _podeReabrirCarrinho(selecionado)) {
      await reopenCart(selecionado);
      return;
    }

    final reabrivel = _separadoCarrinhoGridController.itensSort
        .where(_podeReabrirCarrinho)
        .firstOrNull;
    if (reabrivel == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Não há carrinho disponível para reabrir.',
      );
      return;
    }

    await reopenCart(reabrivel);
  }

  Future<void> removeCartFromShortcut() async {
    final item = _carrinhoParaAtalho(somenteSalvavel: true);
    if (item == null) {
      await MessageDialogView.show(
        context: Get.context!,
        message: 'Nenhum carrinho!',
        detail: 'Não há carrinho disponível para excluir.',
      );
      return;
    }

    await removeCart(item);
  }

  void _evetsCarrinhoGrid() {
    _separadoCarrinhoGridController.onPressedRemove = (item) async {
      await removeCart(item);
    };

    _separadoCarrinhoGridController.onPressedEdit = (item) async {
      await editCart(item);
    };

    _separadoCarrinhoGridController.onPressedSave = (item) async {
      await saveCart(item);
    };

    _separadoCarrinhoGridController.onPressedReopen = (item) async {
      await reopenCart(item);
    };
  }

  void _liteners() {
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
            final car = ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(
              el,
            );

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
            final car = ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(
              el,
            );

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
            final car = ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(
              el,
            );

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
