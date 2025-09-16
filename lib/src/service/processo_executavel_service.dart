import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/processo_executavel/processo_executavel_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ProcessoExecutavelService {
  final processoExecutavelRepository = ProcessoExecutavelRepository();

  Future<ProcessoExecutavelModel?> executar() async {
    try {
      final queryBuilder = QueryBuilder().like('Status', 'Ativo');
      final response = await processoExecutavelRepository.select(queryBuilder);

      if (response.isEmpty) return null;

      response.sort((a, b) {
        return b.dataAbertura.compareTo(a.dataAbertura);
      });

      response.sort((a, b) {
        return b.codProcessoExecutavel.compareTo(a.codProcessoExecutavel);
      });

      final processoExecutavel = response.first;

      final newProcessoExecutavel = processoExecutavel.copyWith(
        status: 'Executado',
      );

      return newProcessoExecutavel;
    } catch (e) {
      throw Exception('Erro ao executar processo: $e');
    }
  }
}
