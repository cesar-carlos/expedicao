import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';

class ConferirServices {
  final origem = ExpedicaoOrigemModel.conferencia;
  final ExpedicaoConferirModel conferir;

  final repositoryConferir = ConferirRepository();
  final repositoryEstagio = ExpedicaoEstagioRepository();

  ConferirServices(this.conferir);

  Future<void> iniciar() async {
    final newConferir = conferir.copyWith(
      situacao: ExpedicaoSituacaoModel.emAndamento,
    );

    if (!await _existsPercurso()) {
      await _iniciarPercurso();
    }

    await repositoryConferir.update(newConferir);
  }

  Future<void> pausa() async {
    throw UnimplementedError();
  }

  Future<void> retomar() async {
    throw UnimplementedError();
  }

  Future<void> finalizar() async {
    throw UnimplementedError();
  }

  Future<void> atualizar() async {
    await repositoryConferir.update(conferir);
  }

  Future<bool> _existsPercurso() async {
    final params = ''' 
        CodEmpresa = ${conferir.codEmpresa} 
      AND Origem = '${conferir.origem}' 
      AND CodOrigem = ${conferir.codOrigem} 
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''';

    final List<ExpedicaoCarrinhoPercursoModel> carrinhoPercurso =
        await CarrinhoPercursoRepository().select(params);

    return carrinhoPercurso.isNotEmpty;
  }

  Future<void> _iniciarPercurso() async {
    await ExpedicaoPercursoAdicionarService(
      codEmpresa: conferir.codEmpresa,
      origem: origem,
      codOrigem: conferir.codConferir,
    ).execute();
  }
}
