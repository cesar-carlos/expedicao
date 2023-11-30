import 'package:app_expedicao/src/repository/expedicao_percurso_estagio/percurso_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_percurso_estagio.dart';

class ExpedicaoEstagioService {
  Future<ExpedicaoPercursoEstagio> separacao() async {
    const params = "Sigla = 'SE' AND Ativo = 'S'";
    final estagio = await PercursoEstagioRepository().select(params);

    return estagio.last;
  }

  Future<ExpedicaoPercursoEstagio> conferencia() async {
    const params = "Sigla = 'CF' AND Ativo = 'S'";
    final estagio = await PercursoEstagioRepository().select(params);
    return estagio.last;
  }
}
