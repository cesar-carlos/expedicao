import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/repository/expedicao_conferir/conferir_carrinho_consulta_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ConferenciaSituacaoCarrinhoService {
  final int codEmpresa;
  final int codConferir;

  final conferirCarrinhoConsultaRepository =
      ConferirCarrinhoConsultaRepository();

  ConferenciaSituacaoCarrinhoService({
    required this.codEmpresa,
    required this.codConferir,
  });

  Future<ExpedicaoCarrinhoConferirConsultaModel?> consulta(
      int codCarrinho) async {
    try {
      final queryBuilder = QueryBuilder()
          .equals('CodEmpresa', codEmpresa)
          .equals('CodConferir', codConferir)
          .equals('CodCarrinho', codCarrinho);

      final carrinhos =
          await conferirCarrinhoConsultaRepository.select(queryBuilder);

      if (carrinhos.isEmpty) {
        return null;
      }

      final carrinho = carrinhos.last;
      return carrinho;
    } catch (e) {
      throw Exception('Erro ao consultar situação do carrinho: $e');
    }
  }
}
