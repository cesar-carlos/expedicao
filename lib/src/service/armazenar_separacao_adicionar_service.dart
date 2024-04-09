import 'dart:async';

import 'package:get/get.dart';

import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar_item.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenar/armazenar_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_resumo_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_armazenar_item/armazenar_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_resumo.consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_armazenar.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ArmazenarSeparacaoAdicionarService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  ArmazenarSeparacaoAdicionarService(this.carrinhoPercurso);

  Future<void> execute() async {
    try {
      final separar = await _findSeparar();
      final itensSeparacao = await _findItensSeparacao();

      if (itensSeparacao.isEmpty)
        throw AppError('Nenhum item Separacao encontrado');

      final armazenar = _createArmazenar(separar);

      final result = await ArmazenarRepository().insert(armazenar);

      if (result.isEmpty) throw AppError('Erro ao armazenar');

      final newItens = _createItensArmazenar(result.first, itensSeparacao);

      await ArmazenarItemRepository().insertAll(newItens);
      await _finalizarCarrinhoPercurso(carrinhoPercurso);
      await _liberarCarrinhos(carrinhoPercurso);
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpedicaoSepararConsultaModel> _findSeparar() async {
    try {
      final repository = SepararConsultaRepository();

      final params = '''
          CodEmpresa = ${carrinhoPercurso.codEmpresa}
        AND CodSepararEstoque = ${carrinhoPercurso.codOrigem} ''';

      final result = await repository.select(params);
      if (result.isEmpty) throw AppError('Separacao não encontrada');

      return result.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpedicaSeparacaoItemResumoConsultaModel>>
      _findItensSeparacao() async {
    try {
      final repository = SeparacaoItemResumoConsultaRepository();

      final params = '''
          CodEmpresa = ${carrinhoPercurso.codEmpresa}
        AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
        AND Situacao = '${ExpedicaoSituacaoModel.separado}' ''';

      final result = await repository.select(params);
      if (result.isEmpty) throw AppError('Nenhum item Separacao encontrado');

      return result;
    } catch (e) {
      rethrow;
    }
  }

  ExpedicaoArmazenar _createArmazenar(
    ExpedicaoSepararConsultaModel item,
  ) {
    return ExpedicaoArmazenar(
      codEmpresa: item.codEmpresa,
      codArmazenar: 0,
      numeroDocumento: null,
      situacao: ExpedicaoSituacaoModel.aguardando,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: item.codSepararEstoque,
      codPrioridade: item.codPrioridade,
      dataLancamento: DateTime.now(),
      horaLancamento: DateTime.now().toString().substring(11, 19),
      codUsuarioLancamento: _processoExecutavel.codUsuario,
      nomeUsuarioLancamento: _processoExecutavel.nomeUsuario,
      estacaoLancamento: _processoExecutavel.nomeComputador,
      observacao: item.observacao,
    );
  }

  List<ExpedicaoArmazenarItem> _createItensArmazenar(
    ExpedicaoArmazenar armazenar,
    List<ExpedicaSeparacaoItemResumoConsultaModel> itens,
  ) {
    final newItens = <ExpedicaoArmazenarItem>[];

    for (var el in itens) {
      newItens.add(ExpedicaoArmazenarItem(
        codEmpresa: armazenar.codEmpresa,
        codArmazenar: armazenar.codArmazenar,
        item: '00000',
        codcarrinhoPercurso: el.codCarrinhoPercurso,
        itemcarrinhoPercurso: el.itemCarrinhoPercurso,
        codProduto: el.codProduto,
        nomeProduto: el.nomeProduto,
        codUnidadeMedida: el.codUnidadeMedida,
        codProdutoEndereco: el.codProdutoEndereco,
        codigoBarras: el.codigoBarras,
        quantidade: el.quantidade,
      ));
    }

    return newItens;
  }

  Future<void> _finalizarCarrinhoPercurso(
      ExpedicaoCarrinhoPercursoModel model) async {
    try {
      final newCarrinhoPercurso = model.copyWith(
        situacao: ExpedicaoSituacaoModel.finalizada,
        dataFinalizacao: DateTime.now(),
        horaFinalizacao: DateTime.now().toString().substring(11, 19),
      );

      await CarrinhoPercursoRepository().update(newCarrinhoPercurso);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _liberarCarrinhos(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      final params = '''
          CodEmpresa = ${model.codEmpresa}
        AND CodCarrinhoPercurso = '${model.codCarrinhoPercurso}'
        AND Situacao = '${ExpedicaoSituacaoModel.separado}' ''';

      final carrinhosPercursoEstagio =
          await CarrinhoPercursoEstagioRepository().select(params);

      final List<int> codCarrinhos =
          carrinhosPercursoEstagio.map((e) => e.codCarrinho).toList();

      if (codCarrinhos.isEmpty) return;

      final carrinhos = await CarrinhoRepository().select(
        ''' CodEmpresa = ${model.codEmpresa} 
          AND CodCarrinho IN (${codCarrinhos.join(',')}) ''',
      );

      for (var el in carrinhos) {
        final newCarrinho =
            el.copyWith(situacao: ExpedicaoCarrinhoSituacaoModel.liberado);

        await CarrinhoRepository().update(newCarrinho);
      }
    } catch (e) {
      rethrow;
    }
  }
}
