import 'package:app_expedicao/src/app/app_dialog.dart';
import 'package:app_expedicao/src/model/estoque_produto_consulta_model.dart';
import 'package:app_expedicao/src/repository/estoque_produto/produto_consulta_repository.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

class ProdutoService {
  final produtoConsultaRepository = EstoqueProdutoConsultaRepository();

  ProdutoService();

  Future<({AppDialog? left, EstoqueProdutoConsultaModel? right})>
      consultaPorCodigo(int codProduto) async {
    try {
      final queryBuilder = QueryBuilder().equals('CodProduto', codProduto);

      final produtos = await produtoConsultaRepository.select(queryBuilder);

      if (produtos.isEmpty) {
        return (
          left: AppDialog(
            title: 'Produto não encontrado!',
            message: 'O produto não foi encontrado na base de dados!',
          ),
          right: null,
        );
      } else {
        return (
          left: null,
          right: produtos.first,
        );
      }
    } catch (e) {
      throw Exception('Erro ao consultar produto por código: $e');
    }
  }

  Future<({AppDialog? left, EstoqueProdutoConsultaModel? right})>
      consultaPorCodigoBarras(String codigo) async {
    try {
      final queryBuilder = QueryBuilder().equals('CodigoBarras', codigo);

      final produtos = await produtoConsultaRepository.select(queryBuilder);

      if (produtos.isEmpty) {
        return (
          right: null,
          left: AppDialog(
            title: 'Produto não encontrado!',
            message: 'O produto não foi encontrado na base de dados!',
          ),
        );
      } else {
        return (
          left: null,
          right: produtos.first,
        );
      }
    } catch (e) {
      throw Exception('Erro ao consultar produto por código de barras: $e');
    }
  }
}
