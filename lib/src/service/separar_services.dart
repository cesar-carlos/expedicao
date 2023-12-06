import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_estagio/expedicao_estagio_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';

class SepararServices {
  final origem = ExpedicaoOrigemModel.separacao;
  final ExpedicaoSepararModel separar;

  final repositorySeparar = SepararRepository();
  final repositoryEstagio = ExpedicaoEstagioRepository();

  SepararServices({required this.separar});

  Future<void> iniciar() async {
    final newSeparar = separar.copyWith(
      situacao: ExpedicaoSituacaoModel.emAndamento,
    );

    if (!await existsPercurso()) {
      await _iniciarPercurso();
    }

    await repositorySeparar.update(newSeparar);
  }

  Future<void> pausa() async {
    final newSeparar = separar.copyWith(
      situacao: ExpedicaoSituacaoModel.emPausa,
    );

    await repositorySeparar.update(newSeparar);
  }

  Future<void> _iniciarPercurso() async {
    await ExpedicaoPercursoAdicionarService(
      codEmpresa: separar.codEmpresa,
      origem: origem,
      codOrigem: separar.codSepararEstoque,
    ).execute();
  }

  Future<bool> existsPercurso() async {
    final carrinhoPercurso = await CarrinhoPercursoRepository().select(
      ''' CodEmpresa = ${separar.codEmpresa} 
      AND Origem = '$origem' 
      AND CodOrigem = ${separar.codSepararEstoque} 
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''',
    );

    return carrinhoPercurso.isNotEmpty;
  }
}
