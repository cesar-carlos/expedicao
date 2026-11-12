import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ExpedicaoEstagioService {
  final expedicaoEstagioRepository = ExpedicaoEstagioRepository();

  Future<ExpedicaoEstagioModel> separacao() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('Origem', ExpedicaoOrigemModel.separacao)
          .equals('Ativo', 'S');

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty) {
        throw AppError('Estágio de separação não encontrado');
      }

      return estagios.last;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }

  Future<ExpedicaoEstagioModel> conferencia() async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('Origem', ExpedicaoOrigemModel.conferencia)
          .equals('Ativo', 'S');

      final estagios = await expedicaoEstagioRepository.select(queryBuilder);

      if (estagios.isEmpty) {
        throw AppError('Estágio de conferência não encontrado');
      }

      return estagios.last;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
