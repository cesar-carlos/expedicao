import 'package:app_expedicao/src/repository/expedicao_conferir_item/conferir_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_model.dart';

class ConferenciaRemoverItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  ConferenciaRemoverItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> remove({required String item}) async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND Item = '$item'

    ''';

    final repository = ConferenciaItemRepository();
    final response = await repository.select(params);

    for (var el in response) {
      await repository.delete(el);
    }
  }

  Future<void> removeAll() async {
    final conferenciaItens = await _getConferenciaItens();
    ConferenciaItemRepository().deleteAll(conferenciaItens);
  }

  Future<void> removeAllItensCart() async {
    final conferenciaItens = await _getConferenciaItensCarrinho();
    await ConferenciaItemRepository().deleteAll(conferenciaItens);
  }

  Future<List<ExpedicaoConferirItemModel>> _getConferirItensCarrinho() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodConferir = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinho = '${percursoEstagioConsulta.codCarrinho}'

    ''';

    final itens = await ConferirItemConsultaRepository().select(params);
    return itens
        .map((el) => ExpedicaoConferirItemModel.fromConsulta(el))
        .toList();
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
