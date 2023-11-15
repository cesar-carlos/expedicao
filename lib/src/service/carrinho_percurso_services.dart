import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';

class CarrinhoPercursoServices {
  final sequenciaName = 'CarrinhoPercurso_Sequencia_1';

  final repositorySequecia = SequenciaRegistroRepository();
  final repositoryConsulta = CarrinhoPercursoConsultaRepository();
  final repositoryEstagio = CarrinhoPercursoEstagioRepository();
  final repositoryPercurso = CarrinhoPercursoRepository();
  final repositoryCarrinho = CarrinhoRepository();

  Future<List<ExpedicaoPercursoConsultaModel>> consultaPercurso(
      [String params = '']) async {
    return await repositoryConsulta.select(params);
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> selectPercurso(
      [String params = '']) async {
    return await repositoryPercurso.select(params);
  }

  Future<List<ExpedicaoPercursoEstagioModel>> selectEstagio(
      [String params = '']) async {
    return await repositoryEstagio.select(params);
  }

  Future<ExpedicaoCarrinhoPercursoModel> insertPercurso(
    ExpedicaoCarrinhoPercursoModel el,
  ) async {
    final sequencia = await repositorySequecia.select(sequenciaName);
    final newCarrinho = el.copyWith(codCarrinho: sequencia.first.valor);
    await repositoryPercurso.insert(newCarrinho);
    return newCarrinho;
  }

  Future<ExpedicaoPercursoEstagioModel> insertEstagio(
    ExpedicaoPercursoEstagioModel el,
  ) async {
    final sequencia = await repositorySequecia.select(sequenciaName);
    final newCarrinho = el.copyWith(codCarrinhoPercurso: sequencia.first.valor);
    await repositoryEstagio.insert(newCarrinho);
    return newCarrinho;
  }

  Future<void> updateEstagio(
    ExpedicaoPercursoEstagioModel el,
  ) async {
    await repositoryEstagio.update(el);
  }

  Future<void> updatePercurso(
    ExpedicaoCarrinhoPercursoModel el,
  ) async {
    await repositoryPercurso.update(el);
  }

  Future<void> deletePercurso(ExpedicaoCarrinhoPercursoModel el) async {
    await repositoryPercurso.delete(el);
  }

  Future<void> addCarrinhoPercurso(
    ExpedicaoCarrinhoModel carrinho,
    ExpedicaoPercursoEstagioModel estagio,
  ) async {}
}
