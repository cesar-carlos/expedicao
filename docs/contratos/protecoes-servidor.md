# Proteções do servidor — este coletor

Fonte oficial (agentes dos dois Flutter): `D:\Developer\Node\data7-api-pix Campo\docs\socket\protecoes-cliente.md`.

Índices no servidor: `docs/README.md`, `docs/socket/README.md`, `docs/socket/listen.md`, `docs/comunicacao.md`, regras 26–27 em `docs/expedicao/regras.md`, `AGENTS.md`.

Envelope, `Where` e página: [consulta Socket.IO](./consulta-socket.md), [Where](./where.md), [paginação](./paginacao.md). Listen de negócio: [listen da situação](./listen-situacao.md). Erros: [erros](./erros.md).

O servidor é SQL Server. Este arquivo diz o que **já está no ar**, o que **este desktop já escuta**, e o que **ainda não** existe — para não quebrar o contrato atual.

Estado em 2026-11-13. Este desktop já cumpre o canal de emergência. O `exp` ainda não.

## Como ler o estado

| Marca | Significado |
| --- | --- |
| **Já no servidor** | Código Node já aplica. Cliente publicado continua funcionando. |
| **Já neste desktop** | `ServidorEmergenciaService` registra o listener na conexão. |
| **Escutar agora** | Vale para o `exp`, não para este app. |
| **Ainda não** | Não quebra hoje. O código se prepara. Quando ligar, o app antigo pode falhar se não estiver pronto. |

Nada abaixo recusa o payload que os coletores já mandam (`LIKE` de setor/data em **build antigo**, string SQL no `Where`, `LIMIT` explícito, handshake sem token). O `exp` atual já manda `CodSetorEstoque =` e intervalo de `DataEmissao`. Regra 26.

---

## Já no servidor

O servidor protege a base **sem** mudar JSON de pedido/resposta das consultas atuais. Regra 26.

| Proteção | O que o servidor faz | O que este app vê |
| --- | --- | --- |
| Reescrita de `LIKE` em `separar.consulta` | `CodSetoresEstoque LIKE '%3%'` e `DataEmissao LIKE 'yyyy-MM-dd%'` viram `EXISTS` / igualdade ou intervalo | A mesma lista. Este desktop **não** manda esses `LIKE` (não filtra `separar.consulta` por setor/data) |
| Dedup de `*.consulta` | Dois pedidos iguais no mesmo socket compartilham um SQL | Os dois `ResponseIn` recebem o mesmo `Data` |
| `SET LOCK_TIMEOUT` nas listas | Padrão 5 s (`SQL_LOCK_TIMEOUT_MS`) só no `SELECT` | `[SQL-1222]` (“registro em uso”) se o ERP estiver gravando. `AppError.isRetryableLock` |
| Cancel no timeout do Node | Estoura 30 s → cancela a request SQL | Continua `[SQL-CONN]`. `AppError.isConnectionFailure`. Pedido no socket também espera 30 s |
| Página antes do `STRING_AGG` | `OFFSET/FETCH` na base; agregação de setor/usuário depois | Lista não varre `ItemSepararEstoque` inteira. [Paginação](./paginacao.md) |
| Teto padrão 1500 | Sem `LIMIT` do cliente, a página é 1500 | `allRows()` pagina de 500. `LIMIT` explícito **continua respeitado** |

### Higiene neste desktop (não é breaking)

1. Preferir `CodSetorEstoque =` em vez de `LIKE` em `CodSetoresEstoque`. Recusa de setor é no app (`setorPermitido`), não no `WHERE`. Este desktop **não** filtra a lista por setor. [Setor](./setor-estoque.md).
2. Preferir igualdade ou intervalo de `DataEmissao`, não `LIKE 'yyyy-MM-dd%'`.
3. `Where` vai como lista `{ key, operator, value }` (`QueryBuilder.buildWhereList()`). O `exp` já usa `buildWhereParams()`. String SQL legado o servidor ainda aceita (warn no log).
4. **Não** escuta `separar.consulta.listen` e **não** dispara outra `separar.consulta` no tick do listen. A tela usa `Data`/`Mutation` de `separar.update.listen` e dos listens de item.
5. `[SQL-1222]`: “tente de novo”, não payload inválido. `AppError.display`.
6. `[SQL-CONN]`: timeout/falha de conexão. Não relançar a mesma consulta em loop imediato.
7. Warn `Consulta Where em SQL cru (legado QueryBuilder)` não é erro da consulta: o servidor executa e responde `Data`. A fonte atual já usa lista; builds antigos podem continuar gerando o warn, exibido como erro pelo supervisor Windows por ser stderr.

