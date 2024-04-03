import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/processo_executavel/processo_executavel_repository.dart';

class ProcessoExecutavelService {
  Future<ProcessoExecutavelModel?> executar() async {
    try {
      final repository = ProcessoExecutavelRepository();
      //final dataAtual = DateTime.now().toIso8601String().substring(0, 10);
      final params = " Status LIKE 'Ativo' ";

      final response = await repository.select(params);

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
      return null;
    }
  }
}
