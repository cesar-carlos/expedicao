import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/sequencia_registro/sequencia_registro_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinhos/carrinho_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_adicionar_service.dart';

class CarrinhoPercursoServices {
  final sequenciaName = 'CarrinhoPercurso_Sequencia_1';

  final repositorySequecia = SequenciaRegistroRepository();
  final repositoryConsulta = CarrinhoPercursoConsultaRepository();
  final repositoryEstagio = CarrinhoPercursoEstagioRepository();
  final repositoryPercurso = CarrinhoPercursoRepository();
  final repositoryCarrinho = CarrinhoRepository();

  Future<List<ExpedicaoPercursoEstagioConsultaModel>> consultaPercurso(
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

  Future<void> adicionarCarrinhoPercursoService({
    required ExpedicaoCarrinhoModel carrinho,
    required ExpedicaoCarrinhoPercursoModel carrinhoPercurso,
    required ExpedicaoPercursoEstagio percursoEstagio,
    required ProcessoExecutavelModel processo,
  }) async {
    final adicionar = CarrinhoPercursoAdicionarService(
      carrinho: carrinho,
      carrinhoPercurso: carrinhoPercurso,
      percursoEstagio: percursoEstagio,
      processo: processo,
    );

    await adicionar.execute();
  }
}
