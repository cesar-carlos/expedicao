# Consultas Socket.IO

Pedido: `${socket.id} <evento>`. Envelope: [consulta Socket.IO](./consulta-socket.md). Sem `LIMIT`, a página é 1500 — [paginação](./paginacao.md).

`consulta` usa a view (joins) e devolve o DTO `*ConsultaModel`. `select` lê a tabela e devolve o DTO de gravação. Os dois aceitam `Where`, `Pagination` e `OrderBy`.

Repositórios em `lib/src/repository/`. Listen em `*_event_repository.dart` — canal **sem** `socket.id`.

## Expedição — separar

| Evento | Repositório | Nota |
| --- | --- | --- |
| `separar.consulta` | `SepararConsultaRepository` | Este app **não** filtra pelo setor do usuário. Se filtrar: `CodSetorEstoque =` vira `EXISTS`. Não usar `LIKE` em `CodSetoresEstoque`. [Setor](./setor-estoque.md) |
| `separar.select` | `SepararRepository` | Tabela `SepararEstoque` |
| `separar.item.consulta` | `SepararItemConsultaRepository` | Lista paginada com `allRows()`. Unidades vêm em `separar.item.unidade.medida.consulta` |
| `separar.item.unidade.medida.consulta` | `SepararItemUnidadeConsultaRepository` | Documento inteiro (`CodEmpresa` + `CodSepararEstoque`), `allRows(thenBy: ItemUnidadeMedida)`, memória. [Conversão](./conversao-unidade.md) |
| `separar.item.select` | `SepararItemRepository` | Tabela `ItemSepararEstoque` |
| `separacao.item.consulta` | `SeparacaoItemConsultaRepository` | O que já foi para o carrinho |
| `separacao.item.resumo.consulta` | `SeparacaoItemResumoConsultaRepository` | Quantidade agregada por produto |
| `separacao.item.select` | `SeparacaoItemRepository` | Tabela `ItemSeparacaoEstoque` |

Eventos do servidor que este coletor **não** emite hoje: `separar.progresso.consulta`, `separar.estoque.item.impresso.consulta`, `separar.usuario.setor.consulta` / `select`. Recusa de setor do usuário logado é no app, não nessa consulta. [Setor](./setor-estoque.md).

Escuta periódica **sem pedido**: `separar.consulta.listen`. Página padrão 20. Este desktop **não** escuta esse canal e **não** refaz `separar.consulta` no mesmo tick. Emergência: [proteções](./protecoes-servidor.md).

### Mutação e listen — separar

| Pedido | Listen que este app escuta |
| --- | --- |
| `separar.insert` / `update` / `delete` | `separar.insert.listen`, `separar.update.listen`, `separar.delete.listen` |
| `separar.item.*` | `separar.item.insert.listen`, `separar.item.delete.listen` |
| `separacao.item.insert` / `update` / `delete` | `separacao.item.*.listen` **e** `separar.item.consulta.update.listen` |

O update da tela de picking escuta `separar.item.consulta.update.listen` (emitido ao gravar item no carrinho), não `separar.item.update.listen`.

`carrinho.percurso.estagio` insert/update também emite `separar.update.listen`. Insert do próprio carrinho **não** vai para a grade pelo listen (`allEvent: false`). Detalhe: [listen da situação](./listen-situacao.md). `Item` da tabela vs da grade: [chave de Item](./item-chave.md). Setor: [setor de estoque](./setor-estoque.md).

## Expedição — conferir

| Evento | Repositório | Nota |
| --- | --- | --- |
| `conferir.consulta` | `ConferirConsultaRepository` | Documento a conferir |
| `carrinho.conferir.consulta` | `ConferirCarrinhoConsultaRepository` | O coletor só aceita leitura se o código existir aqui |
| `conferir.select` | `ConferirRepository` | Tabela `Conferir`. **Não** criar documento por aqui — a trigger gera |
| `conferir.item.consulta` | `ConferirItemConsultaRepository` | Mandar `CodCarrinho` no `WHERE` (`ItemConferir` **não** tem essa coluna). Traz `CodSetorEstoque` do produto. Recusa de setor é no app. [Setor](./setor-estoque.md) |
| `conferir.item.unidade.medida.consulta` | `ConferirItemUnidadeConsultaRepository` | Documento inteiro (`CodEmpresa` + `CodConferir`), **sem** `CodCarrinho`. `allRows(thenBy: ItemUnidadeMedida)`. [Conversão](./conversao-unidade.md) |
| `conferir.separacao.item.consulta` | `ConferirItemConsultaSeparacaoRepository` | Item da separação visto na conferência |
| `conferir.item.select` | `ConferirItemRepository` | Sem `CodCarrinho` |
| `conferencia.item.consulta` | `ConferenciaItemConsultaRepository` | Scans. Mandar `CodCarrinho` no `WHERE`. **Não** traz setor — na exclusão buscar o item em `conferir.item.consulta` |
| `conferencia.item.select` | `ConferenciaItemRepository` | Tabela `ItemConferencia` |

