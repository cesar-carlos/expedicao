import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class CarrinhoPercursoEstagioServices {
  final repository = CarrinhoPercursoEstagioRepository();

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> select([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      return await repository.select(queryBuilder ?? QueryBuilder());
    } catch (e) {
      throw Exception('Erro ao selecionar carrinhos de percurso estágio: $e');
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> insert(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    try {
      final result = await repository.insert(percursoEstagio);

      if (result.isEmpty) {
        throw Exception(
            'Erro ao inserir carrinho de percurso estágio: nenhum registro retornado');
      }

      return result.first;
    } catch (e) {
      if (e is Exception &&
          e
              .toString()
              .contains('Erro ao inserir carrinho de percurso estágio')) {
        rethrow;
      }
      throw Exception('Erro ao inserir carrinho de percurso estágio: $e');
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> update(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    try {
      final result = await repository.update(percursoEstagio);

      if (result.isEmpty) {
        throw Exception(
            'Erro ao atualizar carrinho de percurso estágio: nenhum registro atualizado');
      }

      return result.first;
    } catch (e) {
      if (e is Exception &&
          e
              .toString()
              .contains('Erro ao atualizar carrinho de percurso estágio')) {
        rethrow;
      }
      throw Exception('Erro ao atualizar carrinho de percurso estágio: $e');
    }
  }

  Future<void> delete(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    try {
      await repository.delete(percursoEstagio);
    } catch (e) {
      throw Exception('Erro ao excluir carrinho de percurso estágio: $e');
    }
  }
}
