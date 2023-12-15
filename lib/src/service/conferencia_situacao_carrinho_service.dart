import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';

class ConferenciaSituacaoCarrinhoService {
  final int codEmpresa;
  final int codConferir;

  ConferenciaSituacaoCarrinhoService({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<ExpedicaoCarrinhoConferirConsultaModel?> consulta(
      int codCarrinho) async {
    final params = '''
        codEmpresa = $codEmpresa 
      AND codConferir = $codConferir 
      AND codCarrinho = $codCarrinho

    ''';

    final carrinhos = await ConferirCarrinhoConsultaRepository().select(params);
    if (carrinhos.isEmpty) return null;

    final carrinho = carrinhos.last;
    return carrinho;
  }
}
