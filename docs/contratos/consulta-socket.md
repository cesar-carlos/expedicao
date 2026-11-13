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
  "Where": [
    { "key": "CodEmpresa", "operator": "=", "value": 1 },
    { "key": "CodConferir", "operator": "=", "value": 290 },
    { "key": "CodCarrinho", "operator": "=", "value": 94 }
  ],
  "Pagination": "LIMIT=500&OFFSET=0&PAGE=1",
  "OrderBy": "order_by=Item&order_direction=ASC"
}
```

| Campo | Dart | Quando omitir |
| --- | --- | --- |
| `Session` | `socket.id` | Nunca. Sem handshake, `ensureStarted` ainda não terminou |
| `ResponseIn` | `Uuid().v4()` | Sem UUID o servidor responde no canal padrão do evento |
| `Where` | `queryBuilder.buildWhereList()` | Sem filtro o servidor lê a view inteira (depois corta a página) |
| `Pagination` | `queryBuilder.buildPagination()` | String vazia **não** entra no JSON. O servidor aplica 1500 |
| `OrderBy` | `queryBuilder.buildOrderByQuery()` | Sem ordem válida o SQL Server usa `ORDER BY (SELECT NULL)` |

`queryMapped` só inclui `Where` se a lista não estiver vazia, e `Pagination` / `OrderBy` se a string não estiver vazia. Por isso `QueryBuilder()` sem `.paginate()` **não** manda página — o servidor assume 1500. Detalhe em [paginação](./paginacao.md). Handshake **sem token**. [Proteções](./protecoes-servidor.md).

Formatos de filtro: [Where](./where.md).

O cliente copia o payload para JSON antes de esperar a conexão ou a recuperação. Alterações posteriores no objeto do chamador não alteram o pedido em andamento. `Session` e `ResponseIn` são sempre definidos pelo transporte; valores dessas chaves no payload não podem substituí-los. Parâmetros que não podem ser serializados são recusados antes do envio.

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

O conteúdo deve ser um objeto ou uma lista composta somente por objetos. Conteúdo ausente, escalar ou lista com entradas inválidas causa erro, em vez de virar uma grade vazia ou uma lista parcial. Em resposta de mutação, falha nesse mapeamento também exige conferir o estado gravado antes de nova ação.

Quando a resposta inclui `Session` ou `ResponseIn`, o valor precisa corresponder ao pedido. Divergências são recusadas; campos ausentes continuam aceitos por compatibilidade com envelopes legados. A correlação principal continua sendo o listener do UUID.

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

### Repetição e resultado incerto

O dedup do servidor cobre apenas `*.consulta` iguais no mesmo socket (evento, `Where`, página e ordem). Cada UUID recebe a resposta. **Não cobre mutações**; `ResponseIn` correlaciona a resposta, não é chave de idempotência.

As gravações são autocommit. Lote em `Mutation` não garante transação única; cancelar estágio e cancelar itens são commits distintos (regras 8 e 16 do servidor). Não enviar `transacao: true` como se já estivesse implementado.

Revisão do código do servidor: [concorrência e idempotência](./concorrencia-idempotencia.md). `Session`, `SessionId`, `ResponseIn` e `RequestId` não são chaves duráveis de execução única. O dedup de consultas não se aplica às mutações nem a dois coletores; mesmo uma resposta de erro pode ocorrer após commits, durante o refresh.

Consequência para integração: timeout ou desconexão após emitir uma mutação não comprova rollback. Antes de repetir uma gravação, consultar o estado persistido do carrinho/documento e reconciliar a tela. Não implementar retry automático de insert ou do lote inteiro apenas porque faltou resposta.

## Listen

Três famílias coexistem; não unificar. O desktop lê `Mutation` ou `Data` na mesma lista (`BasicEventModel.parse`).

| Família | JSON |
| --- | --- |
| `ExpedicaoMutationListenEvent` | `{ "Mutation": [ … ] }` |
| `ExpedicaoMutationBasicEvent` | `{ "Session", "ResponseIn", "Mutation": [ … ] }` |
| `ExpedicaoBasicListenEvent` | `{ "Data": [ … ] }` — timer, `POST /expedicao/separacao/notify` e `servidor.emergencia.listen` (sem `Session`) |

Emergência: o coletor **não** emite. Este desktop **já** escuta `servidor.emergencia.listen` na conexão com `allEvent: true`. O `exp` ainda deve registrar. [Proteções](./protecoes-servidor.md). Servidor: `docs/socket/listen.md`.

Listen cruzado (sai de **outro** handler):

| Canal | Quem emite | Quando |
| --- | --- | --- |
| `separar.update.listen` | `carrinho.percurso.estagio` insert/update | estágio muda a separação |
| `conferir.update.listen` | `conferir.update` e `PUT /expedicao/conferir/notify` | situação da conferência |
| `carrinho.percurso.update.listen` | `carrinho.percurso.estagio` update | estágio muda o percurso |
| `separar.item.consulta.update.listen` | `separacao.item` insert/update/delete | item no carrinho altera o item a separar |
| `conferir.item.update.listen` | `conferencia.item` insert/update/delete | scan altera o item a conferir |
| `separar.consulta.listen` | timer do processo | poll periódico. **Não** usa este envelope de pedido |

Situação e grade: [listen da situação](./listen-situacao.md). Insert/delete da própria sessão ficam de fora (`allEvent: false`). Update de situação entra (`allEvent: true`). `Item` `00001` vs `1`: [chave de Item](./item-chave.md). Overlay de processo: [modais](./modais.md).

Payload de listen: `BasicEventModel.parse` aceita string ou Map, `Mutation`/`Data` como lista ou objeto, ou o DTO solto.

Este coletor escuta `separar.item.consulta.update.listen` (não `separar.item.update.listen`). Catálogo: [consultas](./consultas.md).

Escuta periódica `separar.consulta.listen`: intervalo padrão 8 s, limite 20 (não 1500). Este desktop **não** registra listener nesse canal e **não** dispara outra `separar.consulta` no mesmo tick. Guia no servidor: `docs/socket/escuta.md`.

## Conexão

`AppSocketConfig` usa `transports: ['websocket']`, `autoConnect: true`, reconexão. Sem token (`handshakeAuth` nulo). URL: `http://<host>:<porta>` do arquivo de configuração da API. Emergência na conexão: [proteções](./protecoes-servidor.md).

