import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';

class SeparacaoCancelarItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  SeparacaoCancelarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> cancelar({required item}) async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}
      AND Item = '$item' ''';

    final repository = SeparacaoItemRepository();
    final response = await repository.select(params);

    for (var el in response) {
      final newItem = el.copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );

      await repository.update(newItem);
    }
  }

  Future<void> cancelarAll() async {
    final separacaoItens = await _getSeparacaoItens();
    final newItens = separacaoItens.map((el) {
      return el.copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );
    }).toList();

    SeparacaoItemRepository().updateAll(newItens);
  }

  Future<void> cancelarAllItensCart() async {
    final separacaoItens = await _getSeparacaoItensCarrinho();
    final newItens = separacaoItens.map((el) {
      return ExpedicaoSeparacaoItemModel.fromConsulta(el).copyWith(
        situacao: ExpedicaoItemSituacaoModel.cancelado,
      );
    }).toList();

    await SeparacaoItemRepository().updateAll(newItens);
  }

  Future<List<ExpedicaSeparacaoItemConsultaModel>>
      _getSeparacaoItensCarrinho() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem}
      AND CodCarrinhoPercurso = ${percursoEstagioConsulta.codCarrinhoPercurso}  
      AND ItemCarrinhoPercurso = '${percursoEstagioConsulta.item}' ''';

    return await SeparacaoItemConsultaRepository().select(params);
  }

  Future<List<ExpedicaoSeparacaoItemModel>> _getSeparacaoItens() async {
    final params = '''
        CodEmpresa = ${percursoEstagioConsulta.codEmpresa}
      AND CodSepararEstoque = ${percursoEstagioConsulta.codOrigem} ''';

    return await SeparacaoItemRepository().select(params);
  }
}
