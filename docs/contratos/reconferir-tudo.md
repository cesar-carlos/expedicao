# Reconferir tudo: exclusão, saldos e falhas parciais

Revisão estática em 2026-11-13. Sem executar app, API, SQL, migração ou testes reais. Achados e propostas abaixo não representam correções implementadas.

## O que a ação realmente faz

Para ação em uma única linha, ver [exclusão e cancelamento individual](./excluir-cancelar-item.md), incluindo a lacuna de erro de negócio após commit em mutações individuais.

Nas telas de separação e conferência, `onReconferirTudo` chama o respectivo `RemoverItemService.removeAllItensCart`. Isso emite **DELETE físico** dos itens selecionados, não UPDATE para `CA`. Os serviços `SeparacaoCancelarItemService` e `ConferenciaCancelarItemService` são outros caminhos e não são chamados por esse botão.

Reconferir tudo também não executa `addAll`, não repõe quantidades automaticamente e não cancela/reabre o estágio nem altera o cadastro do carrinho. Depois da limpeza, o operador deve realizar novas bipagens ou acionar separar/conferir tudo. Não confundir com cancelar carrinho ou recuperar itens de estágio cancelado: linhas excluídas por esta ação não ficam disponíveis como histórico CA para recuperação.

| Etapa | Separação | Conferência |
| --- | --- | --- |
| Entrada | `SeparacaoController.onReconferirTudo` | `ConferenciaController.onReconferirTudo` |
| Bloqueios de UI | `_processando`, modo visualização, quantidade da grade do carrinho igual a zero, identificação | Equivalentes |
| Seleção para excluir | View de itens separados por empresa/documento/percurso/estágio, `allRows` | Tabela de itens conferidos por empresa/documento/percurso/estágio CO, `allRows` |
| Filtro de situação/setor no serviço | Não há | Não há |
| Gravação | `separacao.item.delete`, lista de DTOs | `conferencia.item.delete`, lista de DTOs |
| Depois do sucesso | Zera QuantidadeSeparacao da primeira linha encontrada por produto e limpa toda a grade do carrinho | Zera QuantidadeConferida da primeira linha por produto, limpa grade do carrinho e destaque |

A seleção não restringe a SP/CF: linhas CA ou FN retornadas pela consulta também entram na lista. A grade é usada para decidir se a ação pode começar e quais produtos zerar visualmente; a lista enviada ao servidor vem de outra leitura. São snapshots diferentes.

## Fronteira de gravação no servidor

Nos handlers `src/socket/separacao.item/separacao.item.event.ts` e `src/socket/conferencia.item/conferencia.item.event.ts`, a ordem é: consultar linhas para o listen → excluir cada DTO → recalcular totais → emitir resposta e broadcasts. Os repositórios executam DELETE por linha em autocommit.

Os SQL `expedicao.item.separacao.delete.sql` e `expedicao.item.conferencia.delete.sql` filtram empresa/documento/Item. Não incluem estágio, situação anterior ou versão no predicado. O handler devolve os DTOs solicitados; isso não é uma lista obtida de `OUTPUT DELETED` nem prova de quantas linhas foram efetivamente afetadas. A conferência do tamanho da resposta no app não resolve essa diferença.

## Falhas parciais e recuperação atual

| Momento da falha | Estado possível | Comportamento/limite |
| --- | --- | --- |
| Antes dos DELETEs | Nenhum item removido | Erro de consulta não deve ser confundido com limpeza concluída. |
| Durante o lote | Parte das linhas já excluída, demais ainda ativas | O refresh posterior pode nem executar. Não há rollback das exclusões anteriores. |
| Após excluir, antes de terminar refresh | Itens removidos, totais antigos ou parcialmente atualizados | Recarregar a demanda lê o total persistido; não recompõe automaticamente o agregado. |
| Após commit, resposta perdida | Exclusão aplicada sem confirmação no coletor | O app marca resultado incerto e exige releitura/revisão antes de nova mutação. |
| Após resposta, atualização local falha | Banco alterado e UI incompleta | O escopo `runSocketMutation` termina no serviço. A atualização de grades no callback do controller não compartilha esse escopo; falha nessa etapa não é automaticamente marcada por ele. |

