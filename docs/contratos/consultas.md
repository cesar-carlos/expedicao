# Consultas Socket.IO

Pedido: `${socket.id} <evento>`. Envelope: [consulta Socket.IO](./consulta-socket.md). Sem `LIMIT`, a página é 1500 — [paginação](./paginacao.md).

`consulta` usa a view (joins) e devolve o DTO `*ConsultaModel`. `select` lê a tabela e devolve o DTO de gravação. Os dois aceitam `Where`, `Pagination` e `OrderBy`.

Repositórios em `lib/src/repository/`. Listen em `*_event_repository.dart` — canal **sem** `socket.id`.

## Expedição — separar

| Evento | Repositório | Nota |
| --- | --- | --- |
| `separar.consulta` | `SepararConsultaRepository` | `CodSetorEstoque =` vira `EXISTS` no servidor. Não filtrar `CodSetoresEstoque` com `LIKE` |
| `separar.select` | `SepararRepository` | Tabela `SepararEstoque` |
| `separar.item.consulta` | `SepararItemConsultaRepository` | Lista paginada com `allRows()`. Unidades vêm em `separar.item.unidade.medida.consulta` |
| `separar.item.unidade.medida.consulta` | `SepararItemUnidadeConsultaRepository` | `allRows(thenBy: ItemUnidadeMedida)`. Sem página o servidor devolve tudo de uma vez |
| `separar.item.select` | `SepararItemRepository` | Tabela `ItemSepararEstoque` |
| `separacao.item.consulta` | `SeparacaoItemConsultaRepository` | O que já foi para o carrinho |
| `separacao.item.resumo.consulta` | `SeparacaoItemResumoConsultaRepository` | Quantidade agregada por produto |
| `separacao.item.select` | `SeparacaoItemRepository` | Tabela `ItemSeparacaoEstoque` |

Eventos do servidor que este coletor **não** emite hoje: `separar.progresso.consulta`, `separar.estoque.item.impresso.consulta`, `separar.usuario.setor.consulta` / `select`.

Escuta periódica **sem pedido**: `separar.consulta.listen`. Página padrão 20.

### Mutação e listen — separar

| Pedido | Listen que este app escuta |
| --- | --- |
| `separar.insert` / `update` / `delete` | `separar.insert.listen`, `separar.update.listen`, `separar.delete.listen` |
| `separar.item.*` | `separar.item.insert.listen`, `separar.item.delete.listen` |
| `separacao.item.insert` / `update` / `delete` | `separacao.item.*.listen` **e** `separar.item.consulta.update.listen` |

O update da tela de picking escuta `separar.item.consulta.update.listen` (emitido ao gravar item no carrinho), não `separar.item.update.listen`.

`carrinho.percurso.estagio` insert/update também emite `separar.update.listen`.

## Expedição — conferir

| Evento | Repositório | Nota |
| --- | --- | --- |
| `conferir.consulta` | `ConferirConsultaRepository` | Documento a conferir |
| `carrinho.conferir.consulta` | `ConferirCarrinhoConsultaRepository` | O coletor só aceita leitura se o código existir aqui |
| `conferir.select` | `ConferirRepository` | Tabela `Conferir`. **Não** criar documento por aqui — a trigger gera |
| `conferir.item.consulta` | `ConferirItemConsultaRepository` | Mandar `CodCarrinho` no `WHERE`. `ItemConferir` **não** tem essa coluna |
| `conferir.item.unidade.medida.consulta` | `ConferirItemUnidadeConsultaRepository` | `allRows(thenBy: ItemUnidadeMedida)` |
| `conferir.separacao.item.consulta` | `ConferirItemConsultaSeparacaoRepository` | Item da separação visto na conferência |
| `conferir.item.select` | `ConferirItemRepository` | Sem `CodCarrinho` |
| `conferencia.item.consulta` | `ConferenciaItemConsultaRepository` | Scans. Mandar `CodCarrinho` no `WHERE` |
| `conferencia.item.select` | `ConferenciaItemRepository` | Tabela `ItemConferencia` |

Abrir estágio `CO` / `CONFERINDO` é `carrinho.percurso.estagio.insert`, não `conferir.insert`. Sem `ItemConferir` no carrinho a base deve recusar com `[50014]`. [Erros](./erros.md).

Lista vazia em `conferir.item.consulta` **não** significa conferência completa.

### Mutação e listen — conferir

