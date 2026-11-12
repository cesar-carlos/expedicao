# Consulta Socket.IO

Pedido legado (JSON string). Chaves aceitas pelo servidor: `Session`, `ResponseIn`, `Where`, `Mutation`, `Pagination`, `OrderBy`.

Consulta e `select` usam `Where` + `Pagination` + `OrderBy`. Mutação usa `Mutation`. Não misturar os dois papéis no mesmo handler.

## Pedido de consulta

Canal: `${socket.id} <evento>`. Exemplo: `abc123 conferir.item.consulta`.

O cliente envia por `AppSocketConfig.queryMapped` / `mutateMapped` (`request`). O JSON:

```json
{
  "Session": "<socket.id>",
  "ResponseIn": "<uuid>",
  "Where": "CodEmpresa = 1 AND CodConferir = 290 AND CodCarrinho = 94",
  "Pagination": "LIMIT=500&OFFSET=0&PAGE=1",
  "OrderBy": "order_by=Item&order_direction=ASC"
}
```

| Campo | Dart | Quando omitir |
| --- | --- | --- |
| `Session` | `socket.id` | Nunca. Sem handshake, `ensureStarted` ainda não terminou |
| `ResponseIn` | `Uuid().v4()` | Sem UUID o servidor responde no canal padrão do evento |
| `Where` | `queryBuilder.buildSqlWhere()` | Sem filtro o servidor lê a view inteira (depois corta a página) |
| `Pagination` | `queryBuilder.buildPagination()` | String vazia **não** entra no JSON. O servidor aplica 1500 |
| `OrderBy` | `queryBuilder.buildOrderByQuery()` | Sem ordem válida o SQL Server usa `ORDER BY (SELECT NULL)` |

`toJson()` só inclui `Where`, `Pagination` e `OrderBy` se a string não estiver vazia. Por isso `QueryBuilder()` sem `.paginate()` **não** manda página — o servidor assume 1500. Detalhe em [paginação](./paginacao.md).

Formatos de filtro: [Where](./where.md).

## Resposta de consulta

O servidor emite no canal `ResponseIn` (o UUID do pedido):

```json
{
  "Session": "...",
  "ResponseIn": "...",
  "Data": []
}
```

`queryMapped` lê `Data` (com fallback em `Mutation`) e mapeia o DTO (`fromJson`). Lista vazia é sucesso, não erro.

Erro: campo `Error` como `string[]` no formato `[identificador] mensagem`. Vira `AppError` via `fromResponse`. [Erros](./erros.md).

`ResponseIn` omitido cai no canal padrão do evento. Payload inválido responde nesse fallback; o servidor não falha em silêncio.

## Pedido de mutação

`mutateMapped` envia um registro ou uma lista em `Mutation`:

```json
{
  "Session": "<socket.id>",
  "ResponseIn": "<uuid>",
  "Mutation": { }
}
```

Resposta: `Session`, `ResponseIn`, `Mutation`. Em seguida o servidor emite `*.listen` para **todos** os sockets. O coletor escuta o nome do canal, **sem** prefixar `socket.id`.

`Mutation` vazia: vários handlers respondem `Mutation: []` sem gravar.

## Listen

Dois formatos de payload existem hoje; não unificar:

- `{ Session, ResponseIn, Mutation }` — mutação básica
- DTO de consulta — usado em separar / conferir / estágio quando o listen leva a linha da view

Listen cruzado (sai de **outro** handler):

| Canal | Quem emite | Quando |
| --- | --- | --- |
| `separar.update.listen` | `carrinho.percurso.estagio` insert/update | estágio muda a separação |
| `carrinho.percurso.update.listen` | `carrinho.percurso.estagio` update | estágio muda o percurso |
| `separar.item.consulta.update.listen` | `separacao.item` insert/update/delete | item no carrinho altera o item a separar |
| `conferir.item.update.listen` | `conferencia.item` insert/update/delete | scan altera o item a conferir |
| `separar.consulta.listen` | timer do processo | poll periódico. **Não** usa este envelope de pedido |

Payload de listen: `BasicEventModel.parse` aceita string ou Map, `Mutation`/`Data` como lista ou objeto, ou o DTO solto.

Este coletor escuta `separar.item.consulta.update.listen` (não `separar.item.update.listen`). Catálogo: [consultas](./consultas.md).

Escuta periódica `separar.consulta.listen`: intervalo padrão 8 s, limite 20 (não 1500). O cliente só escuta. Guia no servidor: `docs/escuta-separacao.md`.

## Conexão

`AppSocketConfig` usa `transports: ['websocket']`, `autoConnect: true`. Sem token. URL: `http://<host>:<porta>` do arquivo de configuração da API.

Antes de emitir, `ensureStarted` espera o handshake. Sem `socket.id` o canal de pedido fica inválido. `listen` reassocia os handlers depois de um reconnect (`reconnectFromConfig` após salvar a API). Pedido parado espera 30s; queda da conexão aborta na hora (`_failPending`). HTTP: `connectTimeout` 8s, `receiveTimeout` 20s (`AppClientHttp`).

Listen: `SocketEventRepository` decodifica o pacote uma vez e ignora evento da própria sessão, salvo `allEvent: true`.
