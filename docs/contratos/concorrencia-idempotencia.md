# Dois coletores: concorrência, transações e idempotência

Revisão estática em 2026-11-13. Fontes: este app, `D:\Developer\Node\data7-api-pix Campo\src` e `docs`, e scripts em `D:\Developer\Data7\Expedicao\Expedicao Correcoes`. Sem acesso a API, SQL Server ou executáveis do coletor. Um script local não comprova sua instalação nem o isolamento/índices da base em execução.

**O contrato atual não oferece execução única de mutações entre coletores.** O desktop reduz repetições locais e reconcilia falhas incertas; não reserva saldo ou carrinho no servidor. Não enviar `transacao: true` ou chave de idempotência como se já fossem suportados.

## Proteções encontradas no servidor

| Proteção | Evidência relativa à raiz do servidor | Alcance e limite |
| --- | --- | --- |
| Atomicidade de um comando SQL e suas triggers | `src/infra/connection.sql.server.mssql.ts`, `executeInTransaction` | Executa `operation(pool.request(), 'autocommit')`. Não envolve lote ou vários eventos numa transação. Rollback do comando atual não desfaz comandos anteriores. |
| Infraestrutura de transação explícita | Mesmo arquivo: `beginTransaction`, `getTransactionRequest`, `commitTransaction`, `rollbackTransaction` | Métodos existem; não foram encontrados chamadores de begin/getRequest nas mutações de expedição em `src`. Não há opt-in Socket implementado. |
| Deduplicação de consultas em andamento | `src/socket/socket.event.helpers.ts`, `protocol/socket.query.dedupe.ts` | Apenas `kind === 'query'`, por objeto socket e evento/filtros/página/ordenação. Não deduplica mutações, dois sockets ou reconexões. |
| Correlação de respostas | `src/socket/protocol/socket.protocol.adapter.ts` | `Session`/`ResponseIn` encaminham respostas. `requestId` é um UUID novo por recebimento, não chave de negócio reaproveitável. Não há recibo durável de operação. |
| Regras de fechamento e snapshot | `docs/expedicao/triggers.md`, scripts 01/02/04/05/06 | Script 01 bloqueia o cabeçalho no fechamento. Regras 50011–50014/50016 restringem fechamento, origem e conferência ativa; não deduplicam bipagens. |
| Conferência ativa por origem | Script `04 - tr_ExpedicaoConferirOrigemUnica.sql` no pacote Correcoes | Trigger AFTER INSERT/UPDATE consulta outra conferência ativa e lança 50016. Não declara UPDLOCK/HOLDLOCK. A documentação informa retirada do índice único filtrado por incompatibilidade FireDAC. Não inferir garantia universal contra corridas sob qualquer isolamento; instalação e isolamento precisam de homologação autorizada. |
| Existência de carrinhos no insert de conferência | `src/socket/conferencia.item/conferencia.item.event.ts`, `assertCarrinhosExistem` | Consulta antes do insert; não é reserva exclusiva nem comparação atômica de versão/saldo. |

`transacao: true`/evento de lote está em **Ainda não** no guia `docs/socket/protecoes-cliente.md` do servidor. O nome `executeInTransaction` não comprova atomicidade do fluxo.

## Riscos no caminho de gravação

Detalhamento e proposta de implementação: [geração de Item e manutenção dos totais](./item-totais-concorrencia.md), incluindo reutilização de chaves, updates de DTO inteiro e revisão dos grupos antigos/novos.

| Cenário | Evidência/comportamento | Consequência possível |
| --- | --- | --- |
| A e B leem o mesmo saldo | Consulta no cliente e insert são pedidos separados; inserts não reservam/verificam saldo atomicamente | Excesso no pedido ou duas cópias da mesma recuperação, mesmo com chaves diferentes. |
| Commit seguido de perda da resposta | Insert e refresh precedem `emitMutation`; não há recibo persistente | Erro/timeout pode ocorrer após gravar. Reemitir insert com Item vazio pode criar outra linha. |
| A e B calculam o próximo Item | Inserts usam `MAX(CAST(Item AS INT)) + 1` para Item vazio/00000, sem lock explícito nesse cálculo | Disputa pelo identificador, conflito de chave/deadlock conforme banco. PK, se presente, impede repetir a chave, não duplicação de negócio com outra chave. |
| Falha na linha N de lote | Repositórios Socket fazem `for` com insert/update/delete por linha | Linhas anteriores podem estar confirmadas quando o lote retorna erro. |
| Atualização simultânea de cadastro/item | UPDATE filtra chaves, sem versão/situação anterior esperada | Uma gravação baseada em leitura antiga pode sobrescrever outra, inclusive após reutilização do carrinho. |
| Cancelar/finalizar/reabrir/agrupar | Cadastro, estágio, itens, agrupamento e auditoria usam múltiplas mutações | Intercalação entre coletores e estado parcial; bloqueio local não impede outro coletor. |
| Recalcular o total separado | `refreshItensSepararConsulta`: SUM, leitura do pedido e UPDATE QuantidadeSeparacao separados | A calcula 5, B calcula/grava 8, A grava 5 depois. Recarregar a grade pode mostrar agregado desatualizado; requer recomposição/cálculo protegido no servidor. |