O timeout local de 30 s do desktop pode vencer antes da resposta `[SQL-CONN]` do servidor e produzir mensagem sem prefixo. Não confundir os dois diagnósticos. Dedup de consulta não protege mutações contra repetição; [resultado incerto](./consulta-socket.md#repetição-e-resultado-incerto).

---

## Já neste desktop — `servidor.emergencia.listen`

Regra 27. O coletor **não emite** este evento. Só escuta o nome literal, sem `socket.id`, desde a conexão (`ServidorEmergenciaService` no `main`, não no dispose da tela de separar/conferir).

Família `ExpedicaoBasicListenEvent`. **Não tem `Session`**. `allEvent: true` — sem isso, `Session` vazio igual a `socket.id` vazio (antes do handshake) engole o aviso.

Uso: aviso direto do servidor (manutenção, cliente travando a base, desconexão iminente).

### Estado neste coletor

| Parte | Estado |
| --- | --- |
| Nome do canal e payload `{ Data }` | **Já no servidor** |
| HTTP interno para o operador emitir o aviso | **Já no servidor** (`POST /internal/sockets/emergencia`, só loopback) |
| Listener neste desktop (`app_expedicao`) | **Já no coletor** — `ServidorEmergenciaService`, `allEvent: true`, na conexão |
| Listener no `exp` | **Escutar agora** — ainda não existe (espelhar este serviço) |
| Desconectar sozinho quem está travando a base | **Ainda não** — quando existir, o servidor emite este canal **antes** e só então corta o socket |

### Payload

O corpo no fio é JSON **string** (`BasicEventModel.parse` aceita também objeto já decodificado). Ler `Data[0]`:

```json
{
  "Data": [
    {
      "Nivel": "aviso",
      "Codigo": "SERVIDOR_AVISO",
      "Mensagem": "Servidor em manutencao em 10 minutos.",
      "Acao": "nenhuma",
      "PrazoMs": 0,
      "EmitidoEm": "2026-11-13T12:00:00.000Z"
    }
  ]
}
```

| Campo | Valores | O que este app faz |
| --- | --- | --- |
| `Nivel` | `aviso` · `urgente` · `desconectar` | Título do diálogo (`ServidorEmergenciaAvisoModel.titulo`) |
| `Codigo` | `SERVIDOR_AVISO` · `SERVIDOR_MANUTENCAO` · `SERVIDOR_DESCONECTAR` (outros podem aparecer) | Log `[SOCKET-LISTEN]`. Não parsear `Mensagem` |
| `Mensagem` | texto | `MessageDialogView` / `SessaoEncerradaDialogWidget`. Sem prefixo `Erro ao X:` |
| `Acao` | `nenhuma` · `desconectar` | `nenhuma`: só aviso. `desconectar`: para tráfego e espera o corte |
| `PrazoMs` | 0–60000 | Texto “será encerrada em N segundos” se > 0. 0 = em seguida |
| `EmitidoEm` | ISO-8601 | Auditoria; ignorado na UI |

### Comportamento obrigatório (este desktop)

1. Listener na conexão (`Get.put(ServidorEmergenciaService(), permanent: true)`).
2. Canal `servidor.emergencia.listen` — nome literal, sem prefixar `socket.id`.
3. Parse string ou Map. `Data[0]` via `BasicEventModel` (`Mutation` ou `Data`).
4. Mostrar `Mensagem`.
5. Se `Acao == "desconectar"`:
   - `AppSocketConfig.pauseForServerDisconnect()` — para `*.consulta` e mutação, desliga auto-reconnect;
   - não há timer de resync neste app (não escuta `separar.consulta.listen`);
   - diálogo com `PrazoMs` quando > 0;
   - **não** reconectar em loop no disconnect (o rodapé não abre “Conectando ao servidor…”);
   - depois do corte: “Servidor encerrou a sessão” + **Reconectar** (F12) → `reconnectAfterServerEnd`.
6. Sem o listener o servidor ainda pode desconectar; o usuário só veria o socket cair.

`POST /internal/sockets/emergencia` é operador/loopback. Este coletor **não** chama essa rota.

---

## Ainda não (preparem)

Estas mudanças **não** estão ligadas. Quando forem, o servidor avisa em `protecoes-cliente.md` e, se for corte, em `servidor.emergencia.listen`.

| Proteção | Risco se o app não estiver pronto | Como este desktop se prepara |
| --- | --- | --- |
| Recusar `LIKE` não indexado com `[INVALID_PAYLOAD]` | Lista de **build antigo** do `exp` quebra | Este desktop não manda `LIKE` em setor/data. `[INVALID_PAYLOAD]` **ainda não** cobre isso |
| Recusar string SQL no `Where` | `buildSqlWhere()` deixa de funcionar | Já manda lista `{ key, value }` |
| Cortar `LIMIT` explícito num teto (hoje o servidor respeita) | Página menor que a esperada | `allRows()` pagina de 500; não depende de `LIMIT` enorme |
| Token no handshake Socket.IO | Conexão recusada | `handshakeAuth` existe e **permanece nulo**. Hoje **não** mandar |
| Rate limit de `*.consulta` por socket | Pedidos extras atrasam ou recebem erro | Não martelar consulta; confiar no listen e no dedup |
| Transação SQL opt-in (`transacao: true` ou evento de lote) | Ainda sem contrato implementado; mutações atuais são autocommit | Não enviar o campo esperando rollback. Ver [revisão de concorrência](./concorrencia-idempotencia.md) |
| Desconectar automaticamente quem segura lock / satura o pool | Socket cai | Já escuta `servidor.emergencia.listen` e trata `Acao=desconectar` |
| `READ_COMMITTED_SNAPSHOT` na `Estacao` | Nenhum no JSON | Só DBA |

Handshake **continua sem token**. `LIMIT` explícito **continua respeitado**. String SQL no `Where` **continua aceita** (com aviso no log).

---

## Erros que o cliente já recebe

Formato: `[identificador] mensagem`. [Erros](./erros.md). Servidor: `docs/expedicao/erros.md`.

| Prefixo | Relação com proteção |
| --- | --- |
| `[SQL-1222]` | Lista esperou lock além de `SQL_LOCK_TIMEOUT_MS` |
| `[SQL-CONN]` | Timeout 30 s / falha de conexão; a request SQL foi cancelada |
| `[INVALID_PAYLOAD]` | Envelope inválido (`CodCarrinho` ausente em item a conferir, etc.). **Ainda não** cobre `LIKE` de setor |
| `[50014]` … | Trigger / regra de conferência. Não é proteção de lista |

Não embrulhar com `Exception('Erro ao X: $e')` nem dump `AppError{...}`. Desktop: `AppError.display`.

---

## Checklist (espelho do servidor)

Estado em 2026-11-13.

| Item | Este desktop | `exp` |
| --- | --- | --- |
| Listener global de `servidor.emergencia.listen` com `allEvent: true` | Feito | **Escutar agora** |
| UI para `Mensagem` | Feito | **Escutar agora** |
| Caminho de `Acao=desconectar` (parar consultas, não reconectar em loop) | Feito | **Escutar agora** |
| `Where` de setor/data em igualdade (não mandar `LIKE`) | N/A na lista (não filtra setor com `LIKE`) | Feito |
| Não refazer `separar.consulta` no tick do listen periódico | Feito (não escuta esse canal) | Feito |
| Não inventar handshake com token **ainda** | Feito (`handshakeAuth` nulo) | Feito |

## Código

| Papel | Dart |
| --- | --- |
| Bind do canal | `lib/src/repository/servidor_emergencia/servidor_emergencia_event_repository.dart` |
| Listener global `allEvent: true` | `lib/src/app/servidor_emergencia_service.dart` (`main.dart`) |
| Payload | `lib/src/model/servidor_emergencia_aviso_model.dart` |
| Para tráfego + reconectar | `AppSocketConfig.pauseForServerDisconnect` / `reconnectAfterServerEnd` |
| Tela após o corte | `lib/src/pages/common/widget/sessao_encerrada_dialog_widget.dart` |
| `Where` lista | `QueryBuilder.buildWhereList` |
| `[SQL-1222]` / `[SQL-CONN]` | `AppError.isRetryableLock` / `isConnectionFailure` |
