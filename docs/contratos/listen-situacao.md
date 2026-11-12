# Listen da situação e da grade

O servidor **não** tem canal `*.situacao.listen`. A situação viaja no payload (`Situacao` em `Mutation` / `Data`).

O servidor emite `*.listen` para **todos** os sockets, inclusive quem gravou. O coletor, por padrão, **ignora a própria sessão**.

```dart
// SocketEventRepository.dispatch
if (basicEvent.session == sessionId && !listener.allEvent) continue;
```

`allEvent` default é `false`.

## Regra

A mutação **já atualizou a tela** na resposta? Então o listen da própria sessão **não** entra (`allEvent: false`).

A tela **não** aplicou o campo (faixa de situação)? Então o próprio update entra (`allEvent: true`).

| Já fez na resposta da mutação | `allEvent` | Se ligar `true` |
| --- | --- | --- |
| `addGrid` / `removeGrid` | `false` | Linha duplicada. Fecha e abre a tela e a quantidade volta a bater. |
| Soma `quantidadeSeparacao` / `quantidadeConferida` | `false` | Quantidade dobrada (listen chega antes; a soma local usa o total já atualizado). |
| Só `updateGrid` de situação (faixa / linha do carrinho) | `true` | Sem isso a faixa fica `SEPARANDO` até reabrir. |

Insert/delete/update de **outro** coletor no mesmo documento continuam chegando com `allEvent: false`.

Não “consertar” duplicata só com `alreadyInGrid` no listen de insert e deixar `allEvent: true`: o listen pode chegar **antes** do `addCart` local.

`Item` `6` vs `00006`: [chave de Item](./item-chave.md). Grade: `sameGridItem`. Mutação/`WHERE`: `itemSequenceKey`.

No `for` da mutation: `continue`, nunca `return`.

Dialog “finalizado/cancelado por outro usuário”: só se `!AppSocketListenLog.isOwnSession`.

## Inventário neste coletor

### Separação

| Canal | Controller | Evento | `allEvent` | O que faz |
| --- | --- | --- | --- | --- |
| `separar.update.listen` | `SepararController`, `SeparacaoController` | update | `true` | `aplicarSituacao` (faixa) |
| `separar.item.consulta.update.listen` | `SepararController` | update | `false` | `updateGrid` quantidade a separar. O bip / separar tudo já somou. |
| `carrinho.percurso.estagio.insert.listen` | `SeparadoCarrinhosController` | insert | `false` | `addGrid` na lista de carrinhos. `addCart` local já fez. |
| `carrinho.percurso.estagio.update.listen` | `SeparadoCarrinhosController`, `SeparacaoController` | update | `true` | Situação do carrinho (`SEPARANDO`/`SEPARADO`) |
| `carrinho.percurso.estagio.delete.listen` | `SeparadoCarrinhosController` | delete | `false` | `removeGrid`. Cancelar local já fez. |
| `separacao.item.insert.listen` | `SeparacaoController` | insert | `false` | `addGrid` no carrinho. O bip / separar tudo já fez. Ignora `SessionId` da linha. |
| `separacao.item.delete.listen` | `SeparacaoController` | delete | `false` | `removeGrid`. Remover local já fez. |
| `separacao.item.update.listen` | — | update | bound, **sem listener** | Edição de item na separação não está implementada. |

Não escutar `separar.item.update.listen`. O picking usa `separar.item.consulta.update.listen`.

### Conferência

| Canal | Controller | Evento | `allEvent` | O que faz |
| --- | --- | --- | --- | --- |
| `conferir.update.listen` | `ConferirController`, `ConferirCarrinhosController`, `ConferenciaController` | update | `true` | `aplicarSituacao`. A faixa é `ConferirCarrinhosController`. |
| `conferir.item.update.listen` | `ConferenciaController` | update | `false` | Quantidade a conferir. O bip / conferir tudo já somou. |
| `carrinho.percurso.estagio.insert.listen` | `ConferidoCarrinhosController`, `ConferirCarrinhosController` | insert | `false` | `addGrid`. Adicionar carrinho local já fez. Update de estágio **não** dá `addGrid` na própria sessão. |
| `carrinho.percurso.estagio.update.listen` | `ConferidoCarrinhosController`, `ConferirCarrinhosController`, `ConferenciaController` | update | `true` | Situação do carrinho. Sem `addGrid` se a linha já existe; própria sessão não insere linha nova. |
| `carrinho.percurso.estagio.delete.listen` | `ConferidoCarrinhosController` | delete | `false` | `removeGrid` |
| `conferencia.item.insert.listen` | `ConferenciaController` | insert | `false` | `addGrid`. O bip / conferir tudo já fez. Ignora `SessionId` da linha. |
| `conferencia.item.update.listen` | `ConferenciaController` | update | `false` | `updateGrid` (não `addGrid`) |
| `conferencia.item.delete.listen` | `ConferenciaController` | delete | `false` | `removeGrid` |