Em erro, o controller sai pelo catch e não executa sua limpeza local posterior ao serviço. Entretanto, eventos de outros coletores podem ter alterado as grades; não se deve tratá-las como uma cópia intacta do estado anterior.

`SocketRecovery` recarrega leitores e valida consistência antes de rejeitar a primeira nova tentativa para revisão. `CarrinhoRecoveryValidation` detecta, por exemplo, estágio CANCELADA com itens ativos e estágio aberto com FN. Mas um estágio aberto com alguns SP/CF restantes é um estado normal possível. Sem recibo/lista persistida da intenção, o validador não sabe que esses itens eram o restante de uma limpeza interrompida. Ele também não recalcula nem compara os totais armazenados com os registros físicos.

Se todos os itens forem excluídos e o refresh falhar, a recarga pode mostrar carrinho vazio e total de demanda antigo. O botão recusa nova execução porque a grade do carrinho soma zero. Logo, repetir a ação não é um mecanismo confiável para reparar totais.

## Saldos incorretos mesmo após sucesso

### Outros carrinhos e estágios

Na separação, a quantidade realizada da demanda pertence ao documento inteiro. Exemplo: carrinho A tem 3 UN de P e B tem 4 UN. Reconferir A deve deixar 4 UN realizadas no documento, não zero. O controller encontra P na demanda e atribui zero localmente sem considerar B. O servidor tenta recalcular o total, mas os próprios eventos de quantidade usam `allEvent: false`; o coletor de origem não deve depender deles para corrigir sua atualização local.

Na conferência, a exclusão alcança o estágio CO atual, enquanto o refresh de totais no servidor agrupa por documento/carrinho/produto. Se houver execução ativa em outro estágio do mesmo carrinho, zerar o total local também é incorreto. A possibilidade e o tratamento dessas utilizações precisam ser validados no contrato; não foi verificada uma ocorrência na base.

### Linhas repetidas e unidades diferentes

Os controllers montam `Map<int, ...>` por produto e usam `findCodProduto`, que retorna a primeira linha. Só essa linha recebe zero; outras linhas do mesmo produto conservam os valores anteriores, independentemente da unidade. Exemplo visual: P possui linhas UN e CX; os itens do carrinho foram excluídos, mas apenas a primeira linha da demanda é zerada. A outra pode permanecer marcada como realizada sem os registros físicos correspondentes.

O refresh do servidor também não distribui corretamente por linha/unidade: soma por produto e altera a primeira linha. Não basta substituir o zero local por uma reconsulta e anunciar que a granularidade foi corrigida. É necessário o mesmo modelo de saldo na execução, no agregado e na UI.

### Próxima ação após limpeza parcial

Demanda de duas linhas de 5 UN; restaram 5 UN físicas após parte dos DELETEs. O `addAll` atual desconta essas 5 UN de cada linha e retorna lote vazio, embora faltem 5 UN no total. Com unidades diferentes, o saldo remanescente é abatido por produto sem conversão. Esses defeitos tornam inseguro usar separar/conferir tudo como recomposição automática depois de falha. Ver [revisão dos lotes](./separar-conferir-tudo.md).

O teste de soma zero da grade também não comprova ausência de registros. Se quantidades zero ou compensatórias existirem, pode haver linhas e o botão recusá-las. Não foi verificado se esses valores são permitidos na base.

## Concorrência: limpar o quê e até quando?