Antes de emitir, `ensureStarted` espera o handshake. Sem `socket.id` o canal de pedido fica inválido. `listen` reassocia os handlers depois de um reconnect (`reconnectFromConfig` após salvar a API). Pedido parado espera 30s; queda da conexão aborta na hora (`_failPending`). HTTP: `connectTimeout` 8s, `receiveTimeout` 20s (`AppClientHttp`).

`ensureStarted` espera até 15 s pela conexão; o timer de 30 s do pedido começa depois dessa espera. O listener do UUID é registrado antes do emit e removido ao responder, falhar ou expirar. Recriar o socket reassocia os listeners persistentes e, após reconexão, dispara a recuperação abaixo; não reenvia pedidos pendentes. Usar a sessão atual em cada novo pedido.

HTTP e Socket.IO compartilham host/porta; namespace Socket.IO `/`. O desktop monta `http://` a partir da configuração. Suporte a HTTPS no servidor não significa que a configuração atual deste app selecione esse esquema.

Listen: `SocketEventRepository` decodifica o pacote uma vez e ignora evento da própria sessão, salvo `allEvent: true`. Tabela do que pode ser `true`: [listen da situação](./listen-situacao.md). `Item` da mutação: [chave de Item](./item-chave.md).

## Recuperação da conexão e gravação incerta

Limite quantitativo: [recarga de grades e liberação de mutações](./recuperacao-grades-totais.md). A validação atual verifica situações e vínculos; não certifica nem repara os totais persistidos. A rejeição da primeira tentativa após recarga não exige confirmação explícita do operador e não impede a próxima apenas por haver saldo divergente.

Implementado em `lib/src/app/socket_recovery.dart`, integrado a `AppSocketConfig` e aos controllers de documento/carrinho de separação e conferência.

