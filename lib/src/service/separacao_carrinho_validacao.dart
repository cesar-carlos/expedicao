import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';

typedef SeparacaoQuantidadeItem = ({
  int codProduto,
  String codUnidadeMedida,
  double quantidade,
});

abstract class SeparacaoCarrinhoValidacao {
  static bool quantidadeDentroDoPedido({
    required Iterable<SeparacaoQuantidadeItem> separados,
    required Iterable<SeparacaoQuantidadeItem> aSeparar,
    Iterable<SeparacaoQuantidadeItem>? somenteItensDoCarrinho,
  }) {
    final totaisSeparados = _somarPorProdutoUnidade(separados);
    final totaisASeparar = _somarPorProdutoUnidade(aSeparar);

    final chaves = somenteItensDoCarrinho != null
        ? _somarPorProdutoUnidade(somenteItensDoCarrinho).keys
        : totaisSeparados.keys;

    for (final chave in chaves) {
      final separado = totaisSeparados[chave] ?? 0.00;
      final previsto = totaisASeparar[chave] ?? 0.00;
      if (separado > previsto) {
        return false;
      }
    }

    return true;
  }

  static Map<(int, String), double> _somarPorProdutoUnidade(
    Iterable<SeparacaoQuantidadeItem> itens,
  ) {
    final totais = <(int, String), double>{};
    for (final item in itens) {
      final chave = (item.codProduto, item.codUnidadeMedida);
      totais[chave] = (totais[chave] ?? 0.00) + item.quantidade;
    }
    return totais;
  }

  static bool podeReabrir({
    required String situacaoSeparacao,
    required String situacaoCarrinho,
  }) {
    return situacaoSeparacao == ExpedicaoSituacaoModel.separando &&
        situacaoCarrinho == ExpedicaoSituacaoModel.separado;
  }
}
