import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/processo_executavel/processo_executavel_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class ProcessoExecutavelService {
  final processoExecutavelRepository = ProcessoExecutavelRepository();

  Future<ProcessoExecutavelModel?> executar() async {
    try {
      final queryBuilder = QueryBuilder()
          .like('Status', 'Ativo')
          .orderByDesc('CodProcessoExecutavel')
          .paginate(limit: 1);
      final response = await processoExecutavelRepository.select(queryBuilder);

      if (response.isEmpty) return null;

      final processoExecutavel = response.first;

      final newProcessoExecutavel = processoExecutavel.copyWith(
        status: 'Executado',
      );

      return newProcessoExecutavel;
    } catch (e) {
      throw AppError.fromUnknown(e);
    }
  }
}
