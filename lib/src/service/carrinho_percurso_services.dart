import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class CarrinhoPercursoServices {
  final repositoryConsulta = CarrinhoPercursoEstagioConsultaRepository();
  final repositoryEstagio = CarrinhoPercursoEstagioRepository();
  final repositoryPercurso = CarrinhoPercursoRepository();
  final repositoryCarrinho = CarrinhoRepository();

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>> consultaPercurso([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      return await repositoryConsulta.select(queryBuilder ?? QueryBuilder());
    } catch (e) {
      throw Exception('Erro ao consultar percursos de carrinho: $e');
    }
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> select([
    QueryBuilder? queryBuilder,
  ]) async {
    try {
      final response =
          await repositoryPercurso.select(queryBuilder ?? QueryBuilder());
      return response;
    } catch (e) {
      throw Exception('Erro ao selecionar carrinhos de percurso: $e');
    }
  }
}
