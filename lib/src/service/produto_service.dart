import 'package:app_expedicao/src/app/app_dialog.dart';
import 'package:app_expedicao/src/model/estoque_produto_consulta_model.dart';
import 'package:app_expedicao/src/repository/estoque_produto/estoque_produto_consulta_repository.dart';

class ProdutoService {
  ProdutoService();

  Future<({AppDialog? left, EstoqueProdutoConsultaModel? right})>
      consultaPorCodigo(int codigo) async {
    final produtos =
        await EstoqueProdutoConsultaRepository().select('CodProduto = $codigo');

    if (produtos.isEmpty) {
      return (
        left: AppDialog(
          title: 'Produto não encontrado!',
          message: 'O produto não foi encontrado na base de dados!',
        ),
        right: null,
      );
    } else {
      return (left: null, right: produtos.first);
    }
  }

  Future<({AppDialog? left, EstoqueProdutoConsultaModel? right})>
      consultaPorCodigoBarras(String codigo) async {
    final produtos = await EstoqueProdutoConsultaRepository()
        .select("CodigoBarras = '$codigo'");

    if (produtos.isEmpty) {
      return (
        right: null,
        left: AppDialog(
            title: 'Produto não encontrado!',
            message: 'O produto não foi encontrado na base de dados!')
      );
    } else {
      return (left: null, right: produtos.first);
    }
  }
}