- A primeira conexão usa a carga normal da tela. Após queda/recriação do socket, a reconexão consulta o documento ativo, suas listas de carrinhos e o carrinho aberto. As grades e unidades são substituídas, inclusive quando a resposta é vazia; não somar o snapshot ao estado anterior.
- Timeout, desconexão ou resposta inválida após emitir mutação marcam resultado incerto. Erro SQL/interno ou erro de lote também exige releitura, pois a gravação pode ter acontecido antes da falha. Timeout de consulta sozinho não marca mutação incerta.
- Antes da próxima mutação, a barreira consulta novamente o estado se necessário e **interrompe essa tentativa**, sem emitir seu payload. O usuário recebe orientação para conferir itens e situação e iniciar uma nova ação. Mesmo quando a reconexão já atualizou as grades, a primeira tentativa é interrompida para revisão. No bip, a barreira roda antes das validações locais.
- A recuperação é compartilhada entre chamadas simultâneas. Mudanças recebidas durante a leitura invalidam o snapshot e permitem até três passagens; falha de leitura ou ausência de documento mantém o bloqueio. Nova tentativa é por ação do usuário ou reconexão, sem timer de polling.
- Controllers fechados removem seus callbacks e não aplicam resultados tardios. Emergência pausa tráfego e reconexão automática; a recuperação só volta a consultar após a reconexão autorizada pelo usuário.

Essa conferência é uma releitura do estado atual, não uma prova de qual request produziu cada linha. Não há reenvio automático, comparação por UUID de operação nem garantia de execução única: o contrato do servidor não oferece idempotência, e uma operação ainda em andamento pode concluir depois da leitura. Lotes podem estar parcialmente gravados; revisar quantidades/situação antes de executar somente o que falta. A pendência é mantida em memória durante a sessão do app; reiniciar o processo perde esse histórico.

### Lotes e operações com várias gravações

`SocketMutationOperation`, acessado pelos serviços via `runSocketMutation`, acompanha uma ação assíncrona e seus serviços aninhados. A abertura, cancelamento, finalização e reabertura de carrinhos, agrupamento/desagrupamento, início/finalização de documentos, inclusão de itens e recuperação de itens usam esse acompanhamento. Os callbacks de persistência dos controllers de carrinhos também envolvem a sequência inteira, incluindo alterações de estágio e de itens em serviços distintos.

- Antes de começar, verifica a pendência de recuperação. Durante a ação, outra ação independente ou mutação avulsa no mesmo `AppSocketConfig` é recusada; não fica em fila para execução posterior com parâmetros antigos. Serviços aninhados compartilham o histórico da ação.
- Se uma etapa falhar depois de uma resposta de gravação confirmada pelo app, interrompe a sequência e marca a necessidade de releitura. Isso inclui erro de negócio na etapa seguinte e consulta pós-gravação, dentro do mesmo escopo. **Limite:** erro de negócio individual antes da primeira resposta de sucesso não cria pendência por si só, mesmo que o servidor já tenha feito commit internamente antes de falhar no refresh. Ver [erros após gravação](./erros-pos-gravacao.md); ausência de resposta de sucesso não prova ausência de gravação.
- `mutateMapped` exige a mesma quantidade de registros na resposta e no pedido: uma linha para objeto, ou o tamanho do lote. Resposta vazia ou parcial para lote não vazio é falha de confirmação e exige reconciliação. Lote vazio com resposta vazia continua aceito. Essa contagem valida o envelope, não comprova quantas linhas o SQL alterou.
- Após inserir itens de separação/conferência, a consulta precisa devolver cada chave confirmada exatamente uma vez. Retorno vazio, parcial ou duplicado não é apresentado como sucesso. O serviço interrompe e mantém a exigência de recarga antes de outra gravação.
- Não há retry de lote, rollback, exclusão compensatória ou retomada automática da etapa seguinte. Alterações já confirmadas permanecem no servidor. A releitura atualiza o estado mostrado, mas não conclui uma operação parcialmente aplicada: dependendo da situação do estágio, pode ser necessária correção operacional ou suporte do servidor para completar o fluxo.

O controle de concorrência é local ao `AppSocketConfig`; não impede outro coletor de gravar. Também não persiste o histórico após fechar o app. Atomicidade e execução única entre coletores continuam exigindo contrato transacional/idempotente no servidor.

### Consistência de itens e estágios após falha parcial

A recuperação possui duas fases: primeiro executa os callbacks que recarregam as telas; depois executa os validadores registrados pelos controllers de documento. Assim, uma inconsistência não impede a atualização da grade do carrinho aberto. Fechar o controller remove seu callback e seu validador.

