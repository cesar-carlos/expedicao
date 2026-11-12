# Contratos de paginação e consulta

O coletor não fala SQL direto com o banco. Toda lista passa pelo servidor: Socket.IO para expedição, HTTP só para login/usuários/versão.

Esta pasta descreve o contrato **deste app**: o que montamos em Dart, o canal do pedido, a página que o servidor aplica e como o erro chega na tela.

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs\contratos`. Dois Flutter consomem o mesmo servidor. Mudança de nome de evento ou de envelope quebra os dois.

## Leia nesta ordem

1. [Consulta Socket.IO](./consulta-socket.md) — envelope, canal `${socket.id} <evento>`, `Data` / `Error`
2. [Paginação](./paginacao.md) — sem `LIMIT` o servidor corta em 1500
3. [Where](./where.md) — `QueryBuilder.buildSqlWhere()` e operadores
4. [Consultas](./consultas.md) — eventos `*.consulta` / `*.select` / `*.listen` usados aqui
5. [Conversão de unidade](./conversao-unidade.md) — `Codigo` no banco, `CodigoBarras` no JSON; carga do documento; bip
6. [Listen da situação](./listen-situacao.md) — inventário de todos os `*.listen`; insert/quantidade `allEvent: false`; faixa `allEvent: true`
7. [Chave de Item](./item-chave.md) — `itemSequenceKey` / `sameGridItem`; excluir e separar/conferir tudo
8. [Setor de estoque](./setor-estoque.md) — separação `CodSetorEstoque`; conferência `CodSetorConferencia`; `null`/`0` libera
9. [Recuperar carrinho](./recuperar-carrinho.md) — F11 tela inicial (último estágio cancelado) vs F11 no carrinho (penúltimo)
10. [Agrupar carrinho](./agrupar-carrinho.md) — F6 destino / F7 assistente; só conferência; não move item
11. [Modais](./modais.md) — `Navigator.pop` / `DialogCloseGuard`; `Get.back()` não fecha loading
12. [Erros](./erros.md) — `AppError.fromSocket` / `display`
13. [Consulta HTTP](./consulta-http.md) — `Page`, `Offset`, `Limit`

## Código neste app

| Contrato | Dart |
| --- | --- |
| Envelope de consulta | `lib/src/model/send_query_socket_model.dart` |
| Envelope de mutação | `lib/src/model/send_mutation_socket_model.dart`, `send_mutations_socket_model.dart` |
| `Where` / `OrderBy` / página | `lib/src/model/pagination/query_builder.dart` |
| `LIMIT` / `OFFSET` / `PAGE` | `lib/src/model/pagination/pagination.dart` |
| Junta páginas de 500 | `lib/src/model/pagination/paged_query.dart` (`QueryBuilder.allRows`) |
| Conexão | `lib/src/app/app_socket_config.dart` (`queryMapped` / `mutateMapped`) |
| HTTP | `lib/src/app/app_client_http.dart` |
| Erro | `lib/src/app/app_error.dart` |
| Pedido de lista | `lib/src/repository/**/*_repository.dart` — `queryMapped` / `mutateMapped` |
| Broadcast | `lib/src/repository/socket_event_repository.dart` — `*_event_repository.dart` escuta `<evento>.listen` |
| Situação + `allEvent` | `lib/src/app/app_socket_listen_log.dart`, `aplicarSituacao` em `SepararController` / `ConferirController` |
| `Item` `00001` vs `1` | `lib/src/app/app_helper.dart` (`itemSequenceKey`, `sameGridItem`) |
| Conversão `Codigo` | `AppHelper.conversaoCodigo` / `sameBarCode`; `_itemUnids` no grid |
| Setor estoque / conferência | `AppHelper.setorPermitido`; usuário `codSetorEstoque` ou `codSetorConferencia` |
| Recuperar carrinho / itens | `SeparacaoAdicionarItemService.addRecuperados`; F11 tela vs F11 no carrinho |
| Agrupar carrinho | `CarrinhoPercursoEstagioAgruparService`; F6 destino, F7 assistente |
| Fechar modal | `lib/src/app/app_dialog_close.dart` — não usar `Get.back()` no loading |
| Snackbar | `LoadingProcessDialogGenericWidget` usa `AppError.display` |

## Três papéis

| Papel | Sufixo | Canal de pedido | Resposta |
| --- | --- | --- | --- |
| Consulta | `*.consulta` ou `*.select` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Data` |
| Mutação | `*.insert` / `*.update` / `*.delete` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Mutation` + broadcast `*.listen` |
| Escuta | `*.listen` | o coletor **não** emite; só escuta o nome do canal | payload da família daquele canal |

`consulta` lê a view (joins, nomes, totais). `select` lê a tabela física. Os dois usam o mesmo envelope.

A conexão **não** exige token. HTTP e Socket.IO aceitam qualquer origem.
