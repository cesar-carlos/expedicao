import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';

class ExpedicaoPercursoAdicionarService {
  final int codEmpresa;
  final String origem;
  final int codOrigem;
  final String situacao;

  ExpedicaoPercursoAdicionarService({
    required this.codEmpresa,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
  });

  Future<ExpedicaoCarrinhoPercursoModel> execute() async {
    final repository = CarrinhoPercursoRepository();
    final carrinhoPercurso = _createPercurso();
    final respose = await repository.insert(carrinhoPercurso);
    return respose.first;
  }

  ExpedicaoCarrinhoPercursoModel _createPercurso() {
    return ExpedicaoCarrinhoPercursoModel(
      codEmpresa: codEmpresa,
      codCarrinhoPercurso: 0,
      origem: origem,
      codOrigem: codOrigem,
      situacao: situacao,
      dataInicio: DateTime.now(),
      horaInicio: DateTime.now().toString().substring(11, 19),
    );
  }
}
