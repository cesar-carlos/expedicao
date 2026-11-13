# Setor de estoque e conferência

O usuário só opera itens do **próprio setor**. Item de outro setor entra só se o **usuário não tem setor** ou o **item não tem setor**.

A recusa é a mesma nos dois fluxos. O que muda é o campo do **usuário**.

```dart
AppHelper.setorPermitido(setorUsuario, setorItem)
```

Setor válido é **maior que zero**. `null` e `0` (default SQL) são “não definido”.

`true` se qualquer lado for indefinido, ou se os códigos definidos forem iguais. Recusa só com os **dois** `> 0` e diferentes.

Não usar `item != usuario` sozinho: `null != 5` e `0 != 5` recusam item sem setor.

| Fluxo | `setorUsuario` | `setorItem` |
| --- | --- | --- |
| Separação | `ProcessoExecutavelModel.codSetorEstoque` | `codSetorEstoque` do item |
| Conferência | `ProcessoExecutavelModel.codSetorConferencia` | `codSetorEstoque` do item |

O produto na view continua com `CodSetorEstoque`. Conferência **não** compara `codSetorEstoque` do usuário.

## Origem

| Quem | Campo JSON | Quem preenche | Indefinido (`null` ou `0`) |
| --- | --- | --- | --- |
| Usuário (separação) | `CodSetorEstoque` | `processo.executavel.select` → `ProcessoExecutavelService.executar` | Sem recorte |
| Usuário (conferência) | `CodSetorConferencia` | O mesmo processo | Sem recorte |
| Item a separar | `CodSetorEstoque` | `separar.item.consulta` | Livre para qualquer usuário |
| Item a conferir | `CodSetorEstoque` | `conferir.item.consulta` | Livre para qualquer usuário |
| Item já conferido no carrinho | — | `conferencia.item.consulta` **não** traz setor | Na exclusão, buscar o produto na lista a conferir |

O splash grava `ProcessoExecutavelModel` permanente. `UsuarioConsultaMoldel` tem os dois setores e **não** entra na recusa. `tipo.operacao.expedicao.select` tem `CodSetorConferencia` e também **não** entra.

Eventos do servidor que este coletor **não** emite: `separar.usuario.setor.consulta` / `select`, `setor.estoque.select`.

## Quando pode operar

| Usuário | Item | Resultado |
| --- | --- | --- |
| `null` | qualquer | Pode |
| `0` | qualquer | Pode. Zero não é setor |
| qualquer | `null` | Pode |
| qualquer | `0` | Pode. Zero não é setor |
| `5` | `5` | Pode |
| `5` | `7` | **Não** |

`AppHelper.setorDefinido(setor)` é `setor != null && setor > 0`. O JSON costuma vir `0` em vez de `null`.

## Onde o coletor aplica

| Ação | Dart | Dialog se recusar |
| --- | --- | --- |
| Bipar na separação | `SeparacaoController._addItemSeparacao` | *Produto fora do setor estoque!* / *Este produto não esta no seu setor de setor estoque!* |
| Excluir na separação | `SeparacaoController._onRemoveItemSeparacaoGrid` | *Não é possivel remover!* / *O produto não esta no seu setor estoque!* |
| Ícone da grade a separar | `SepararGridController.iconIndicator` | Ícone `ban` vermelho (não impede sozinho) |
| Bipar na conferência | `ConferenciaController._addItemConferencia` | *Produto fora do setor conferência!* / *Este produto não esta no seu setor de conferência!* — **TESTE: comentada** |
| Excluir na conferência | `ConferenciaController._onRemoveItemConferenciaGrid` | *Não é possivel remover!* / *O produto não esta no seu setor conferência!* — **TESTE: comentada** |
| Ícone da grade a conferir | `ConferirGridController.iconIndicator` | Ícone `ban` vermelho (não impede sozinho) — **TESTE: comentada** |

A lista da tela mostra **todos** os itens. O recorte é na hora de bipar / excluir.

## O que não aplica

- **Separar tudo** (`SeparacaoAdicionarItemService.addAll`) e **Conferir tudo** (`ConferenciaAdicionarItemService.addAll`) **não** chamam `setorPermitido`. Com usuário setorizado, o lote ainda insere item de outro setor.
- `SepararGridController.getItensSort` / `itensSortSetor` usa `setorPermitido`. **Ninguém chama.** A tela mostra todos os itens.
- `separar.consulta`, `separar.item.consulta` e `conferir.item.consulta` **não** mandam o setor do usuário no `WHERE`. A grade vem completa.

Se o servidor filtrar `separar.consulta` por setor: `CodSetorEstoque =` vira `EXISTS` em `ItemSepararEstoque`. `LIKE` em `CodSetoresEstoque` (`STRING_AGG`) **não** entra nesse `EXISTS`. O servidor **ainda não** recusa esse `LIKE` — reescreve (regra 26). [Where](./where.md). [Proteções](./protecoes-servidor.md).

## Código

| Papel | Dart |
| --- | --- |
| Helper | `AppHelper.setorDefinido`, `AppHelper.setorPermitido` |
| Teste | `test/src/app/app_helper_grid_item_test.dart` |
| Processo | `ProcessoExecutavelModel.codSetorEstoque` / `codSetorConferencia` |
| Item a separar | `ExpedicaoSepararItemConsultaModel.codSetorEstoque` |
| Item no carrinho (separação) | `ExpedicaSeparacaoItemConsultaModel.codSetorEstoque` |
| Item a conferir | `ExpedicaoConferirItemConsultaModel.codSetorEstoque` |
| Scan / excluir | `separacao_controller.dart`, `conferencia_controller.dart` |
| Ícone | `SepararGridController`, `ConferirGridController` |

Páginas: [Separação](../separacao/separacao_estoque_documentation.md). Conferência: [conferência](../conferencia/README.md). Listen: [listen da situação](./listen-situacao.md). `Item`: [chave de Item](./item-chave.md).

## Teste manual

1. Separação, usuário **com** `CodSetorEstoque`, item **do mesmo** setor: bipar, separar, excluir.
2. Separação, item **de outro** setor: bipar recusa. Excluir recusa. Ícone `ban`.
3. Separação, usuário **sem** setor (`null` ou `0`): bipar qualquer setor.
4. Conferência, usuário **com** `CodSetorConferencia` igual ao `CodSetorEstoque` do item (ambos `> 0`): bipar, conferir, excluir.
5. Conferência, códigos diferentes e `> 0`: bipar recusa. Excluir recusa. Ícone `ban`.
6. Conferência, usuário **sem** setor (`null` ou `0`): bipar qualquer setor.
7. Item **sem** setor (`null` ou `0`), usuário setorizado (os dois fluxos): bipar e operar.
8. Separar tudo / conferir tudo: hoje **não** recusa item de outro setor.
