# Erros após gravação: confirmação, incerteza e recuperação

Revisão estática em 2026-11-13, sem executar aplicativo, API, SQL ou testes reais. Código e testes existentes foram lidos; nenhuma correção funcional ou teste novo foi aplicado nesta revisão.

## Duas confirmações diferentes

**Commit no banco não é confirmação recebida pelo app.** Um evento Socket individual pode executar DML em autocommit, atualizar totais, consultar views e só então responder. Se uma etapa posterior falhar, o banco já pode ter mudado apesar de o cliente receber apenas `Error`.

`SocketMutationOperation.hasWrites` significa que o app recebeu e mapeou uma resposta de mutação não vazia dentro daquele escopo. Não observa commits internos do Node/SQL. Por isso, “erro antes da primeira resposta de sucesso” não significa “erro antes da primeira gravação”.

## Classificação atual no app

| Situação | Recuperação atual |
| --- | --- |
| Falha local antes de emitir, sem sucesso anterior no escopo | Não indica por si só gravação incerta. |
| Timeout/desconexão/falha de envio após marcar pedido como emitido | Marca `mutationUncertain`. A emissão incerta é tratada conservadoramente. |
| Resposta de mutação inválida, incompatível com sessão/canal ou sem payload esperado | Marca incerteza. |
| Erro explícito com prefixo SQL-* ou INTERNAL_ERROR | Marca incerteza para mutação individual ou lote. |
| Erro explícito em `Mutation` lista com mais de um elemento | Marca incerteza independentemente do prefixo. |
| Erro explícito `[500xx]` em objeto individual ou lista de um elemento | Não marca por essa condição, se não houver sucesso anterior no escopo externo. |
| Outro erro explícito fora dos prefixos acima em pedido individual | Mesma lacuna: `Code` não comprova fase, e a regra atual não o usa para determinar efeito. |
| Falha de mapeamento ou contagem após resposta de sucesso | `mutateMapped` marca incerteza. |
| Qualquer exceção propagada após sucesso mapeado anterior no mesmo `runSocketMutation` | Escopo marca incerteza, inclusive erro de negócio ou consulta posterior. |
| Falha em callback de UI depois de o serviço encerrar seu escopo | Não é coberta automaticamente pelo escopo já encerrado. |

Em `AppSocketConfig.request`, o ramo com `Error` define `serverError = true`; o catch subsequente não aplica o fallback genérico de resposta inválida. Portanto, um erro de negócio individual fora das condições permanece sem invalidação.

`mutateMapped` faz `await request(...)` **antes** do try que valida o resultado. Se `request` lança esse erro explícito, o catch de mapeamento não o intercepta. Sem resposta não vazia anterior, `SocketMutationOperation` também não possui `hasWrites` para cobrir a lacuna. Não há proteção adicional implícita nessas duas camadas.

## O envelope do servidor não informa efeito transacional

`ExpedicaoBasicErrorEvent` e `SocketResponseBuilder.error` retornam Session, ResponseIn, Error, Code e RequestId. Não incluem estado de commit, fase da falha, chaves aplicadas, confirmação de rollback ou recibo durável. `classifyClientError` classifica a causa, não o resultado transacional.

`runSocketHandler` captura falhas do handler e emite o erro classificado. Seu contexto SQL não transforma o evento em transação: os repositórios atuais usam autocommit. RequestId serve à correlação do diagnóstico; não identifica uma intenção persistida consultável/repetível com segurança.

Assim, `[50014]`/BUSINESS_RULE_VIOLATION ou `[INVALID_PAYLOAD]` não devem ser usados isoladamente como prova de “nenhuma gravação”. A origem e a posição da validação importam. Uma rejeição comprovadamente anterior ao DML é diferente de falha no refresh após DML; o contrato atual não permite distingui-las genericamente no cliente.

## Caminhos relevantes inspecionados

| Caminho | Sequência | Cobertura/risco |
| --- | --- | --- |
| Inserir/alterar/excluir item SE/CO | DML → manutenção de total/consultas → resposta | Se etapa posterior falhar com erro de negócio, pode haver commit invisível à barreira local. A ocorrência depende das regras/dados do banco; não foi reproduzida. |
| Abrir estágio pelo serviço do desktop | Atualizar cadastro e receber sucesso → inserir estágio | O escopo compartilhado já marca pendência se o insert seguinte for recusado, por exemplo com 50014. |
| Inserir item e reler a view no serviço do desktop | Resposta de insert validada → query da linha | Falha de query ou correspondência dentro do mesmo escopo já marca pendência. |
| Exclusão individual/reconferir tudo e alteração visual posterior | Serviço termina → callback modifica grades | Se a etapa visual falhar, o escopo do serviço não detecta essa falha posterior. Ver revisões dos fluxos. |

Um THROW da trigger do próprio comando inicial pode desfazer esse comando. Isso não desfaz comandos anteriores do evento ou do fluxo. Não anunciar “rollback completo” apenas por haver erro de negócio.

Outra fronteira: handlers emitem resposta antes dos broadcasts. Depois de a resposta chegar, o cliente remove o listener de ResponseIn. Uma falha posterior de emissão de listen não desfaz o commit nem será necessariamente percebida como erro pelo solicitante. A consistência de outros coletores depende de ressincronização ou entrega durável de eventos, não de repetir a gravação.

## Recuperação não é reparação

Detalhamento do ciclo de liberação e dos leitores: [recuperação de grades e totais](./recuperacao-grades-totais.md). O validador atual não compara quantidades físicas com totais persistidos; uma recarga sem erro pode liberar a tentativa seguinte apesar de divergência de saldo.

