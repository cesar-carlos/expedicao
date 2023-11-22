import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';

class SepararConsultaServices {
  final int codEmpresa;
  final int codSepararEstoque;

  SepararConsultaServices({
    required this.codEmpresa,
    required this.codSepararEstoque,
  });

  Future<ExpedicaoSepararConsultaModel?> separarConsulta() async {
    final response = await SepararConsultaRepository().select(
      'CodEmpresa = $codEmpresa AND CodSepararEstoque = $codSepararEstoque',
    );

    if (response.isEmpty) {
      return null;
    }

    return response.first;
  }

  Future<List<ExpedicaoSepararItemConsultaModel>> itensSaparar() async {
    return await SepararItemConsultaRepository().select(
      'CodEmpresa = $codEmpresa AND CodSepararEstoque = $codSepararEstoque',
    );
  }

  Future<List<ExpedicaoPercursoEstagioConsultaModel>>
      carrinhosPercurso() async {
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
