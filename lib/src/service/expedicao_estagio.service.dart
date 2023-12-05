import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/model/expedicao_estagio_model.dart';

class ExpedicaoEstagioService {
  Future<ExpedicaoEstagioModel> separacao() async {
    const params = "Origem = 'SE' AND Ativo = 'S'";
    final estagio = await ExpedicaoEstagioRepository().select(params);

    return estagio.last;
  }

  Future<ExpedicaoEstagioModel> conferencia() async {
    const params = "Origem = 'CF' AND Ativo = 'S'";
    final estagio = await ExpedicaoEstagioRepository().select(params);
    return estagio.last;
  }
}