`mutationUncertain` marca recarga/revisão. `beforeMutation` aguarda leitores/validadores e rejeita a primeira tentativa seguinte para não enviar um payload calculado antes da recarga. Se a leitura/validação falha, a barreira continua. Não há rollback, reenvio ou retomada automática.

Leitores recarregam o estado persistido e validadores verificam situações. Eles não conhecem commits omitidos do evento, não recompõem todos os agregados e não provam que a intenção inteira foi concluída. Se o item foi removido mas o total não foi atualizado, a releitura pode mostrar precisamente essa divergência. A necessidade de reparar o total no servidor permanece.

A proteção só observa exceções propagadas no escopo. Capturar erro e retornar normalmente dentro de uma operação pode esconder a interrupção de `SocketMutationOperation`; uma incerteza já marcada no transporte permanece, mas uma falha de consulta posterior a sucesso pode passar sem marcação se for engolida. Os callbacks devem preservar a propagação até a fronteira que registra a falha.

## Diagnóstico e mensagens

O prefixo e `Code` descrevem a causa; o estado da operação deve ser informação separada. `AppError` conserva `contractCode`, mas o classificador de recuperação atual usa o prefixo textual e o tamanho do pedido. Metadados como RequestId não são armazenados em campo próprio de `AppError`.

Quando `SocketMutationOperation` embrulha a falha após sucesso, conserva `contractCode` e usa `AppError.display(cause)` como detalhe. Esse display remove o prefixo, e o novo erro tem mensagem genérica de operação interrompida. O identificador numérico original pode deixar de aparecer no diagnóstico apresentado. A proposta é preservar causa/código/evento/RequestId estruturados, sem perder a mensagem de revisão obrigatória.

`isRetryableLock` e mensagens “tente novamente” não autorizam replay de mutação. São indicações de causa; em gravação, resultado incerto e revisão têm precedência.

## Correção proposta, ainda não aplicada

1. **Política conservadora no legado:** erro recebido após emitir mutação deve exigir reconciliação quando não existe prova contratual de ausência de efeitos, inclusive `[500xx]` individual/lista de um. Não isentar por texto, Code ou quantidade de itens. Falha local comprovadamente anterior à emissão pode continuar sem pendência.
2. **Separar motivo de resultado:** manter mensagem original e diagnóstico estruturado, acrescentando que a ação pode estar parcialmente aplicada e não deve ser repetida sem revisão. Não afirmar que houve commit quando ele é apenas possível.
3. **Escopo completo no desktop:** incluir persistência e leituras necessárias à atualização da UI no mesmo controle de operação; propagar falhas e manter a barreira se a recarga não terminar. Não usar conclusão do Future do serviço como prova de atualização das grades.
4. **Contrato novo no servidor:** operação atômica/idempotente com recibo e resultado explícito (nomes a definir: não aplicada, revertida integralmente, confirmada, parcial, desconhecida). Uma declaração de rollback deve cobrir todos os comandos daquele evento e ser comprovada pelo servidor. Parcial/desconhecida nunca liberam replay automático. Erro de refresh após commit deve preservar o recibo da gravação concluída.
5. **Recuperar efeito, não repetir intenção:** consultar resultado persistido pela chave idempotente e atualizar estado. Reparar totais por operação específica protegida, sem repetir INSERT/DELETE/UPDATE para provocar refresh. Não adicionar campos propostos como se o servidor atual já os suportasse.

A política conservadora pode pedir releitura também quando a regra recusou a ação antes de gravar. É o custo de o envelope legado não distinguir as fases; uma lista de exceções por código não resolve essa ambiguidade.

## Testes existentes e lacuna de cobertura

Arquivos lidos, não executados nesta revisão:

- `test/src/app/socket_mutation_operation_test.dart`: cobre sucesso de uma mutação seguido de erro de negócio em outra no mesmo escopo; cobre também a hipótese de recusa antes do primeiro commit.
- `test/src/app/app_socket_recovery_test.dart`: o caso “lote com erro pode ter commits parciais; erro de regra único não” espera ausência de recuperação para erro único. O mock só devolve erro; não modela um servidor que confirmou DML internamente antes de falhar.

Esses testes não demonstram que todo erro individual ocorre antes do commit. Ao implementar a correção, rever os nomes/premissas e adicionar servidor em memória que grave e depois devolva `[500xx]`, para objeto e lista de um; Code sem prefixo; erro antes do DML; SQL/interno; resposta perdida; erro após sucesso externo; falha de UI dentro/fora do escopo; falha de recarga. Verificar barreira, ausência de reenvio, preservação da causa e reconciliação. Homologação real continua pendente e não autorizada nesta revisão.

## Fontes

App: `lib/src/app/app_socket_config.dart::{request,mutateMapped}`, `socket_mutation_operation.dart`, `socket_recovery.dart`, `app_error.dart`; serviços de adicionar estágio/item e controllers de exclusão/reconferência.

Servidor `D:\Developer\Node\data7-api-pix Campo`: `src/socket/socket.event.helpers.ts::runSocketHandler`, `src/socket/protocol/socket.response.builder.ts`, `src/model/expedicao.basic.error.event.ts`, `src/utils/repository.error.ts`, handlers de `separacao.item`/`conferencia.item`.

Relacionados: [erros](./erros.md), [exclusão/cancelamento individual](./excluir-cancelar-item.md), [reconferir tudo](./reconferir-tudo.md), [concorrência/idempotência](./concorrencia-idempotencia.md).
