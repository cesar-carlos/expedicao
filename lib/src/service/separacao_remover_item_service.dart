import 'package:app_expedicao/src/model/expedicao_separacao_item_model.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_consulta_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separacao_item/separacao_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class SeparacaoRemoverItemService {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  final separacaoItemConsultaRepository = SeparacaoItemConsultaRepository();
  final separacaoItemRepository = SeparacaoItemRepository();

  SeparacaoRemoverItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> remove({required String item}) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .equals('Item', item);

      final response = await separacaoItemRepository.select(queryBuilder);

      for (var el in response) {
        await separacaoItemRepository.delete(el);
      }
    } catch (e) {
      throw Exception('Erro ao remover item da separação: $e');
    }
  }

  Future<void> removeAll() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem);

      final response = await separacaoItemRepository.select(queryBuilder);
      await separacaoItemRepository.deleteAll(response);
    } catch (e) {
      throw Exception('Erro ao remover todos os itens da separação: $e');
    }
  }

  Future<void> removeAllItensCart() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodSepararEstoque', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinhoPercurso',
              percursoEstagioConsulta.codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', percursoEstagioConsulta.item);

      final separacaoItensConsulta =
          await separacaoItemConsultaRepository.select(queryBuilder);

      final itensDel = separacaoItensConsulta.map((el) {
        return ExpedicaoSeparacaoItemModel.fromConsulta(el);
      }).toList();

      await separacaoItemRepository.deleteAll(itensDel);
    } catch (e) {
      throw Exception('Erro ao remover itens do carrinho: $e');
    }
  }
}
