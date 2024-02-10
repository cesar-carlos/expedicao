import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';

class ConferenciaCancelarItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  ConferenciaCancelarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> cancelar({required String item}) async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND Item = '$item'

    ''';

    final repository = ConferenciaItemRepository();
    final response = await repository.select(params);

    for (var el in response) {
      final newItem = el.copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );

      await repository.update(newItem);
    }
  }

  Future<void> cancelarAll() async {
    final conferenciaItens = await _getConferenciaItens();
    final newItens = conferenciaItens.map((el) {
      return el.copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );
    }).toList();

    ConferenciaItemRepository().updateAll(newItens);
  }

  Future<void> cancelarAllItensCart() async {
    final conferenciaItens = await _getConferenciaItensCarrinho();
    final newItens = conferenciaItens.map((el) {
      return el.copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );
    }).toList();

    await ConferenciaItemRepository().updateAll(newItens);
  }

  Future<List<ExpedicaoConferenciaItemModel>>
      _getConferenciaItensCarrinho() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}  
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}'

    ''';

    return await ConferenciaItemRepository().select(params);
  }

  Future<List<ExpedicaoConferenciaItemModel>> _getConferenciaItens() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}

    ''';

    return await ConferenciaItemRepository().select(params);
  }
}
