import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class CarrinhoService {
  final repository = CarrinhoRepository();
  final repositoryConsulta = CarrinhoConsultaRepository();

  Future<List<ExpedicaoCarrinhoConsultaModel>> consulta([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      return await repositoryConsulta.select(queryBuilder ?? QueryBuilder());
    } catch (e) {
      throw Exception('Erro ao consultar carrinhos: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoModel>> select([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      return await repository.select(queryBuilder ?? QueryBuilder());
    } catch (e) {
      throw Exception('Erro ao selecionar carrinhos: $e');
    }
  }

  Future<ExpedicaoCarrinhoModel> insert(ExpedicaoCarrinhoModel carrinho) async {
    try {
      final newCarrinho = carrinho.copyWith(codCarrinho: 0);
      final result = await repository.insert(newCarrinho);

      if (result.isEmpty) {
        throw Exception('Erro ao inserir carrinho: nenhum registro retornado');
      }

      return result.first;
    } catch (e) {
      if (e is Exception && e.toString().contains('Erro ao inserir carrinho')) {
        rethrow;
      }
      throw Exception('Erro ao inserir carrinho: $e');
    }
  }

  Future<ExpedicaoCarrinhoModel> update(ExpedicaoCarrinhoModel carrinho) async {
    try {
      final result = await repository.update(carrinho);

      if (result.isEmpty) {
        throw Exception(
            'Erro ao atualizar carrinho: nenhum registro atualizado');
      }

      return result.first;
    } catch (e) {
      if (e is Exception &&
          e.toString().contains('Erro ao atualizar carrinho')) {
        rethrow;
      }
      throw Exception('Erro ao atualizar carrinho: $e');
    }
  }

  Future<void> delete(ExpedicaoCarrinhoModel carrinho) async {
    try {
      await repository.delete(carrinho);
    } catch (e) {
      throw Exception('Erro ao excluir carrinho: $e');
    }
  }
}
