import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';

class ExpedicaoPercursoAtualizarService {
  final int codEmpresa;
  final String origem;
  final int codOrigem;
  final String situacao;

  ExpedicaoPercursoAtualizarService({
    required this.codEmpresa,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
  });

  Future<ExpedicaoCarrinhoPercursoModel> execute() async {
    final params = '''
        CodEmpresa = $codEmpresa 
      AND Origem = '$origem' 
      AND CodOrigem = $codOrigem 
      AND Situacao <> '${ExpedicaoSituacaoModel.cancelada}' ''';

    final repository = CarrinhoPercursoRepository();
    final carrinhosPercurso = await repository.select(params);
    if (carrinhosPercurso.isEmpty) throw Exception('Percurso não encontrado');

    final carrinhoPercurso =
        carrinhosPercurso.last.copyWith(situacao: situacao);

    final respose = await repository.update(carrinhoPercurso);
    return respose.first;
  }
}