Fontes SQL: `src/sql/expedicao/expedicao.item.separacao.insert.sql`, `expedicao.item.conferencia.insert.sql`, `expedicao.carrinho.percurso.estagio.insert.sql`, `expedicao.carrinho.percurso.agrupamento.insert.sql`, `expedicao.item.separacao.update.sql` e `expedicao.carrinho.update.sql`.

A regra 16 sobre atribuir sequências de **conferir/separar** não deve ser estendida aos **itens de conferência/separação**: os quatro inserts acima usam MAX + 1 no caminho analisado. Loops e refresh: `src/socket/separacao.item/separacao.item.repository.ts`, `separacao.item.event.ts` e equivalentes de `conferencia.item`.

O refresh de separação agrupa por empresa/documento/produto, soma situações diferentes de CA, consulta até cinco linhas do pedido e atualiza a primeira. Não inclui unidade nessa soma. A recuperação do desktop limita por produto **e unidade**. A definição de unidade/conversão e de múltiplas linhas do mesmo produto precisa ser unificada antes de implementar validação transacional de saldo.

## Proteções atuais e lacunas do desktop

- `AppSocketConfig`: congela payload, cria ResponseIn por pedido, valida sessão e quantidade de linhas retornadas; não reenvia automaticamente mutações. Resposta incerta exige recarga/revisão.
- `SocketMutationOperation`: impede intercalar operações locais abrangidas pelo mesmo AppSocketConfig e registra falha após gravações confirmadas. Não é transação SQL nem trava entre processos.
- `SocketRecovery`/`CarrinhoRecoveryValidation`: recarregam e verificam cadastro, estágios, itens e agrupamentos. Consultas não são snapshot transacional; pendências ficam em memória e não sobrevivem ao encerramento do app.
- `SeparacaoAdicionarItemService.addRecuperados`: relê origem/destino, recusa reutilização/cancelamento incompleto e desconta quantidades ativas no destino. Evita repetição sequencial; dois clientes ainda podem ler o mesmo saldo. Bipagens manuais equivalentes também abatem o saldo, pois não há vínculo persistido entre origem cancelada e cópia.
- Grades conciliam linhas por chave e aplicam listens. Deduplicar uma linha visual não elimina duas linhas físicas de chaves diferentes. Broadcast não é recibo durável nem exclusão mútua.

## Próximo contrato necessário — proposta, não disponível

1. **Operações de domínio atômicas no servidor.** Recuperar, cancelar, finalizar, reabrir e agrupar devem validar saldo/estado e atualizar todas as entidades na mesma transação curta. Bloquear recursos de negócio em ordem consistente ou usar versão esperada com atualização condicional. Uma transação sem proteger a leitura do saldo ainda permite corrida. Não manter transação aberta entre eventos enviados pelo coletor.
2. **Chave durável da intenção.** Aceitar chave de idempotência, escopo de empresa/operação e hash do payload. Registrar resultado e mutações na mesma transação, com restrição única válida entre sockets/processos/reinícios. Mesma chave/conteúdo retorna resultado original; conteúdo diferente gera conflito. Definir retenção e consulta de status. Não deduplicar só produto/quantidade: bipagens iguais podem ser legítimas.
3. **Sequências e restrições de negócio.** Substituir MAX + 1 desprotegido; definir unicidade de uso ativo de carrinho/agrupamento e vínculo da recuperação. Idempotência evita repetir uma intenção; reserva de saldo/ocupação evita duas intenções diferentes conflitantes. Preservar múltiplos usuários no mesmo documento.
4. **Recibo e eventos após commit.** Retornar identificadores/versões e estado final; consulta posterior deve distinguir concluída, pendente, rejeitada e desconhecida. Considerar registro transacional de eventos pendentes (outbox). Falha de refresh/broadcast não deve induzir nova gravação.
5. **Integração no app_expedicao.** Persistir intenção/chave antes do envio, mantê-la após reconexão/reinício e consultar recibo em resultado ambíguo. Nova chave apenas para nova intenção. Enviar versões esperadas, tratar conflitos com recarga e substituir sequências de eventos por comandos atômicos. Negociar capacidade/versão; manter fluxo atual sem retry em servidor antigo. Um UUID apenas em ResponseIn não atende a isso.

## Validação futura, não executada

Testar em isolamento e depois em base autorizada: mesmo saldo em dois coletores; mesma chave simultânea/após resposta perdida; chaves diferentes disputando carrinho; queda após cada etapa; commit seguido de falha no refresh; reinício Node/app; conflito de versão; disputa de Item; agregados gravados fora de ordem; trigger rejeitando linha no meio do lote. Verificar quantidade física, vínculo de recuperação, cadastro/estágio, recibos e ambas as grades. Esta revisão estática não comprova ausência de duplicação no ambiente instalado.

Veja [recuperação de carrinhos](./recuperar-carrinho.md), [agrupamento](./agrupar-carrinho.md) e [comunicação Socket](./consulta-socket.md).
