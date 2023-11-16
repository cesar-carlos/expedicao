import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';

class CarrinhoPercursoEstagioServices {
  final repository = CarrinhoPercursoEstagioRepository();

  Future<List<ExpedicaoPercursoEstagioModel>> select(
      [String params = '']) async {
    return await repository.select(params);
  }

  Future<ExpedicaoPercursoEstagioModel> insert(
      ExpedicaoPercursoEstagioModel percursoEstagio) async {
    await repository.insert(percursoEstagio);
    return percursoEstagio;
  }

  Future<ExpedicaoPercursoEstagioModel> update(
      ExpedicaoPercursoEstagioModel percursoEstagio) async {
    await repository.update(percursoEstagio);
    return percursoEstagio;
  }

  Future<void> delete(ExpedicaoPercursoEstagioModel percursoEstagio) async {
    repository.delete(percursoEstagio);
  }
}
