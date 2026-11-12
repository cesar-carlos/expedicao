# Conversão de unidade

O bip no carrinho (separação e conferência) usa a conversão cadastrada em `ConversaoUnidadeMedida`. A coluna no banco é **`Codigo`**, não `CodigoBarras`.

## Coluna no banco vs campo no app

| Camada | Nome |
| --- | --- |
| Tabela `ConversaoUnidadeMedida` | `Codigo` |
| SQL da view (`cum.Codigo AS CodigoBarras`) | `CodigoBarras` |
| JSON | `CodigoBarras` (às vezes `Codigo`) |
| Dart | `codigoBarras` |

`AppHelper.conversaoCodigo(json)` lê `CodigoBarras` ou `Codigo` e faz `trim`. Comparar com `AppHelper.sameBarCode` (ignora espaço nas pontas — `CHAR` no SQL).

A view manda **duas famílias** de linha:

| Linha | Origem | `UnidadeMedidaPadrao` | `codigoBarras` | Fator |
| --- | --- | --- | --- | --- |
| Padrão | `Produto` | `S` | `Produto.CodigoBarras1` | `1`, tipo `M` |
| Conversão | `ConversaoUnidadeMedida` | `N` | `ConversaoUnidadeMedida.Codigo` | `TipoFatorConversao` + `FatorConversao` |

SQL: `src/sql/expedicao/expedicao.item.separar.unidade.medida.consulta.sql` e `…conferir.unidade.medida.consulta.sql` no servidor.

## Modelos neste app

| Modelo | Arquivo | Evento |
| --- | --- | --- |
| `ExpedicaoSepararItemUnidadeMedidaConsultaModel` | `lib/src/model/expedicao_separar_item_unidade_medida_consulta_model.dart` | `separar.item.unidade.medida.consulta` |
| `ExpedicaoConferirItemUnidadeMedidaConsultaModel` | `lib/src/model/expedicao_conferir_item_unidade_medida_consulta_model.dart` | `conferir.item.unidade.medida.consulta` |
| `EstoqueProdutoConversaoUnidadeConsultaModel` | `lib/src/model/estoque_produto_conversao_unidade_consulta_model.dart` | `produto.conversao.unidade.consulta` |

O bip do carrinho **não** usa `produto.conversao.unidade.consulta`. Esse evento é lookup avulso de estoque (`Where` na coluna `Codigo`).

## Carga — documento inteiro, páginas de 500, memória

Não filtra por carrinho. `CodEmpresa` + documento (`CodSepararEstoque` ou `CodConferir`). A view não tem `CodCarrinho`.

`allRows(thenBy: ['ItemUnidadeMedida'])` busca **500** por vez e junta. Sem `Pagination` o servidor devolve tudo num payload (`KEEP_EVERY_UNIT_ROW`). [Paginação](./paginacao.md).

O resultado inteiro fica em `_itemUnids` no grid controller.

| Fluxo | Quando busca | Onde guarda | Reuso |
| --- | --- | --- | --- |
| Separação | Tela inicial (`SepararController._fillGridSepararItens`) | `SepararGridController._itemUnids` | O carrinho **reusa**. Não busca de novo |
| Conferência | Ao abrir o carrinho (`ConferenciaController.onReady`) | `ConferirGridController._itemUnids` da janela | Busca de novo, ainda o **conferir inteiro** |

Na conferência a carga termina **antes** do foco no scan.

## Bip

Não usar `AppHelper.isBarCode` (tamanho > 6) para decidir se é conversão. `Codigo` pode ser curto (`43174`).

Ordem:

1. `findUnidadeByCodigo(scan)` — prefere linha `UnidadeMedidaPadrao != 'S'` (`ConversaoUnidadeMedida.Codigo`)
2. Item da grade pelo `CodProduto` dessa linha (`findBarCode`)
3. Se não achar, `findCodProduto` (código do produto)

```dart
final item = grid.findBarCode(scanText) ??
    (codProdutoScan == null ? null : grid.findCodProduto(codProdutoScan));

final unidade = grid.findUnidadeByCodigo(scanValue);
if (unidade != null && unidade.codProduto == item.codProduto) {
  qtd = unidade.tipoFatorConversao != 'M'
      ? digitada / unidade.fatorConversao
      : digitada * unidade.fatorConversao;
}
```

Aplicar o fator **antes** de validar quantidade restante. Tipo `M` multiplica; qualquer outro divide.

Código: `SeparacaoController._addItemSeparacao`, `ConferenciaController._addItemConferencia`, `findUnidadeByCodigo` em `SepararGridController` / `ConferirGridController`.
