import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/service/expedicao_percurso_adicionar_service.dart';
import 'package:app_expedicao/src/model/expedicao_separar_model.dart';

class SepararServices {
  final ExpedicaoSepararModel separar;

  SepararServices(this.separar);

  Future<void> iniciar() async {
    final existsPercurso = await _existsPercurso();
    if (!existsPercurso) await _iniciarPercurso();

    final newSeparar = separar.copyWith(
      situacao: ExpedicaoSituacaoModel.separando,
    );

    await SepararRepository().update(newSeparar);
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

  static Future<void> atualizar(ExpedicaoSepararModel separar) async {
    await SepararRepository().update(separar);
  }

  Future<bool> _existsPercurso() async {
    final params = '''
        CodEmpresa = ${separar.codEmpresa} 
      AND Origem = '${ExpedicaoOrigemModel.separacao}' 
      AND CodOrigem = ${separar.codSepararEstoque} 
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''';

    final carrinhoPercurso = await CarrinhoPercursoRepository().select(params);
    return carrinhoPercurso.isNotEmpty;
  }

  Future<void> _iniciarPercurso() async {
    await ExpedicaoPercursoAdicionarService(
      codEmpresa: separar.codEmpresa,
      origem: ExpedicaoOrigemModel.separacao,
      codOrigem: separar.codSepararEstoque,
      situacao: ExpedicaoSituacaoModel.emSeparacao,
    ).execute();
  }
}
