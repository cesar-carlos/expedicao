# Chave de `Item`

A tabela guarda `Item` e `ItemCarrinhoPercurso` com **5 dígitos** (`FORMAT(..., '00000')` no insert). A grade mostra `1`. São a mesma linha.

```dart
AppHelper.gridItemKey('00001')     // '1'   — só comparar na grade
AppHelper.sameGridItem('1', '00001') // true
AppHelper.itemSequenceKey('1')     // '00001' — select / delete / update / toJson
AppHelper.itemSequenceKey('')      // '00000' — sentinela de insert (MAX+1)
```

| Uso | Helper | Se errar |
| --- | --- | --- |
| `addGrid` / `updateGrid` / `removeGrid` / `alreadyInGrid` | `sameGridItem` | Linha duplicada **ou** `updateGrid` não acha a linha |
| `QueryBuilder.equals('Item', …)` / `'ItemCarrinhoPercurso'` | `itemSequenceKey` | `select` vazio; mutação não grava |
| `toJson` / `fromConsulta` do DTO da **tabela** | `itemSequenceKey` | `DELETE … Item = '1'` não apaga `'00001'` |
| `fromJson` da **consulta** (view da grade) | `gridItemKey` | Grade compara `6` com `00006` e duplica |

Não usar `==` em `Item` vindo de consulta vs tabela. Não “consertar” com `allEvent: true` no listen: a mutação local é que tem de achar a linha.

## Onde o SQL gera a sequência

O MAX + 1 atual não é garantia de exclusividade entre coletores e pode reutilizar o maior Item excluído. Ver [proposta de contador monotônico, limites e migração](./item-totais-concorrencia.md). Não gerar ou corrigir a sequência no cliente.

`CASE WHEN @Item = '00000' OR @Item = '' THEN FORMAT(MAX(CAST(Item AS INT))+1, '00000')`.

Tabelas: `ItemSeparacaoEstoque`, `ItemConferencia`, `ItemSepararEstoque`, `ItemConferir`, `CarrinhoPercursoEstagio`, agrupamento.

`DELETE` / `UPDATE` comparam `Item = @Item` **sem** `CAST`. `'1'` ≠ `'00001'`.

## Fluxos deste coletor

### Excluir item (separação e conferência)

Revisão detalhada: [exclusão/cancelamento individual](./excluir-cancelar-item.md). Identificar a linha pela chave não resolve versão, vínculo de estágio ou saldo por unidade; o cancelamento CA é distinto do botão excluir.

`SeparacaoRemoverItemService.remove` / `ConferenciaRemoverItemService.remove` fazem `select` na tabela com `itemSequenceKey` e **só então** `delete`. `select` vazio lança erro — **não** chamar `removeGrid` antes.

O listen `*.item.delete.listen` é `allEvent: false`: a própria sessão já tirou a linha na resposta.

### Separar tudo / conferir tudo

A normalização de Item garante correspondência das linhas, não o saldo de negócio. A [revisão dos lotes](./separar-conferir-tudo.md) registra defeitos no abatimento de produtos repetidos, unidades e atualização da grade de demanda.

A tela **não** espera o listen (`allEvent: false` no insert). Depois do `insertAll`, a consulta da view tem de voltar as linhas novas.

Casar insert da tabela com consulta da view:

```dart
separacaoItensResponse.any(
  (inserted) => AppHelper.sameGridItem(inserted.item, item.item),
);
```

`'00001' == '1'` devolve lista vazia: a grade não muda; reabrir o app mostra os itens. Reconferir tudo funciona porque zera a grade em memória, sem essa consulta.

Serviços: `SeparacaoAdicionarItemService.addAll`, `ConferenciaAdicionarItemService.addAll`. Controllers: `SeparacaoController.onSepararTudo`, `ConferenciaController.onConferirTudo`.

### Cancelar carrinho

`cancelarAllItensCart()` é `Future` — **await**. Sem await a faixa muda e os itens ficam no banco.

`ItemCarrinhoPercurso` no `WHERE` do estágio também usa `itemSequenceKey`. Agrupar: `CarrinhoPercursoEstagio.Item` e `CarrinhoPercursoAgrupamento.Item` (`ItemAgrupamento` na view) idem; insert do agrupamento manda `'00000'`. [Agrupar](./agrupar-carrinho.md).

## Código

| Papel | Dart |
| --- | --- |
| Helpers | `lib/src/app/app_helper.dart` |
| Teste | `test/src/app/app_helper_grid_item_test.dart` |
| DTO tabela separação | `ExpedicaoSeparacaoItemModel` `fromJson` / `toJson` / `fromConsulta` |
| DTO tabela conferência | `ExpedicaoConferenciaItemModel`, `ExpedicaoConferirItemModel` |
| Consulta da grade | `ExpedicaSeparacaoItemConsultaModel.fromJson`, `ExpedicaConferenciaItemConsultaModel.fromJson` (`gridItemKey` em `Item`) |

Listen e `allEvent`: [listen da situação](./listen-situacao.md). `WHERE`: [where](./where.md). Setor: [setor de estoque](./setor-estoque.md).

## Teste manual

1. Bipar um item, excluir, fechar e abrir o carrinho: a linha **não** volta.
2. Separar tudo: Qtd. Separada e a grade do carrinho mudam **sem** fechar o app. O mesmo em Conferir tudo.
3. Reconferir tudo: a grade zera na hora.
4. Cancelar um carrinho com itens: reabrir não traz os itens no estágio cancelado.
