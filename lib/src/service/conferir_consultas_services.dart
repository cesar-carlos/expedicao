import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_unidade_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
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
      AND CodConferir = $codConferir ''';

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
      AND CodConferir = $codConferir ''';

    final response = await ConferirCarrinhoConsultaRepository().select(params);
    return response;
  }

  Future<ExpedicaoCarrinhoConferirConsultaModel> carrinhoConferir(
      int codCarrinho) async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir 
      AND CodCarrinho = $codCarrinho ''';

    final response = await ConferirCarrinhoConsultaRepository().select(params);
    return response.first;
  }

  Future<List<ExpedicaoConferirItemConsultaModel>> itensConferir() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir ''';

    return await ConferirItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaoConferirItemUnidadeMedidaConsultaModel>>
      itensConferirUnidades() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir ''';

    return await ConferirItemUnidadeMedidaConsultaRepository().select(params);
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensConferencia() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
      AND CodConferir = $codConferir ''';

    final result = await ConferenciaItemConsultaRepository().select(params);
    return result;
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>>
      carrinhosPercurso() async {
    final params = ''' 
        CodEmpresa = $codEmpresa 
          AND Origem = '${ExpedicaoOrigemModel.conferencia}' 
          AND CodOrigem = $codConferir  ''';

    final result =
        await CarrinhoPercursoEstagioConsultaRepository().select(params);
    return result;
  }

  Future<List<ExpedicaConferenciaItemConsultaModel>> itensCarrinho(
      int codCarrinho) async {
    final itensConferencia = await this.itensConferencia();

    return itensConferencia.where((el) {
      return el.codCarrinho == codCarrinho;
    }).toList();
  }

  Future<bool> isComplete() async {
    final itensConferir = await this.itensConferir();
    return itensConferir.every((el) => el.quantidade == el.quantidadeConferida);
  }

  Future<bool> existsOpenCart() async {
    final carrinhosPercurso = await this.carrinhosPercurso();

    final carrinhosConferindo = carrinhosPercurso.where((el) {
      return el.situacao == ExpedicaoSituacaoModel.conferindo;
    });

    if (carrinhosConferindo.isEmpty) return false;
    return true;
  }
}
