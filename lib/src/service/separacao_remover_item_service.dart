import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';

class SeparacaoRemoverItemService {
  final ExpedicaoCarrinhoPercursoModel carrinhoPercurso;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoRemoverItemService({
    required this.carrinhoPercurso,
    required this.percursoEstagioConsulta,
  });
  Future<void> remove({
    required codSepararEstoque,
    required item,
  }) async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = $codSepararEstoque
      AND Item = '$item'
      ''',
    );

    for (var el in response) {
      await repository.delete(el);
    }
  }

  Future<void> removeAll({
    required codSepararEstoque,
  }) async {
    final repository = SeparacaoItemRepository();
    final response = await repository.select(
      '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = $codSepararEstoque
      ''',
    );

    repository.deleteAll(response);
  }

  Future<void> removeAllItensCart({
    required codSepararEstoque,
    required codCarrinho,
  }) async {
    final repository = SeparacaoItemRepository();

    final separacaoItensConsulta =
        await SeparacaoItemConsultaRepository().select(
      '''
          CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = $codSepararEstoque
      AND CodCarrinho = $codCarrinho
      ''',
    );

    for (var el in separacaoItensConsulta) {
      if (el.situacao != 'CA') {
        final item = ExpedicaoSeparacaoItemModel.fromConsulta(el);
        await repository.delete(item);
      }
    }
  }
}
