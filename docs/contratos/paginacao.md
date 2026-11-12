# Paginação

As consultas de lista **não** devolvem a tabela inteira. O SQL em `src/sql/` do servidor não usa `TOP` para cortar a lista. O corte entra no helper:

```sql
ORDER BY ... OFFSET @__pg_offset ROWS FETCH NEXT @__pg_limit ROWS ONLY
```

Sem `OrderBy` do cliente, a ordenação fica `ORDER BY (SELECT NULL)`, porque o SQL Server recusa `OFFSET/FETCH` sem ordem. Os `TOP 1` que existem no SQL pegam um carrinho ou um percurso ligado ao registro. Eles não limitam a lista.

## Constantes do servidor

| Constante | Valor | Uso |
| --- | --- | --- |
| `DEFAULT_PAGE_LIMIT` | 1500 | Página quando o pedido **não** manda `LIMIT` |
| `MAX_PAGE_LIMIT` | 1500 | Teto só do padrão e do refresh interno |
| `SQL_INT_MAX` | 2147483647 | Teto técnico de um `LIMIT` explícito |

Regras:

- Sem `LIMIT` → 1500.
- `LIMIT` 0 → 1.
- `LIMIT` inválido → 1500.
- `LIMIT` explícito do cliente **não** é cortado em 1500.
- `OFFSET` ausente → 0.
- `PAGE` ausente → 1. O helper de consulta usa `OFFSET`/`LIMIT`; `PAGE` é metadado.

## O que este coletor manda

`Pagination.toQueryString()`:

```text
LIMIT=200&OFFSET=0&PAGE=1
```

`QueryBuilder.paginate(limit:, offset:, page:)` grava o objeto. `buildPagination()` devolve a query string. Se ninguém chamou `.paginate()`, a string é vazia e `queryMapped` **omite** o campo. O servidor então aplica 1500.

Padrão do `QueryBuilder.paginate` em Dart é `limit: 10`. Não confundir com o 1500 do servidor: 10 só vale se o serviço chamar `.paginate()` sem argumento.

`QueryBuilder.allRows()` não manda um LIMIT único enorme. O socket busca páginas de **500** (`Pagination.fetchPageSize`) até uma página vir curta, com `OrderBy` em `Item`. Cada pedido libera a fila; 500 cabe no JSON sem travar o isolate e ainda evita dezenas de idas ao servidor (200 seria mais ida; 1500 é o padrão pesado do servidor).

`Pagination.create` no Dart usa `limit: 50` — outro padrão local, só se o código chamar essa factory.

### Onde o coletor manda página explícita hoje

| Chamada | Limit | Motivo |
| --- | --- | --- |
| `itensSaparar` / `itensSeparacao` / `itensConferir` / `itensConferencia` | `allRows()` em páginas de 500 | Documento grande sem cortar em 1500 nem travar a fila |
| Unidade de medida (`itensSapararUnidades` / `itensConferirUnidades`) | `allRows(thenBy: ItemUnidadeMedida)` | Sem página o servidor devolve tudo num payload; com `allRows` busca 500 a 500 e junta |
| Listas de item do documento (`addAll`, cancelar/remover, armazenar, conferir da separação) | `allRows()` | Mesmo risco de corte em 1500 |
| Carrinhos do documento (`carrinhosPercurso`, `carrinhosConferir`, agrupar) | `allRows()` | Grid de carrinho e agrupar todos. Agrupamento ordena por `ItemCarrinhoPercurso` (não tem `Item`) |
| Wrappers (`CarrinhoService`, `CarrinhoPercursoServices`, `CarrinhoPercursoEstagioServices`, `consulta` do agrupar) | `withAllRows()` | Clona o builder para não vazar `OrderBy` quando o mesmo `QueryBuilder` vai para outra tabela |
| Lookup (processo, usuário, produto, cabeçalho) | uma página, ou omite | `allRows` no repositório puxa a tabela inteira e estoura o teto de 200 páginas |

### Unidade de medida

No servidor, `KEEP_EVERY_UNIT_ROW` tira o `OFFSET/FETCH` da unidade de medida do item **somente** quando o cliente **não** manda página. Sem página, um documento grande manda todas as conversões de uma vez e trava a fila.

Este coletor manda `Pagination` via `allRows()`, com `OrderBy` em `Item, ItemUnidadeMedida`. Aí o `KEEP_EVERY_UNIT_ROW` não vale, o `OFFSET/FETCH` corta em 500, e o socket junta as páginas até a lista acabar. O segundo campo evita pular linha quando o mesmo `Item` tem várias conversões.

Eventos:

- `separar.item.unidade.medida.consulta`
- `conferir.item.unidade.medida.consulta`

Não chamar `.paginate()` sozinho nesses eventos: uma página isolada corta conversões no meio do item.

## Janela do carrinho (regra 14)

A janela de conferência deve mandar `CodCarrinho` no `WHERE` de:

- `conferir.item.consulta`
- `conferencia.item.consulta`

Sem o filtro, a página de 1500 pode cortar o carrinho aberto. Filtrar só na memória perde item.

`ConferirConsultaServices.itensConferir` / `itensConferencia` já aceitam `codCarrinho`. Na tela do carrinho, passar o código. `ItemConferir` **não** tem essa coluna — ela vem do join com o estágio da **separação**.

## Refresh depois de gravar

Insert, update e delete no servidor **não** recarregam a lista inteira. O coletor deve atualizar pelo `*.listen` (quantidade do item, estágio) em vez de consultar de novo a view completa.

| Leitura no refresh do servidor | Linhas por chave |
| --- | --- |
| Separar e conferir | 2 |
| Carrinho, usuário e estágio do percurso | 5 |
| Itens da conferência | 5, ou 20 na leitura do item a conferir |
| Itens a separar | 20 na consulta; 5 na atualização de quantidade |
| Itens já separados | 5 |

## Escuta periódica

`separar.consulta.listen` **não** usa 1500. Padrão 20, `SEPARAR_LISTEN_LIMIT` entre 1 e 500. O coletor não pede essa página.

## HTTP

Query `Page`, `Offset`, `Limit` — as mesmas constantes. [Consulta HTTP](./consulta-http.md).