`CarrinhoRecoveryValidation` consulta `carrinho.percurso.estagio.select` por empresa, origem e documento, e `separacao.item.select` ou `conferencia.item.select` por empresa e documento. Ambas as leituras são paginadas completas. A comparação usa percurso + chave normalizada do estágio (`00001` e `1` representam a mesma chave); não cruza itens de percursos diferentes.

| Estado encontrado na releitura | Resultado |
| --- | --- |
| Estágio `CANCELADA` com algum item diferente de `CA` | Mantém a recuperação pendente; cancelamento dos itens ainda não está consistente |
| Estágio aberto (`SEPARANDO`, `EM SEPARACAO`, `CONFERINDO`, `EM CONFERENCIA`, `EM ANDAMENTO`) com item `FN` | Mantém a recuperação pendente; pode haver finalização ou reabertura incompleta |
| Estágio cancelado com todos os itens `CA`, ou sem itens | Não bloqueia por esse critério |
| Estágio fechado com itens ativos legados e/ou `FN` | Não presume erro apenas pela mistura: a regra 10 do servidor aceita `SP`/`FN` em estágio `SEPARADO`/`AGRUPADO` |

Enquanto o validador falha, a recuperação não limpa a pendência e a próxima mutação continua bloqueada. A mensagem identifica percurso e estágio e orienta regularização da operação parcial. Após correção externa, uma nova tentativa relê o estado e é interrompida para revisão; somente uma ação posterior pode gravar. A recuperação não emite updates compensatórios nem tenta reabrir/cancelar novamente o estágio.

Limites: esta validação não comprova que todas as etapas de uma finalização foram executadas. As consultas não são um snapshot transacional. Estados finais aceitos pelo servidor podem exigir análise operacional mesmo sem bloqueio. O histórico de pendências continua em memória e não substitui reconciliação persistente no servidor. A comparação com o cadastro físico segue as regras abaixo para não confundir um estágio antigo com a utilização atual.

`test/src/service/carrinho_recovery_validation_test.dart` cobre as combinações acima, ordem de recarga/validação, manutenção do bloqueio, regularização externa simulada, isolamento por percurso e filtros reais dos repositórios com socket em memória. Suíte local após esta revisão: 151 testes aprovados, sem API ou SQL reais.

### Cadastro físico e reutilização em outro documento

