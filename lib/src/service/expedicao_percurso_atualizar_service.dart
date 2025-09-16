import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ExpedicaoPercursoAtualizarService {
  final int codEmpresa;
  final String origem;
  final int codOrigem;
  final String situacao;
  final carrinhoPercursoRepository = CarrinhoPercursoRepository();

  ExpedicaoPercursoAtualizarService({
    required this.codEmpresa,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
  });

  Future<ExpedicaoCarrinhoPercursoModel> execute() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('Origem', origem)
          .equals('CodOrigem', codOrigem)
          .notEquals('Situacao', ExpedicaoSituacaoModel.cancelada);

      final carrinhosPercurso =
          await carrinhoPercursoRepository.select(queryBuilder);

      if (carrinhosPercurso.isEmpty) {
        throw Exception('Percurso não encontrado');
      }

      final carrinhoPercurso =
          carrinhosPercurso.last.copyWith(situacao: situacao);

      final response =
          await carrinhoPercursoRepository.update(carrinhoPercurso);

      if (response.isEmpty) {
        throw Exception('Erro ao atualizar percurso');
      }

      return response.first;
    } catch (e) {
      if (e is Exception && e.toString().contains('Percurso não encontrado')) {
        rethrow;
      }
      throw Exception('Erro ao atualizar percurso de expedição: $e');
    }
  }
}
