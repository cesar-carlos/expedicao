import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_atualizar_service.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_model.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';

class ConferirServices {
  final origem = ExpedicaoOrigemModel.conferencia;
  final ExpedicaoConferirModel conferir;

  final repositoryConferir = ConferirRepository();
  final repositoryEstagio = ExpedicaoEstagioRepository();

  ConferirServices(this.conferir);

  Future<void> iniciar() async {
    final newConferir = conferir.copyWith(
      situacao: ExpedicaoSituacaoModel.emConverencia,
    );

    final existsPercurso = await _existsPercurso();
    if (!existsPercurso) await _iniciarPercurso();
    if (existsPercurso) await _atualizarPercurso();

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

  static Future<void> atualizar(ExpedicaoConferirModel conferir) async {
    await ConferirRepository().update(conferir);
  }

  Future<bool> _existsPercurso() async {
    final params = '''
        CodEmpresa = ${conferir.codEmpresa} 
      AND Origem = '${conferir.origem}' 
      AND CodOrigem = ${conferir.codOrigem} 
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''';

    final carrinhoPercurso = await CarrinhoPercursoRepository().select(params);
    return carrinhoPercurso.isNotEmpty;
  }

  Future<void> _iniciarPercurso() async {
    await ExpedicaoPercursoAdicionarService(
      codEmpresa: conferir.codEmpresa,
      origem: origem,
      codOrigem: conferir.codConferir,
      situacao: ExpedicaoSituacaoModel.emConverencia,
    ).execute();
  }

  Future<void> _atualizarPercurso() async {
    await ExpedicaoPercursoAtualizarService(
      codEmpresa: conferir.codEmpresa,
      origem: conferir.origem,
      codOrigem: conferir.codOrigem,
      situacao: ExpedicaoSituacaoModel.emConverencia,
    ).execute();
  }
}
