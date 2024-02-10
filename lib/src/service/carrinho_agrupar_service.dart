import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_estagio_consulta_repository.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class CarrinhoAgruparService {
  final int codEmpresa;
  final int codCarrinhoPercurso;

  CarrinhoAgruparService({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
  });

  Future<ExpedicaoCarrinhoPercursoEstagioConsultaModel?> carrinhoPercurso(
    String item,
  ) async {
    final params = '''
        CodEmpresa = $codEmpresa
          AND CodCarrinhoPercurso = '$codCarrinhoPercurso'
          AND Item = $item  ''';

    final result =
        await CarrinhoPercursoEstagioConsultaRepository().select(params);

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<ExpedicaoCarrinhoPercursoEstagioConsultaModel>>
      carrinhosPercurso() async {
    final params = '''
        CodEmpresa = $codEmpresa
          AND CodCarrinhoPercurso = '$codCarrinhoPercurso' ''';

    final result =
        await CarrinhoPercursoEstagioConsultaRepository().select(params);

    return result;
  }
}
