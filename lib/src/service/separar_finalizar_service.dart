import 'package:app_expedicao/src/app/app_error_code.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/repository/expedicao_carrinho_percurso/carrinho_percurso_repository.dart';
import 'package:app_expedicao/src/repository/expedicao_separar/separar_repository.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SepararFinalizarService {
  final int codEmpresa;
  final int codSepararEstoque;

  SepararFinalizarService({
    required this.codEmpresa,
    required this.codSepararEstoque,
  });

  Future<void> execute() async {
    final separarRepository = SepararRepository();
    final carrinhoPercursoRepository = CarrinhoPercursoRepository();

    final paramsSeparar = '''
        CodEmpresa = $codEmpresa
      AND CodSepararEstoque = $codSepararEstoque ''';

    final paramsPercurso = '''
        CodEmpresa = $codEmpresa
      AND Origem = '${ExpedicaoOrigemModel.separacao}'
      AND CodOrigem = $codSepararEstoque ''';

    final separarEstoque = await separarRepository.select(paramsSeparar);

    final carrinhoPercurso =
        await carrinhoPercursoRepository.select(paramsPercurso);

    if (separarEstoque.isEmpty) {
      throw AppError(
        AppErrorCode.separarNaoEncontrado,
        'Separar não encontrado',
      );
    }

    if (carrinhoPercurso.isEmpty) {
      throw AppError(
        AppErrorCode.separarEstagioNaoEncontrado,
        'Percurso não encontrado',
      );
    }

    final carrinhoPercursoFinalizado = carrinhoPercurso.first
        .copyWith(situacao: ExpedicaoSituacaoModel.separado);

    final separarFinalizada = separarEstoque.first
        .copyWith(situacao: ExpedicaoSituacaoModel.separado);

    await separarRepository.update(separarFinalizada);
    await carrinhoPercursoRepository.update(carrinhoPercursoFinalizado);
  }
}