- Os serviços de remoção em lote não revalidam que o estágio é a última utilização do carrinho antes da exclusão. As verificações de visualização usam estado da tela; não são uma condição SQL atômica.
- Um segundo coletor pode inserir após a seleção. O novo Item não integra o lote, mas o primeiro coletor limpa toda a grade local após o sucesso, podendo ocultar uma linha que permanece gravada.
- Repetir `removeAllItensCart` consulta de novo e pode incluir bipagens posteriores à intenção original. Retomar uma operação interrompida e pedir uma nova limpeza não são a mesma decisão.
- Como o DELETE usa apenas a chave e o servidor gera Item com MAX + 1, reutilização de uma chave excluída pode fazer um pedido atrasado atingir outra linha. Uma nova leitura e bloqueio local não eliminam essa corrida.
- Falha no meio do loop pode impedir os broadcasts previstos para o lote; não presumir que o segundo coletor recebeu toda exclusão confirmada.

## Proposta de correção, ainda não aplicada

1. **Definir a intenção de negócio:** excluir fisicamente ou cancelar com histórico CA; conjunto de linhas observado no momento da confirmação ou todos os itens de uma revisão do estágio. Não trocar DELETE por CA silenciosamente: isso altera auditoria, recuperação e regras de saldo.
2. **Comando atômico e idempotente no servidor:** validar documento, estágio atual, utilização do carrinho e versão; executar limpeza e recomposição dos totais na mesma transação. Usar chaves/versões esperadas ou revisão do estágio para não apagar trabalho novo. Registrar recibo com chaves realmente afetadas e revisão final, sem reutilizar Item publicado.
3. **Retomada explícita:** consultar recibo da intenção original em resultado incerto. Sem contrato novo, manter revisão manual e impedir que uma nova seleção ampliada seja apresentada como repetição segura da antiga.
4. **Recompor os saldos restantes:** calcular a partir das linhas físicas ainda ativas no escopo completo, preservando outros carrinhos/estágios e separando produto/unidade ou alocação por linha de demanda. Incluir totais zero e gravar apenas colunas derivadas. A reparação de agregado deve funcionar mesmo quando o carrinho ficou vazio.
5. **Atualizar a UI com o estado confirmado:** substituir zeragem por produto e limpeza indiscriminada por releitura/resultado versionado das duas grades. Abranger persistência e leituras posteriores pelo controle local de operação; se a leitura falhar, manter estado de revisão pendente. Isso reduz inconsistência visual, mas não substitui a transação no servidor.
6. **Corrigir os lotes seguintes:** completar saldo com demanda agrupada e abatimento único ou vínculo por linha, conforme [separar/conferir tudo](./separar-conferir-tudo.md). Não reconstruir automaticamente quantidades a partir da grade antiga nem repetir inserts.

## Validação futura (não executada)

Dois produtos; várias linhas do mesmo produto; UN/CX; outro carrinho com saldo; outro estágio CO ativo; linhas CA/FN; falha no primeiro/meio/último DELETE; falha no refresh após excluir tudo; resposta perdida; leitura posterior falhando; item inserido após seleção; finalização/reutilização concorrente; repetição da mesma intenção e nova limpeza explícita. Verificar linhas físicas afetadas, restantes, totais por grupo, situação do estágio, recibo e ambas as grades. A contagem de linhas devolvida pelo handler atual não é evidência suficiente.

## Fontes

- `lib/src/pages/separacao/separacao_controller.dart` e `lib/src/pages/conferencia/conferencia_controller.dart`: `onReconferirTudo`, recarga e atualização por produto.
- `lib/src/service/separacao_remover_item_service.dart`, `conferencia_remover_item_service.dart`; comparação com os serviços `*_cancelar_item_service.dart`.
- `lib/src/app/app_socket_config.dart`, `socket_recovery.dart`, `socket_mutation_operation.dart` e `lib/src/service/carrinho_recovery_validation.dart`.
- Servidor `D:\Developer\Node\data7-api-pix Campo`: handlers/repositórios Socket de `separacao.item`/`conferencia.item` e SQL `src/sql/expedicao/expedicao.item.{separacao,conferencia}.delete.sql`.

Relacionados: [recuperar carrinho](./recuperar-carrinho.md), [Item e totais](./item-totais-concorrencia.md), [concorrência e idempotência](./concorrencia-idempotencia.md).
