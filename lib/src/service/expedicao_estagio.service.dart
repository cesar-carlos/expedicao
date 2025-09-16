import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';

class ExpedicaoEstagioService {
  final expedicaoEstagioRepository = ExpedicaoEstagioRepository();

  Future<ExpedicaoEstagioModel> separacao() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('Origem', ExpedicaoOrigemModel.separacao)
          .equals('Ativo', 'S');

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty) {
        throw Exception('Estágio de separação não encontrado');
      }

      return estagios.last;
    } catch (e) {
      if (e is Exception && e.toString().contains('não encontrado')) {
        rethrow;
      }
      throw Exception('Erro ao buscar estágio de separação: $e');
    }
  }

  Future<ExpedicaoEstagioModel> conferencia() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('Origem', ExpedicaoOrigemModel.conferencia)
          .equals('Ativo', 'S');

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty) {
        throw Exception('Estágio de conferência não encontrado');
      }

      return estagios.last;
    } catch (e) {
      if (e is Exception && e.toString().contains('não encontrado')) {
        rethrow;
      }
      throw Exception('Erro ao buscar estágio de conferência: $e');
    }
  }
}
