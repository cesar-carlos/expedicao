import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';

class CarrinhoPercursoServices {
  final sequenciaName = 'CarrinhoPercurso_Sequencia_1';

  final repositorySequecia = SequenciaRegistroRepository();
  final repositoryConsulta = CarrinhoPercursoEstagioConsultaRepository();
  final repositoryEstagio = CarrinhoPercursoEstagioRepository();
  final repositoryPercurso = CarrinhoPercursoRepository();
  final repositoryCarrinho = CarrinhoRepository();

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>> consultaPercurso(
      [String params = '']) async {
    return await repositoryConsulta.select(params);
  }

  Future<List<ExpedicaoCarrinhoPercursoModel>> select(
      [String params = '']) async {
    final respose = await repositoryPercurso.select(params);
    return respose;
  }
}
