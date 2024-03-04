import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_consulta_repository.dart';
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
    final carrinhoPercursoRepository = CarrinhoPercursoRepository();
    final conferirConsultaRepository = ConferirConsultaRepository();

    final paramsConferir = '''
        CodEmpresa = $codEmpresa
      AND CodConferir = $codConferir ''';

    final conferirsConsulta =
        await conferirConsultaRepository.select(paramsConferir);

    final conferirs = await conferirRepository.select(paramsConferir);

    if (conferirsConsulta.isEmpty)
      throw AppErrorAlert('Conferencia não encontrado');

    final conferir = conferirs.first;
    final conferirConsulta = conferirsConsulta.first;

    final paramsPercurso = '''
        CodEmpresa = $codEmpresa
      AND CodCarrinhoPercurso = ${conferirConsulta.codCarrinhoPercurso} ''';

    final carrinhoPercurso =
        await carrinhoPercursoRepository.select(paramsPercurso);

    final conferirFinalizada =
        conferir.copyWith(situacao: ExpedicaoSituacaoModel.conferido);

    final carrinhoPercursoFinalizado = carrinhoPercurso.first
        .copyWith(situacao: ExpedicaoSituacaoModel.conferido);

    await conferirRepository.update(conferirFinalizada);
    await carrinhoPercursoRepository.update(carrinhoPercursoFinalizado);
  }
}
