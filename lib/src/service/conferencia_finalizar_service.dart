import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/app/app_error_alert.dart';

class ConferirFinalizarService {
  final int codEmpresa;
  final int codConferir;

  ConferirFinalizarService({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<void> execute() async {
    final conferirRepository = ConferirRepository();

    final params = '''
        CodEmpresa = $codEmpresa
      AND CodConferir = $codConferir ''';

    final conferirEstoque = await conferirRepository.select(params);

    if (conferirEstoque.isEmpty) {
      throw AppErrorAlert('Conferir não encontrado');
    }

    final conferirFinalizada = conferirEstoque.first.copyWith(
      situacao: ExpedicaoSituacaoModel.conferido,
    );

    await conferirRepository.update(conferirFinalizada);
  }
}
