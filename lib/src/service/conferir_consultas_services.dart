import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

class ConferirConsultaServices {
  final int codEmpresa;
  final int codConferir;

  ConferirConsultaServices({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<ExpedicaoConferirConsultaModel?> conferir() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir

    ''';

    final response = await ConferirConsultaRepository().select(params);
    if (response.isEmpty) {
      return null;
    }

    return response.first;
  }

  Future<List<ExpedicaoCarrinhoConferirConsultaModel>>
      carrinhosConferir() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir

    ''';

    final response = await ConferirCarrinhoConsultaRepository().select(params);
    return response;
  }

  Future<List<ExpedicaoConferirItemConsultaModel>> itensConferir() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir

    ''';

    return await ConferirItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>> itensConferencia() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir

    ''';

    return await SeparacaoItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaoCarrinhoPercursoConsultaModel>>
      carrinhosPercurso() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
          AND Origem = '${ExpedicaoOrigemModel.separacao}' 
          AND CodOrigem = $codConferir 
      
      ''';

    return await CarrinhoPercursoConsultaRepository().select(params);
  }

  Future<bool> isComplete() async {
    final itensConferir = await this.itensConferir();
    return itensConferir.every((el) => el.quantidade == el.quantidadeConferida);
  }

  Future<bool> existsOpenCart() async {
    final carrinhosPercurso = await this.carrinhosPercurso();

    final carrinhosEmAndamento = carrinhosPercurso.where((el) {
      return el.situacao == ExpedicaoSituacaoModel.emAndamento;
    });

    if (carrinhosEmAndamento.isEmpty) return false;
    return true;
  }
}
