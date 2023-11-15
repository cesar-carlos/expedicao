import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_consulta_model.dart';

class SepararEstoqueconsultaServices {
  final int codEmpresa;
  final int codSepararEstoque;

  SepararEstoqueconsultaServices({
    required this.codEmpresa,
    required this.codSepararEstoque,
  });

  Future<List<ExpedicaoSepararItemConsultaModel>> itensSaparar() async {
    return await SepararItemConsultaRepository().select(
      'CodEmpresa = $codEmpresa AND CodSepararEstoque = $codSepararEstoque',
    );
  }

  Future<List<ExpedicaoPercursoConsultaModel>> carrinhos() async {
    return await CarrinhoPercursoConsultaRepository().select(
      'CodEmpresa = $codEmpresa AND CodOrigem = $codSepararEstoque',
    );
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> itensSeparacao() async {
    return await SeparacaoItemConsultaRepository().select(
      'CodEmpresa = $codEmpresa AND CodSepararEstoque = $codSepararEstoque',
    );
  }
}
