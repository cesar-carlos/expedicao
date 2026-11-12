import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class CarrinhoPercursoEstagioServices {
  final repository = CarrinhoPercursoEstagioRepository();

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> select([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      return await repository.select(
        (queryBuilder ?? QueryBuilder()).withAllRows(
          orderField: 'CodCarrinhoPercurso',
          thenBy: ['Item'],
        ),
      );
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> insert(
    ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio,
  ) async {
    try {
      final result = await repository.insert(percursoEstagio);

      if (result.isEmpty) {
        throw AppError(
          'Erro ao inserir carrinho de percurso estágio: nenhum registro retornado',
        );
      }

      return result.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> update(
    ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio,
  ) async {
    try {
      final result = await repository.update(percursoEstagio);

      if (result.isEmpty) {
        throw AppError(
          'Erro ao atualizar carrinho de percurso estágio: nenhum registro atualizado',
        );
      }

      return result.first;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<void> delete(
    ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio,
  ) async {
    try {
      await repository.delete(percursoEstagio);
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
