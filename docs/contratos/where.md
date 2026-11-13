# Where

O servidor prefere lista `{ key, value, operator? }`. String SQL legado ainda é aceita (warn `Consulta Where em SQL cru`) — regra 26, **ainda não** recusa. Fonte: `D:\Developer\Node\data7-api-pix Campo\docs\contratos\where.md`. Shim de `LIKE` em `separar.consulta`: `docs/socket/protecoes-cliente.md`.

Este coletor manda **lista** (`QueryBuilder.buildWhereList()`).

```dart
QueryBuilder()
    .equals('CodEmpresa', 1)
    .equals('CodConferir', 290)
    .equals('CodCarrinho', 94)
    .buildWhereList();
// [{ key: CodEmpresa, operator: =, value: 1 }, …]
```

`buildSqlWhere()` permanece para teste e para o fragmento legado. O fio usa a lista (caminho parametrizado no servidor). Identificadores inválidos são recusados.

`inList` manda `value` como lista JSON (`[10, 20]`), não string interpolada.

## Operadores no `QueryBuilder`

| Método | Operador | SQL gerado |
| --- | --- | --- |
| `equals` | `=` | `CodEmpresa = 1` |
| `notEquals` | `!=` | `Situacao != 'CANCELADA'` |
| `greaterThan` / `lessThan` | `>` / `<` | |
| `like` | `LIKE` | `Nome LIKE '%Joao%'` |
| `inList` | `IN` | `CodCarrinho IN (10,20)` |
| `addParam(key, value, operator:)` | livre | |

`inList` manda `value` como lista JSON. No fragmento SQL de teste: `IN (10,20)` ou `IN ('A','B')`.

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
| `separar.consulta` | `CodEmpresa`, `Situacao IN` | PK + `IX_SepararEstoque_Situacao`. Este app **não** manda `CodSetorEstoque =` |
| `separar.usuario.setor.consulta` | `CodEmpresa + CodUsuario + CodSetorEstoque` | Índice no servidor. Este coletor **não** emite o evento |
| `conferir.item.consulta` | `CodEmpresa + CodConferir + CodCarrinho` | `IX_ItemConferir_Percurso` (join no estágio) |
| `conferencia.item.consulta` | `CodEmpresa + CodConferir + CodCarrinho` | `IX_ItemConferencia_Percurso` |
| `carrinho.consulta` | `CodEmpresa` + `CodigoBarras` (scan) ou `CodCarrinho` | PK do carrinho |
| `carrinho.select` | `CodEmpresa` + `CodCarrinho` | PK. Situação do cadastro |
| `carrinho.conferir.consulta` | `CodEmpresa + CodConferir` (+ `CodCarrinho`) | PK do carrinho + `IX_CarrinhoPercursoEstagio_CarrinhoAtual` |
| `carrinho.percurso.estagio.consulta` | `CodEmpresa` + `Origem` + `CodOrigem` (+ `CodCarrinhoPercurso` / `Item`) | `IX_CarrinhoPercursoEstagio_CarrinhoAtual` |
| `carrinho.percurso.estagio.select` | `CodEmpresa` + `CodCarrinho`, ou chave `CodCarrinhoPercurso` + `Item` | PK do estágio |
| `carrinho.percurso.agrupamento.consulta` | `CodEmpresa` + `Origem` + `CodOrigem` + `CodigoBarrasCarrinho` (**equals**, não `LIKE`) | Scan do destino no assistente. [Agrupar](./agrupar-carrinho.md) |
| `estoque.produto.consulta` | `CodigoBarras1` / `CodigoBarras2` | `IX_Produto_CodigoBarras1/2` |
| `separar.item.unidade.medida.consulta` | `CodEmpresa` + `CodSepararEstoque` | Documento inteiro. Sem `CodCarrinho`. [Conversão](./conversao-unidade.md) |
| `conferir.item.unidade.medida.consulta` | `CodEmpresa` + `CodConferir` | Documento inteiro. Sem `CodCarrinho` |
| `produto.conversao.unidade.consulta` | `Codigo` | `IX_ConversaoUnidadeMedida_Codigo`. Lookup avulso; **não** é o bip do carrinho |

## Regras de filtro

1. Recusa de setor do usuário logado é no app (`AppHelper.setorPermitido`), não no `WHERE` da lista. [Setor](./setor-estoque.md). Se um dia filtrar `separar.consulta` por setor: `CodSetorEstoque =` (o servidor vira `EXISTS` em `ItemSepararEstoque`). `LIKE` em `CodSetoresEstoque` (`STRING_AGG`) **não** entra nesse `EXISTS` e não usa índice. O servidor **ainda não** recusa esse `LIKE` — reescreve (regra 26).
2. `DataEmissao` na view é `SepararEstoque.Data` (`DATE`). Filtrar com `=` ou intervalo (`greaterThan` / `lessThan` / `BETWEEN` no servidor), não `LIKE 'yyyy-MM-dd%'`.
3. `ItemConferir` **não** tem `CodCarrinho`. Mandar no `WHERE` mesmo assim: a coluna vem do join `ItemCarrinhoPercurso = CarrinhoPercursoEstagio.Item` do estágio da **separação**, não do `CONFERINDO`.
4. `conferir.item.select` **não** devolve `CodCarrinho`. Para a janela do carrinho usar `conferir.item.consulta`.
5. Não filtrar estágio `CO` (`Item = '00010'`) e concluir que não há item a conferir. O vínculo do snapshot aponta para o estágio `SE`.
6. `Item` / `ItemCarrinhoPercurso` na tabela são `'00001'`. `equals('Item', '1')` não acha a linha. Usar `AppHelper.itemSequenceKey`. [Chave de Item](./item-chave.md).
7. Não mandar o setor do usuário em `conferir.item.consulta`. A view traz `CodSetorEstoque` do produto; a conferência compara com `CodSetorConferencia` do processo.
8. Unidade de medida do item **não** filtra `CodCarrinho`. A coluna do bip é `ConversaoUnidadeMedida.Codigo` (JSON `CodigoBarras`). [Conversão](./conversao-unidade.md).

## HTTP

No HTTP o filtro não vai em `Where`. Query de negócio (`Nome`, `CodUsuario`, `Ativo`, …) o controller vira `Params`. [Consulta HTTP](./consulta-http.md).
