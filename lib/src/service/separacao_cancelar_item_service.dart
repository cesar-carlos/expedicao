import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SeparacaoCancelarItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separacaoItemRepository = SeparacaoItemRepository();

  SeparacaoCancelarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> cancelar({required String item}) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .equals('Item', item);

      final response = await separacaoItemRepository.select(queryBuilder);

      for (var el in response) {
        final newItem = el.copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );

        await separacaoItemRepository.update(newItem);
      }
    } catch (e) {
      throw Exception('Erro ao cancelar item da separação: $e');
    }
  }

  Future<void> cancelarAll() async {
    try {
      final separacaoItens = await _getSeparacaoItens();
      final newItens = separacaoItens.map((el) {
        return el.copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );
      }).toList();

      await separacaoItemRepository.updateAll(newItens);
    } catch (e) {
      throw Exception('Erro ao cancelar todos os itens da separação: $e');
    }
  }

  Future<void> cancelarAllItensCart() async {
    try {
      final separacaoItens = await _getSeparacaoItensCarrinho();
      final newItens = separacaoItens.map((el) {
        return ExpedicaoSeparacaoItemModel.fromConsulta(el).copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );
      }).toList();

      await separacaoItemRepository.updateAll(newItens);
    } catch (e) {
      throw Exception('Erro ao cancelar itens do carrinho: $e');
    }
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>>
      _getSeparacaoItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinhoPercurso',
              percursoEstagioConsulta.codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', percursoEstagioConsulta.item);

      return await separacaoItemConsultaRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens do carrinho: $e');
    }
  }

  Future<List<ExpedicaoSeparacaoItemModel>> _getSeparacaoItens() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem);

      return await separacaoItemRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens da separação: $e');
    }
  }
}