Abrir estágio `CO` / `CONFERINDO` é `carrinho.percurso.estagio.insert`, não `conferir.insert`. Sem `ItemConferir` no carrinho a base deve recusar com `[50014]`. [Erros](./erros.md).

Lista vazia em `conferir.item.consulta` **não** significa conferência completa.

### Mutação e listen — conferir

| Pedido | Listen |
| --- | --- |
| `conferir.insert` / `update` / `delete` | `conferir.*.listen` |
| `conferir.item.*` | `conferir.item.*.listen` |
| `conferencia.item.insert` / `update` / `delete` | `conferencia.item.*.listen` **e** `conferir.item.update.listen` |

Scan emite `conferir.item.update.listen` para a quantidade conferida atualizar na tela. Esse update e o insert de `conferencia.item` usam `allEvent: false` — o bip / conferir tudo já atualizou a grade.

`conferir.update.listen` é o canal da **situação do documento** (`allEvent: true`). Insert de carrinho na grade: `allEvent: false`. Detalhe: [listen da situação](./listen-situacao.md). `Item`: [chave de Item](./item-chave.md).

## Carrinho e percurso

| Evento | Repositório | Nota |
| --- | --- | --- |
| `carrinho.consulta` | `CarrinhoConsultaRepository` | View do cadastro + percurso atual. Scan do diálogo |
| `carrinho.select` | `CarrinhoRepository` | Tabela. Situação do cadastro (`LIBERADO`, `EM SEPARACAO`…) |
| `carrinho.percurso.select` | `CarrinhoPercursoRepository` | Cabeçalho (`SE` + `CodSepararEstoque`) |
| `carrinho.percurso.estagio.consulta` | `CarrinhoPercursoEstagioConsultaRepository` | Grade de carrinhos do documento (view) |
| `carrinho.percurso.estagio.select` | `CarrinhoPercursoEstagioRepository` | Linha de gravação. Cancelar, editar, recuperar |
| `carrinho.percurso.agrupamento.consulta` | `CarrinhoPercursoAgrupamentoConsultaRepository` | Scan e grade do agrupar |
| `carrinho.percurso.agrupamento.select` | `CarrinhoPercursoAgrupamentoRepository` | Tabela do agrupamento |
| `expedicao.percurso.estagio.select` | `ExpedicaoEstagioRepository` | Só `select`. O servidor **não** emite `*.listen` nesta feature |

`carrinho.percurso.consulta` no servidor reusa o SQL de estágio. Este coletor pede `carrinho.percurso.estagio.consulta`.

Listen: `carrinho.*.listen`, `carrinho.percurso.estagio.*.listen`, `carrinho.percurso.agrupamento.*.listen`. Estágio update também emite `carrinho.percurso.update.listen`.

Abrir estágio `CO` / `CONFERINDO` é `carrinho.percurso.estagio.insert` (`CarrinhoPercursoEstagioAdicionarService`), não o `select` nem `conferir.insert`.

### Scan do carrinho — o que consulta

O diálogo (`CarrinhoController.getCarrinho`) emite `carrinho.consulta` com `CodEmpresa` + `CodigoBarras`. A view já traz o ponto atual:

- `Situacao` — cadastro (`LIBERADO`, `EM SEPARACAO`, `CONFERIDO`…)
- `Origem` / `CodOrigem` — documento em que o carrinho está
- `DescricaoPercursoEstagio` — estágio (vem no JSON; o diálogo **não** mostra)
- `NomeSetorEstoque`

A tela mostra Situação, Local (`Origem`) e Setor. O scan **não** navega até esse documento. É um portão da tela aberta: *este carrinho pode entrar aqui?*

| Origem da tela | Depois do `carrinho.consulta` |
| --- | --- |
| Separação | Só aceita `Situacao = LIBERADO`. Ocupado em outro ponto → recusa |
| Conferência | Segunda consulta `carrinho.conferir.consulta` (`ConferenciaSituacaoCarrinhoService`): o código precisa existir **neste** conferir. Recusa `LIBERADO` / `CONFERIDO` / `CONFERINDO` / `AGRUPADO` em `SituacaoCarrinhoConferencia` |
| Agrupar | Outro scan (`faindCart`): `carrinho.percurso.agrupamento.consulta` com `equals` em `CodigoBarrasCarrinho`, já filtrado pelo documento. Destino tem de estar `CONFERIDO`. [Agrupar](./agrupar-carrinho.md) |

Não há um `getSituacao(codCarrinho)` genérico fora desses fluxos. Cadastro: `CarrinhoService.consulta` / `select`. Conferência do documento: `ConferenciaSituacaoCarrinhoService`.

### `carrinho.percurso.estagio` — quem consulta o quê

**View** (`*.consulta`) — lista da grade e recarga depois de gravar. Sempre `allRows()`.

