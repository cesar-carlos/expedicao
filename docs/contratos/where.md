# Where

O servidor (`normalizeConsultaWhere`) aceita só lista `{ key, value, operator? }`. String SQL não vazia responde `[INVALID_PAYLOAD] Where deve ser uma lista de parametros.` Fonte: `D:\Developer\Node\data7-api-pix Campo\docs\contratos\where.md`.

Este coletor ainda manda **string SQL** (`QueryBuilder.buildSqlWhere()`). Isso precisa migrar para lista de objetos.

```dart
QueryBuilder()
    .equals('CodEmpresa', 1)
    .equals('CodConferir', 290)
    .equals('CodCarrinho', 94)
    .buildSqlWhere();
// CodEmpresa = 1 AND CodConferir = 290 AND CodCarrinho = 94
```

O servidor aceita essa string como veio (`ParamsCommonRepository.build`). Não é parametrizada. Identificadores inválidos são recusados.

Lista de objetos `{ key, operator, value }` também é válida no servidor (caminho parametrizado). Este app não monta esse formato hoje.

## Operadores no `QueryBuilder`

| Método | Operador | SQL gerado |
| --- | --- | --- |
| `equals` | `=` | `CodEmpresa = 1` |
| `notEquals` | `!=` | `Situacao != 'CANCELADA'` |
| `greaterThan` / `lessThan` | `>` / `<` | |
| `like` | `LIKE` | `Nome LIKE '%Joao%'` |
| `inList` | `IN` | `Situacao IN ('EM SEPARACAO','SEPARANDO')` |
| `addParam(key, value, operator:)` | livre | |

`inList` formata string com aspas: `IN ('A','B')`. Número fica sem aspas.

`OrderBy`:

```dart
queryBuilder.orderByAsc('Item').orderByDesc('CodProduto');
// order_by=Item,CodProduto&order_direction=ASC,DESC
```

Só identificadores de coluna e `ASC`/`DESC`. Sem `OrderBy` válido, a página usa `ORDER BY (SELECT NULL)`.

Extensão `QueryBuilderExtension.search` gera `LIKE '%termo%'`. Não usar isso em `CodSetoresEstoque` nem em `DataEmissao`.

## Filtros que este coletor manda com frequência

| Evento | Filtro | Índice no servidor |
| --- | --- | --- |
| `separar.consulta` | `CodEmpresa`, `Situacao IN`, `CodSetorEstoque =` | PK + `IX_SepararEstoque_Situacao` + `IX_ItemSepararEstoque_Setor` |
| `separar.usuario.setor.consulta` | `CodEmpresa + CodUsuario + CodSetorEstoque` | `IX_SeparacaoUsuarioSetor_Usuario` |
| `conferir.item.consulta` | `CodEmpresa + CodConferir + CodCarrinho` | `IX_ItemConferir_Percurso` (join no estágio) |
| `conferencia.item.consulta` | `CodEmpresa + CodConferir + CodCarrinho` | `IX_ItemConferencia_Percurso` |
| `carrinho.conferir.consulta` | `CodEmpresa + CodConferir` (+ `CodCarrinho`) | PK do carrinho + `IX_CarrinhoPercursoEstagio_CarrinhoAtual` |
| `estoque.produto.consulta` | `CodigoBarras1` / `CodigoBarras2` | `IX_Produto_CodigoBarras1/2` |
| `produto.conversao.unidade.consulta` | `Codigo` | `IX_ConversaoUnidadeMedida_Codigo` |

## Regras de filtro

1. Em `separar.consulta`, filtrar setor com `CodSetorEstoque =`. Essa coluna **não** existe na view: o servidor vira `EXISTS` em `ItemSepararEstoque`. `LIKE` em `CodSetoresEstoque` (`STRING_AGG`) **não** entra nesse `EXISTS` e não usa índice.
2. `DataEmissao` na view é `SepararEstoque.Data` (`DATE`). Filtrar com `=` ou intervalo (`greaterThan` / `lessThan` / `BETWEEN` no servidor), não `LIKE 'yyyy-MM-dd%'`.
3. `ItemConferir` **não** tem `CodCarrinho`. Mandar no `WHERE` mesmo assim: a coluna vem do join `ItemCarrinhoPercurso = CarrinhoPercursoEstagio.Item` do estágio da **separação**, não do `CONFERINDO`.
4. `conferir.item.select` **não** devolve `CodCarrinho`. Para a janela do carrinho usar `conferir.item.consulta`.
5. Não filtrar estágio `CO` (`Item = '00010'`) e concluir que não há item a conferir. O vínculo do snapshot aponta para o estágio `SE`.

## HTTP

No HTTP o filtro não vai em `Where`. Query de negócio (`Nome`, `CodUsuario`, `Ativo`, …) o controller vira `Params`. [Consulta HTTP](./consulta-http.md).