Agrupamento/desagrupamento também valida origem e destino contra o último uso e compara os vínculos ativos com os estágios durante a recuperação. Regras, ordem dos commits e testes: [integridade do agrupamento](./agrupar-carrinho.md#revisão-de-integridade--2026-11-13).

Após validar os itens do documento, a recuperação consulta o histórico completo de seus carrinhos em `carrinho.percurso.estagio.select` por `CodEmpresa` + `CodCarrinho IN (...)`, sem restringir documento/origem nem excluir cancelados. Busca também `carrinho.select`. Os códigos são divididos em grupos de até 200 e as consultas usam `allRows`; nenhum `IN` vazio é emitido.

O uso mais recente é o maior `CodCarrinhoPercurso`, seguido pelo `Item` normalizado e comparado numericamente. Não usa a view `carrinho.consulta` para decidir: essa view omite vínculo para cadastro `LIBERADO` e exclui alguns estágios do histórico. Item não numérico impede uma conclusão segura e mantém o bloqueio.

- Se o uso mais recente está em outro estágio/documento, não comparar a situação atual do cadastro com o estágio histórico fechado/cancelado. Os itens do documento antigo continuam sujeitos à validação anterior; reutilização não regulariza seus itens automaticamente.
- Se o documento antigo ainda contém estágio aberto e o histórico mostra uso posterior do mesmo carrinho, bloquear: há um estágio antigo aberto que precisa de regularização.
- Se o último estágio pertence ao documento em recuperação, comparar cadastro e estágio conforme a tabela. Cadastro/histórico ausente ou mudança do estágio entre as leituras também impede liberar a recuperação.

| Último estágio | Situação admitida no cadastro |
| --- | --- |
| SE aberto | `EM SEPARACAO` / `SEPARANDO` |
| SE `SEPARADO` | `SEPARADO` ou `LIBERADO` (liberação usada pelo fluxo de armazenagem) |
| SE `CANCELADA` / `AGRUPADO` | `LIBERADO` |
| CO aberto ou `CANCELADA` | `EM CONFERENCIA` / `CONFERINDO` |
| CO `CONFERIDO` | `CONFERIDO` |
| CO `AGRUPADO` | `LIBERADO` |

Outras origens/situações não recebem uma equivalência presumida. A exceção `SEPARADO` + `LIBERADO` evita recusar a armazenagem existente, mas não prova que a liberação foi corretamente concluída.

Antes de cancelar, finalizar ou reabrir um estágio, os serviços também releem o histórico por empresa/carrinho. Se percurso, Item, origem ou documento já não correspondem ao último uso, recusam a ação e invalidam a tela para nova recuperação. Na finalização da separação, essa verificação ocorre antes de atualizar os itens, além da verificação no serviço que altera cadastro/estágio. Nenhuma alteração do cadastro atual é feita para “corrigir” o documento antigo.

Essa releitura não é compare-and-swap: outro coletor ainda pode mover o carrinho entre a consulta e a gravação. A garantia contra essa corrida depende de validação atômica no servidor.

Testes: `test/src/service/carrinho_cadastro_recovery_test.dart` cobre reutilização em outro documento, histórico no mesmo percurso (`9` / `00010`), estágios cancelados, cadastro divergente/ausente, filtros de leitura e recusa dos três serviços sem emitir mutações. Suíte local: 169 testes aprovados; nenhuma API ou base real utilizada.

Validação em memória: `socket_mutation_operation_test.dart` cobre falha após commit, operações aninhadas, bloqueio de intercalamento, resposta incompleta de lote e consulta pós-insert vazia/com erro/parcial nos serviços de separação e conferência. `service_socket_contract_test.dart` cobre atualização do carrinho seguida de recusa do estágio e bloqueio da repetição antes da releitura. Suíte local em 2026-11-13: 139 testes aprovados; sem acesso à API ou SQL reais.

Testes: `test/src/app/socket_recovery_test.dart` e `test/src/app/app_socket_recovery_test.dart` (transporte em memória, sem servidor real).

Os contratos de parâmetros e respostas também são cobertos por `test/src/app/socket_contract_test.dart`: envelopes inválidos, metadados divergentes, cópia dos parâmetros, filtros estáveis entre páginas e interrupção da paginação após troca de sessão. Esses testes não acessam a API nem a base SQL.

### Validação com dois clientes simulados — 2026-11-13

`test/src/app/two_collectors_recovery_test.dart`: dois `AppSocketConfig` com sessões independentes e servidor compartilhado em memória. Usa `SocketEventRepository.dispatch`, DTOs e controllers reais das grades de separação/conferência; o fixture registra a recarga e aplica o mesmo caminho de substituição das grades. Não instancia as telas completas nem executa handshake/reconexão de rede real ou triggers SQL.

Os seis cenários abaixo passaram para cada fluxo (12 testes):

| Cenário | Resultado verificado |
| --- | --- |
| A grava, cai antes da resposta; B grava com A offline | Após reconectar, ambos têm 2 linhas e quantidade 3; somente 2 requests de insert. Primeira repetição de A bloqueada; três reconexões adicionais não duplicam linhas |
| Queda antes de gravar | Ambos vazios após releitura; tentativa antiga bloqueada; nova ação explícita grava uma única linha |
| Lote de duas linhas parcialmente gravado | Snapshot contém só o primeiro commit e a gravação de B; lote não é reenviado; nova ação somente com a quantidade faltante converge para 3 linhas e quantidade 6 |
| Commit com resposta perdida, sem desconexão | Timeout exige releitura; ambos terminam com uma linha e somente um request de insert |
| Consulta falha durante recuperação | Inserts continuam bloqueados; quando a consulta volta, ambos convergem sem nova gravação |
| Broadcast durante leitura de snapshot antigo | Recuperação realiza segunda leitura; ambas as grades terminam com as mesmas chaves e quantidades, sem duplicação |

Em todas as verificações de convergência, as chaves das grades são únicas e correspondem às linhas persistidas no fixture; totais também são comparados. Broadcast próprio é ignorado e a resposta local aplica a gravação apenas uma vez.

Limite da evidência: confirma a simulação dos componentes do cliente, não homologação operacional em dois executáveis Windows contra o servidor real. Tampouco garante ausência de duplicação se o operador ignorar a revisão e fizer uma nova gravação já aplicada: falta idempotência no servidor. Não foram alterados dados reais.