| Pedido | Listen |
| --- | --- |
| `conferir.insert` / `update` / `delete` | `conferir.*.listen` |
| `conferir.item.*` | `conferir.item.*.listen` |
| `conferencia.item.insert` / `update` / `delete` | `conferencia.item.*.listen` **e** `conferir.item.update.listen` |

Scan emite `conferir.item.update.listen` para a quantidade conferida atualizar na tela.

## Carrinho e percurso

| Evento | Repositório | Nota |
| --- | --- | --- |
| `carrinho.consulta` | `CarrinhoConsultaRepository` | |
| `carrinho.select` | `CarrinhoRepository` | |
| `carrinho.percurso.select` | `CarrinhoPercursoRepository` | Cabeçalho (`SE` + `CodSepararEstoque`) |
| `carrinho.percurso.estagio.consulta` | `CarrinhoPercursoEstagioConsultaRepository` | |
| `carrinho.percurso.estagio.select` | `CarrinhoPercursoEstagioRepository` | Insert `CO`/`CONFERINDO` ao ler o carrinho |
| `carrinho.percurso.agrupamento.consulta` | `CarrinhoPercursoAgrupamentoConsultaRepository` | |
| `carrinho.percurso.agrupamento.select` | `CarrinhoPercursoAgrupamentoRepository` | |
| `expedicao.percurso.estagio.select` | `ExpedicaoEstagioRepository` | Só `select`. O servidor **não** emite `*.listen` nesta feature |

`carrinho.percurso.consulta` no servidor reusa o SQL de estágio. Este coletor pede `carrinho.percurso.estagio.consulta`.

Listen: `carrinho.*.listen`, `carrinho.percurso.estagio.*.listen`, `carrinho.percurso.agrupamento.*.listen`. Estágio update também emite `carrinho.percurso.update.listen`.

## Produto, usuário, setor, armazenagem

| Evento | Repositório | Nota |
| --- | --- | --- |
| `estoque.produto.consulta` | `ProdutoConsultaRepository` | Scan: `CodigoBarras1` / `CodigoBarras2` |
| `usuario.consulta` / `usuario.select` | `UsuarioConsultaRepository` / `UsuarioRepository` | HTTP paralelo: [consulta HTTP](./consulta-http.md) |
| `armazenar.select` | `ArmazenarRepository` | Só `select` no servidor |
| `armazenar.item.select` | `ArmazenarItemRepository` | Também tem `armazenar.item.consulta` no servidor |
| `tipo.operacao.expedicao.select` | `TipoOperacaoRepository` | Só `select` |
| `tipo.operacao.armazenagem.select` | `TipoOperacaoArmazenagemRepository` | Só `select` |
| `processo.executavel.select` | `ProcessoExecutavelRepository` | Só `select` |
| `expedicao.cancelamento.select` | `CancelamentoRepository` | Só `select` |
| `setor.estoque.select` | *(não usado neste app)* | Só `select` no servidor |
| `sequencia.select` | *(não usado neste app)* | Nome **não** é `sequencia.registro.select` |

### Conversão de unidade — nome do evento

O servidor registra:

```text
produto.conversao.unidade.consulta
```

Canal de pedido: `${socket.id} produto.conversao.unidade.consulta`.

O fallback de resposta (se faltar `ResponseIn`) ainda é o nome antigo `estoque.produto.conversao.unidade.consulta`.

Este coletor hoje emite `estoque.produto.conversao.unidade.consulta` (`EstoqueProdutoConversaoUnidadeConsultaRepository`). Esse não é o sufixo registrado. Preferir o nome do servidor: `produto.conversao.unidade.consulta`. Filtro de scan: coluna `Codigo`.

## `WHERE` obrigatório na janela do carrinho

```dart
QueryBuilder()
    .equals('CodEmpresa', codEmpresa)
    .equals('CodConferir', codConferir)
    .equals('CodCarrinho', codCarrinho);
```

Usar em `conferir.item.consulta` e `conferencia.item.consulta`. Sem `CodCarrinho`, a página de 1500 pode cortar o carrinho aberto. [Where](./where.md).

## O que não é consulta de lista

- Mutação (`insert` / `update` / `delete`) — mesmo envelope de sessão, campo `Mutation`
- Broadcast `*.listen` depois de gravar — o cliente só escuta
- `separar.consulta.listen` — poll do processo, não usa o envelope de pedido
- Rotas HTTP `/usuarios` e login — [consulta HTTP](./consulta-http.md)
