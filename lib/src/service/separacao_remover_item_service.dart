import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class SeparacaoRemoverItemService {
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoRemoverItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> remove({required item}) async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}
      AND Item = '$item'
    ''';

    final repository = SeparacaoItemRepository();
    final response = await repository.select(params);

    for (var el in response) {
      await repository.delete(el);
    }
  }

  Future<void> removeAll() async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}
      ''';

    final repository = SeparacaoItemRepository();
    final response = await repository.select(params);
    repository.deleteAll(response);
  }

  Future<void> removeAllItensCart() async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}  
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}'

      ''';

    final separacaoItensConsulta =
        await SeparacaoItemConsultaRepository().select(params);

    final itensDel = separacaoItensConsulta.map((el) {
      return ExpedicaoSeparacaoItemModel.fromConsulta(el);
    }).toList();

    await SeparacaoItemRepository().deleteAll(itensDel);
  }
}
