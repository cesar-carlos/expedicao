import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_unidade_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class SepararConsultaServices {
  final int codEmpresa;
  final int codSepararEstoque;

  SepararConsultaServices({
    required this.codEmpresa,
    required this.codSepararEstoque,
  });

  Future<ExpedicaoSepararConsultaModel?> separar() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodSepararEstoque = $codSepararEstoque

    ''';

    final response = await SepararConsultaRepository().select(params);
    if (response.isEmpty) {
      return null;
    }

    return response.last;
  }

  Future<List<ExpedicaoSepararItemConsultaModel>> itensSaparar() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodSepararEstoque = $codSepararEstoque

    ''';

    return await SepararItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaoSepararItemUnidadeMedidaConsultaModel>>
      itensSapararUnidades() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodSepararEstoque = $codSepararEstoque

    ''';

    return await SepararItemUnidadeMedidaConsultaRepository().select(params);
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> itensSeparacao() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodSepararEstoque = $codSepararEstoque

    ''';

    return await SeparacaoItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaoCarrinhoPercursoConsultaModel>>
      carrinhosPercurso() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
          AND Origem = '${ExpedicaoOrigemModel.separacao}' 
          AND CodOrigem = $codSepararEstoque 
      
      ''';

    return await CarrinhoPercursoConsultaRepository().select(params);
  }

  Future<bool> isComplete() async {
    final itensSaparar = await this.itensSaparar();
    return itensSaparar.every((el) => el.quantidade == el.quantidadeSeparacao);
  }

  Future<bool> existsOpenCart() async {
    final carrinhosPercurso = await this.carrinhosPercurso();

    final carrinhosEmAndamento = carrinhosPercurso.where((el) {
      return el.situacao == ExpedicaoSituacaoModel.separando;
    });

    if (carrinhosEmAndamento.isEmpty) return false;
    return true;
  }
}
