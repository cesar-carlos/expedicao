import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/repository/processo_executavel/processo_executavel_repository.dart';

class ProcessoExecutavelService {
  Future<ProcessoExecutavelModel?> executar() async {
    final repository = ProcessoExecutavelRepository();
    const params = "Status LIKE 'Ativo'";
    final response = await repository.select(params);

    if (response.isEmpty) {
      return null;
    }

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

    //TODO: verificar se o processo foi executado com sucesso
    //await repository.update(newProcessoExecutavel);
    return newProcessoExecutavel;
  }
}
