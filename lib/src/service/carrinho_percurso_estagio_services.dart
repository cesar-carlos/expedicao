import 'package:app_expedicao/src/model/send_query_socket_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_model.dart';

class CarrinhoPercursoEstagioServices {
  final repository = CarrinhoPercursoEstagioRepository();

  Future<List<ExpedicaoCarrinhoPercursoEstagioModel>> select([
    String params = '',
    int limit = 0,
    OrderBy orderBy = OrderBy.ASC,
  ]) async {
    return await repository.select(params, limit, orderBy);
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> insert(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    await repository.insert(percursoEstagio);
    return percursoEstagio;
  }

  Future<ExpedicaoCarrinhoPercursoEstagioModel> update(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    await repository.update(percursoEstagio);
    return percursoEstagio;
  }

  Future<void> delete(
      ExpedicaoCarrinhoPercursoEstagioModel percursoEstagio) async {
    repository.delete(percursoEstagio);
  }
}
