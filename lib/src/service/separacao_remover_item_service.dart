import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';

class SeparacaoRemoverItemService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoRemoverItemService({
    required this.carrinhoPercurso,
    required this.percursoEstagioConsulta,
  });

  Future<void> remove({required item}) async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
      AND Item = '$item'
      ''',
    );

    for (var el in response) {
      await repository.delete(el);
    }
  }

  Future<void> removeAll() async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      ''' CodEmpresa = ${carrinhoPercurso.codEmpresa}
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
      ''',
    );

    repository.deleteAll(response);
  }

  Future<void> removeAllItensCart() async {
    final params = ''' 
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${carrinhoPercurso.codOrigem}
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
