import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferencia_item/conferencia_item_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_model.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ConferenciaCancelarItemService {
  final conferenciaItemRepository = ConferenciaItemRepository();
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  ConferenciaCancelarItemService({
    required this.percursoEstagioConsulta,
  });

  Future<void> cancelar({required String item}) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', percursoEstagioConsulta.codEmpresa)
          .equals('CodConferir', percursoEstagioConsulta.codOrigem)
          .equals('Item', item);

      final response = await conferenciaItemRepository.select(queryBuilder);

      for (var el in response) {
        final newItem = el.copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );

        await conferenciaItemRepository.update(newItem);
      }
    } catch (e) {
      throw Exception('Erro ao cancelar item da conferência: $e');
    }
  }

  Future<void> cancelarAll() async {
    try {
      final conferenciaItens = await _getConferenciaItens();
      final newItens = conferenciaItens.map((el) {
        return el.copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );
      }).toList();

      await conferenciaItemRepository.updateAll(newItens);
    } catch (e) {
      throw Exception('Erro ao cancelar todos os itens da conferência: $e');
    }
  }

  Future<void> cancelarAllItensCart() async {
    try {
      final conferenciaItens = await _getConferenciaItensCarrinho();
      final newItens = conferenciaItens.map((el) {
        return el.copyWith(
          situacao: ExpedicaoItemSituacaoModel.cancelado,
        );
      }).toList();

      await conferenciaItemRepository.updateAll(newItens);
    } catch (e) {
      throw Exception(
          'Erro ao cancelar todos os itens do carrinho da conferência: $e');
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