### Bound no repositório, **sem** listener de tela

Estes binds existem (`*_event_repository.dart`) e o servidor emite. Nenhuma tela deste coletor registra callback hoje.

| Repositório | Canais |
| --- | --- |
| `CarrinhoPercursoAgrupamentoEventRepository` | `carrinho.percurso.agrupamento.*.listen` — agrupar atualiza a grade do modal só na resposta da mutação. [Agrupar](./agrupar-carrinho.md) |
| `CarrinhoEventRepository` | `carrinho.*.listen` |
| `ArmazenarEventRepository` / `ArmazenarItemEventRepository` | `armazenar.*.listen` |
| `CancelamentoEventRepository` | `expedicao.cancelamento.*.listen` |
| `UsuarioEventRepository` | `usuario.*.listen` |
| `SepararEventRepository` insert/delete | `separar.insert.listen`, `separar.delete.listen` (só o **update** tem listener) |
| `ConferirEventRepository` insert/delete | idem |
| `SepararItemEventRepository` insert/delete | só o **consulta.update** tem listener |

Se ligar listener nestes canais: insert/delete `allEvent: false`; situação `allEvent: true`; nunca `addGrid` na própria sessão.

## Erros que já aconteceram

| Sintoma | Causa | Contrato |
| --- | --- | --- |
| Dois carrinhos iguais | insert de estágio `allEvent: true` + `addCart` | esta página |
| Item bipado duas vezes | `separacao.item.insert` próprio **ou** `separar.item.consulta.update` `allEvent: true` somando de novo | esta página |
| Faixa não muda | `separar.update` / `conferir.update` `allEvent: false`, ou `fromJson` da tabela na view | esta página |
| Excluir item some e volta ao reabrir | `Item = '1'` no `select`; tabela `'00001'`; `removeGrid` local | [chave de Item](./item-chave.md) |
| Separar tudo / conferir tudo não atualiza | `inserted.item == consulta.item`; listen próprio ignorado | [chave de Item](./item-chave.md) |

Payload da situação: só `CodEmpresa`, `CodSepararEstoque` / `CodConferir`, `Situacao`. Não usar `ExpedicaoSepararModel.fromJson` no listen.

## Código

| Papel | Dart |
| --- | --- |
| Bind + filtro de sessão | `lib/src/repository/socket_event_repository.dart` |
| Log `[SOCKET-LISTEN]` | `lib/src/app/app_socket_listen_log.dart` (`isOwnSession`) |
| Situação da separação | `SepararController.aplicarSituacao` |
| Situação da conferência | `ConferirController.aplicarSituacao` → cabeçalho em `ConferirCarrinhosController` |
| Grade sem duplicar | `addGrid` recusa chave repetida (`sameGridItem` / `codCarrinhoPercurso` + `item`) |

Depois de salvar/reabrir carrinho a tela consulta o documento (`separar.consulta` / `conferir.consulta`).

Cruzado no servidor: insert/update de estágio também emite `separar.update.listen`. `conferir.update.listen` sai de `conferir.update` e de `PUT /expedicao/conferir/notify`. Envelope: [consulta Socket.IO](./consulta-socket.md). Catálogo: [consultas](./consultas.md). Overlay: [modais](./modais.md). `Item`: [chave de Item](./item-chave.md). Setor: [setor de estoque](./setor-estoque.md).

## Log no console

Filtro: `SOCKET-LISTEN`. Canais: situação, estágio, `separacao.item`, `conferencia.item`, `separar.item.consulta.update`, `conferir.item.update`.

| Linha | Significado |
| --- | --- |
| `RECEBIDO canal=…` | O pacote chegou neste socket |
| `PARSE … propriaSessao=true` | Decodificado |
| `APLICADO origem=…` | A UI aplicou (situação) |
| `IGNORADO propria sessao` | Esperado em insert/delete/quantidade. **Bug** em update de situação |
| `MUTATION_VAZIA` / `ERRO` | Canal chegou; JSON não deu para aplicar |

## Teste manual

1. Adicionar carrinho: **uma** linha. Insert próprio: `IGNORADO`.
2. Bipar um item: **uma** linha e quantidade somada **uma** vez. Insert e `*.item.consulta.update` / `conferir.item.update` próprios: `IGNORADO`.
3. Outro coletor no mesmo documento: carrinho e item aparecem lá.
4. Salvar o último carrinho: a faixa muda sem fechar. `APLICADO origem=SepararController` (ou `ConferirCarrinhosController`).
5. Separar tudo / conferir tudo: grade e totais mudam **sem** fechar. Listen próprio continua `IGNORADO`.
6. Excluir item, fechar e abrir o carrinho: a linha não volta.
7. Fechar e abrir o documento: totais iguais aos da tela.
