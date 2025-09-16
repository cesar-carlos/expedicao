import 'dart:async';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_error.dart';
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
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ArmazenarSeparacaoAdicionarService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final _processoExecutavel = Get.find<ProcessoExecutavelModel>();

  final armazenarRepository = ArmazenarRepository();
  final separarConsultaRepository = SepararConsultaRepository();
  final separacaoItemResumoConsultaRepository =
      SeparacaoItemResumoConsultaRepository();
  final armazenarItemRepository = ArmazenarItemRepository();
  final carrinhoPercursoRepository = CarrinhoPercursoRepository();
  final carrinhoPercursoEstagioRepository = CarrinhoPercursoEstagioRepository();
  final carrinhoRepository = CarrinhoRepository();

  ArmazenarSeparacaoAdicionarService(this.carrinhoPercurso);

  Future<void> execute() async {
    try {
      final separar = await _findSeparar();
      final itensSeparacao = await _findItensSeparacao();

      if (itensSeparacao.isEmpty) {
        throw AppError('Nenhum item Separacao encontrado');
      }

      final armazenar = _createArmazenar(separar);
      final result = await armazenarRepository.insert(armazenar);

      if (result.isEmpty) {
        throw AppError('Erro ao armazenar');
      }

      final newItens = _createItensArmazenar(result.first, itensSeparacao);
      await armazenarItemRepository.insertAll(newItens);

      await _finalizarCarrinhoPercurso(carrinhoPercurso);
      await _liberarCarrinhos(carrinhoPercurso);
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao adicionar armazenamento de separação: $e');
    }
  }

  Future<ExpedicaoSepararConsultaModel> _findSeparar() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoPercurso.codEmpresa)
          .equals('CodSepararEstoque', carrinhoPercurso.codOrigem);

      final result = await separarConsultaRepository.select(queryBuilder);

      if (result.isEmpty) {
        throw AppError('Separacao não encontrada');
      }

      return result.first;
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao buscar separação: $e');
    }
  }

  Future<List<ExpedicaSeparacaoItemResumoConsultaModel>>
      _findItensSeparacao() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', carrinhoPercurso.codEmpresa)
          .equals('CodSepararEstoque', carrinhoPercurso.codOrigem)
          .equals('Situacao', ExpedicaoSituacaoModel.separado);

      final result =
          await separacaoItemResumoConsultaRepository.select(queryBuilder);

      if (result.isEmpty) {
        throw AppError('Nenhum item Separacao encontrado');
      }

      return result;
    } catch (e) {
      if (e is AppError) rethrow;
      throw Exception('Erro ao buscar itens de separação: $e');
    }
  }

  ExpedicaoArmazenar _createArmazenar(ExpedicaoSepararConsultaModel item) {
    return ExpedicaoArmazenar(
      codEmpresa: item.codEmpresa,
      codArmazenar: 0,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: item.codSepararEstoque,
      numeroDocumento: null,
      codPrioridade: item.codPrioridade,
      dataLancamento: DateTime.now(),
      horaLancamento: DateTime.now().toIso8601String().substring(11, 19),
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

    for (var item in itens) {
      newItens.add(ExpedicaoArmazenarItem(
        codEmpresa: armazenar.codEmpresa,
        codArmazenar: armazenar.codArmazenar,
        item: '00000',
        situacao: ExpedicaoSituacaoModel.aguardando,
        codcarrinhoPercurso: item.codCarrinhoPercurso,
        itemcarrinhoPercurso: item.itemCarrinhoPercurso,
        codLocalArmazenagem: item.codLocalArmazenagem,
        codProduto: item.codProduto,
        nomeProduto: item.nomeProduto,
        codUnidadeMedida: item.codUnidadeMedida,
        codProdutoEndereco: item.codProdutoEndereco,
        codigoBarras: item.codigoBarras,
        quantidade: item.quantidade,
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
        horaFinalizacao: DateTime.now().toIso8601String().substring(11, 19),
      );

      await carrinhoPercursoRepository.update(newCarrinhoPercurso);
    } catch (e) {
      throw Exception('Erro ao finalizar carrinho percurso: $e');
    }
  }

  Future<void> _liberarCarrinhos(ExpedicaoCarrinhoPercursoModel model) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', model.codEmpresa)
          .equals('CodCarrinhoPercurso', model.codCarrinhoPercurso)
          .equals('Situacao', ExpedicaoSituacaoModel.separado);

      final carrinhosPercursoEstagio =
          await carrinhoPercursoEstagioRepository.select(queryBuilder);

      final codCarrinhos =
          carrinhosPercursoEstagio.map((e) => e.codCarrinho).toList();

      if (codCarrinhos.isEmpty) return;

      final carrinhosQueryBuilder = QueryBuilder()
          .equals('CodEmpresa', model.codEmpresa)
          .inList('CodCarrinho', codCarrinhos);

      final carrinhos = await carrinhoRepository.select(carrinhosQueryBuilder);

      for (var carrinho in carrinhos) {
        final newCarrinho = carrinho.copyWith(
          situacao: ExpedicaoCarrinhoSituacaoModel.liberado,
        );

        await carrinhoRepository.update(newCarrinho);
      }
    } catch (e) {
      throw Exception('Erro ao liberar carrinhos: $e');
    }
  }
}
