import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ConferenciaRemoverItemService {
  final conferenciaItemRepository = ConferenciaItemRepository();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  ConferenciaRemoverItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> remove({required String item}) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('Item', item);

      final response = await conferenciaItemRepository.select(queryBuilder);

      for (var el in response) {
        await conferenciaItemRepository.delete(el);
      }
    } catch (e) {
      throw Exception('Erro ao remover item da conferência: $e');
    }
  }

  Future<void> removeAll() async {
    try {
      final conferenciaItens = await _getConferenciaItens();
      await conferenciaItemRepository.deleteAll(conferenciaItens);
    } catch (e) {
      throw Exception('Erro ao remover todos os itens da conferência: $e');
    }
  }

  Future<void> removeAllItensCart() async {
    try {
      final conferenciaItens = await _getConferenciaItensCarrinho();
      await conferenciaItemRepository.deleteAll(conferenciaItens);
    } catch (e) {
      throw Exception(
          'Erro ao remover todos os itens do carrinho da conferência: $e');
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>>
      _getConferenciaItensCarrinho() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('CodCarrinhoPercurso',
              percursoEstagioConsulta.codCarrinhoPercurso)
          .equals('ItemCarrinhoPercurso', percursoEstagioConsulta.item);

      return await conferenciaItemRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência do carrinho: $e');
    }
  }

  Future<List<ExpedicaoConferenciaItemModel>> _getConferenciaItens() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem);

      return await conferenciaItemRepository.select(queryBuilder);
    } catch (e) {
      throw Exception('Erro ao buscar itens de conferência: $e');
    }
  }
}
