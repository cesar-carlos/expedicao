# Contratos de paginação e consulta

O coletor não fala SQL direto com o banco. Toda lista passa pelo servidor: Socket.IO para expedição, HTTP só para login/usuários/versão.

Esta pasta descreve o contrato **deste app**: o que montamos em Dart, o canal do pedido, a página que o servidor aplica e como o erro chega na tela.

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs\contratos`. Dois Flutter consomem o mesmo servidor. Mudança de nome de evento ou de envelope quebra os dois.

## Leia nesta ordem

1. [Consulta Socket.IO](./consulta-socket.md) — envelope, canal `${socket.id} <evento>`, `Data` / `Error`
2. [Paginação](./paginacao.md) — sem `LIMIT` o servidor corta em 1500
3. [Where](./where.md) — `QueryBuilder.buildSqlWhere()` e operadores
4. [Consultas](./consultas.md) — eventos `*.consulta` / `*.select` / `*.listen` usados aqui
5. [Erros](./erros.md) — `AppError.fromSocket` / `display`
6. [Consulta HTTP](./consulta-http.md) — `Page`, `Offset`, `Limit`

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
| Snackbar | `LoadingProcessDialogGenericWidget` usa `AppError.display` |

## Três papéis

| Papel | Sufixo | Canal de pedido | Resposta |
| --- | --- | --- | --- |
| Consulta | `*.consulta` ou `*.select` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Data` |
| Mutação | `*.insert` / `*.update` / `*.delete` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Mutation` + broadcast `*.listen` |
| Escuta | `*.listen` | o coletor **não** emite; só escuta o nome do canal | payload da família daquele canal |

`consulta` lê a view (joins, nomes, totais). `select` lê a tabela física. Os dois usam o mesmo envelope.

A conexão **não** exige token. HTTP e Socket.IO aceitam qualquer origem.