| Chamada | `WHERE` | Uso |
| --- | --- | --- |
| `SepararConsultaServices.carrinhosPercurso` | `CodEmpresa` + `Origem = SE` + `CodOrigem` (+ `CodCarrinhoPercurso` / `Item`) | Grade, `existsOpenCart()`, validar ao finalizar, recarregar o estágio adicionado |
| `ConferirConsultaServices.carrinhosPercurso` | Igual, com `Origem = CO` e `CodOrigem` do conferir | Grade de conferidos, `existsOpenCart()`, recarregar depois de adicionar |

`CarrinhoPercursoServices.consultaPercurso` reusa o mesmo evento (`OrderBy` `CodCarrinhoPercurso, Item`) e **não é chamado**.

**Tabela** (`*.select`) — linha de gravação. `CarrinhoPercursoEstagioServices.select` aplica `withAllRows()`.

| Chamada | `WHERE` | Uso |
| --- | --- | --- |
| Recuperar carrinho (separar) | `CodEmpresa` + `CodCarrinho` | Último estágio: `CANCELADA` + `Origem = SE` + deste documento. [Recuperar](./recuperar-carrinho.md) |
| Recuperar itens (separação) | `CodEmpresa` + `CodCarrinho` | Penúltimo estágio cancelado, `SE`, deste documento |
| Cancelar / editar / carregar (separado e conferido) | `CodEmpresa` + `CodCarrinhoPercurso` + `CodCarrinho` + `Item` (+ estágio no cancelar) | Confirmar usuário e gravar |
| Armazenar `_liberarCarrinhos` | `CodEmpresa` + `CodCarrinhoPercurso` + `Situacao = SEPARADO` | Quais carrinhos liberar |

## Produto, usuário, setor, armazenagem

| Evento | Repositório | Nota |
| --- | --- | --- |
| `estoque.produto.consulta` | `ProdutoConsultaRepository` | Scan: `CodigoBarras1` / `CodigoBarras2` |
| `usuario.consulta` / `usuario.select` | `UsuarioConsultaRepository` / `UsuarioRepository` | HTTP paralelo: [consulta HTTP](./consulta-http.md) |
| `armazenar.select` | `ArmazenarRepository` | Só `select` no servidor |
| `armazenar.item.select` | `ArmazenarItemRepository` | Também tem `armazenar.item.consulta` no servidor |
| `tipo.operacao.expedicao.select` | `TipoOperacaoRepository` | Só `select` |
| `tipo.operacao.armazenagem.select` | `TipoOperacaoArmazenagemRepository` | Só `select` |
| `processo.executavel.select` | `ProcessoExecutavelRepository` | Só `select`. Traz `CodSetorEstoque` e `CodSetorConferencia` do usuário |
| `expedicao.cancelamento.select` | `CancelamentoRepository` | Só `select` |
| `setor.estoque.select` | *(não usado neste app)* | Cadastro de setor. A recusa usa o processo + `CodSetorEstoque` do item. [Setor](./setor-estoque.md) |
| `sequencia.select` | *(não usado neste app)* | Nome **não** é `sequencia.registro.select` |

### Conversão de unidade

Contrato: [conversão de unidade](./conversao-unidade.md).

No carrinho o coletor emite `separar.item.unidade.medida.consulta` / `conferir.item.unidade.medida.consulta`. O bip casa `ConversaoUnidadeMedida.Codigo` (JSON `CodigoBarras`) **antes** de `CodProduto`.

`produto.conversao.unidade.consulta` (`EstoqueProdutoConversaoUnidadeConsultaRepository`) é lookup avulso de estoque (`Where` na coluna `Codigo`). Canal `${socket.id} produto.conversao.unidade.consulta`. Sem `ResponseIn`, o fallback ainda é o nome antigo `estoque.produto.conversao.unidade.consulta`. **Não** entra no bip do carrinho.

## `WHERE` obrigatório na janela do carrinho

```dart
QueryBuilder()
    .equals('CodEmpresa', codEmpresa)
    .equals('CodConferir', codConferir)
    .equals('CodCarrinho', codCarrinho);
```

Usar em `conferir.item.consulta` e `conferencia.item.consulta`. Sem `CodCarrinho`, o servidor responde `[INVALID_PAYLOAD] <evento> exige CodCarrinho no Where.` A consulta depois do `insert` (bipar item / Conferir tudo) também precisa do campo — filtrar só por `Item` não basta.

`isComplete()` da conferência usa `conferir.item.select` (sem `CodCarrinho`), não a consulta da janela.

## O que não é consulta de lista

- Mutação (`insert` / `update` / `delete`) — mesmo envelope de sessão, campo `Mutation`
- Broadcast `*.listen` depois de gravar — o cliente só escuta
- `separar.consulta.listen` — poll do processo, não usa o envelope de pedido
- Rotas HTTP `/usuarios` e login — [consulta HTTP](./consulta-http.md)
