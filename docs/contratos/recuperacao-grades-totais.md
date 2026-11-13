# Recuperação: grades atualizadas e totais inconsistentes

Revisão estática em 2026-11-13. Sem executar app, API, SQL ou testes reais. Foram lidos o código de recuperação, seus consumidores, views do servidor e testes existentes. Achados e propostas não foram implementados nesta revisão.

**Recarga concluída não comprova saldo consistente.** A barreira atual valida situações e atualiza as telas, mas não compara os totais persistidos com as quantidades físicas. Um total antigo pode ser carregado com sucesso e usado na próxima ação.

## Como a barreira funciona hoje

`SocketRecovery` mantém `_dirty`, `_reviewRequired`, `_refreshing` e uma revisão local. Não mantém pendências identificadas por empresa/documento/operação nem recibo durável.

1. `invalidate`/`mutationUncertain` marcam recarga e revisão necessárias. A lacuna de erro de negócio individual pode impedir que essa etapa aconteça; ver [erros após gravação](./erros-pos-gravacao.md).
2. `refresh` só executa se `_dirty` estiver ativo. Compartilha a mesma tarefa entre chamadas concorrentes.
3. `_reload` exige conexão apta a ler e pelo menos um leitor. Executa todos os leitores registrados, depois os validadores registrados. Se detectar alteração de revisão, repete, até três tentativas.
4. Se leituras e validadores terminarem sem exceção e a revisão permanecer estável, limpa `_dirty`. Não exige que exista ao menos um validador e não verifica se os leitores cobrem o documento que originou a pendência.
5. `beforeMutation`, ao encontrar bloqueio, aguarda `refresh`, limpa `_reviewRequired` e lança mensagem para o usuário revisar. **Essa tentativa não é enviada.** Na próxima tentativa, se nada invalidar novamente, a barreira permite continuar.

Não há confirmação explícita de revisão humana nem condição adicional de consistência quantitativa nessa liberação. A segunda tentativa passa pela barreira, mas ainda pode ser recusada por regras da tela/serviço. Se uma leitura ou validação lançar erro, a limpeza das pendências não é concluída e a barreira permanece.

A reconexão dispara `refresh` em segundo plano; erro é registrado no log e não libera a pendência. Um erro de negócio com conexão mantida, mesmo quando marcado como incerto, não necessariamente dispara recarga imediata: a próxima chamada de `beforeMutation` é um dos pontos que a provoca.

## O que é recarregado

| Leitor | Conteúdo |
| --- | --- |
| `SepararController._reloadAfterConnection` | Cabeçalho/situação, demanda com totais persistidos, unidades, percurso e lista de carrinhos. |
| `SeparacaoController._reloadAfterConnection` | Estágio exato e modo visualização; registros físicos de separação filtrados para o estágio aberto. A demanda é compartilhada com a tela principal; este leitor não refaz sozinho sua consulta completa. |
| `ConferirController._reloadAfterConnection` | Cabeçalho/situação, carrinhos a conferir, percurso e carrinhos conferidos. |
| `ConferenciaController._reloadAfterConnection` | Estágio exato e modo visualização; demanda/unidades do carrinho e registros de conferência filtrados para o estágio atual. |

As cargas substituem as respectivas listas, inclusive por resultado vazio. Entretanto, cada leitor publica seu resultado conforme termina. Se um leitor posterior falhar, algumas grades podem já mostrar dados novos e outras continuar antigas. A barreira impede nova mutação quando acionada, mas não há publicação atômica de um snapshot de todas as grades.

As views `expedicao.item.separar.consulta.sql` e `expedicao.item.conferir.consulta.sql` leem `QuantidadeSeparacao`/`QuantidadeConferida` armazenadas. Reconsultá-las não recalcula a quantidade a partir das bipagens. A grade do carrinho pode estar correta e a de demanda continuar errada, ambas após consultas bem-sucedidas.

## O que o validador verifica — e o que não verifica

Os controllers principais registram `CarrinhoRecoveryValidation.reloadAndValidate`; os controllers de carrinho registram leitores. O validador consulta estágios, itens físicos, histórico/cadastro dos carrinhos e, na conferência, agrupamentos.

Da leitura dos itens, conserva apenas percurso, estágio e situação em `CarrinhoRecoveryItem`. Produto, unidade e quantidade não participam dessa validação. As regras detectam combinações como estágio cancelado com item ativo, estágio aberto com FN, cadastro incompatível com a utilização atual e agrupamento incoerente.

Não são verificados:

- Total persistido versus soma das linhas físicas não CA.
- Saldo por produto/unidade ou alocação por linha de demanda.
- Excesso de um produto compensando falta de outro no total geral.
- Intenção incompleta de exclusão, cancelamento ou recuperação quando os registros restantes têm situações válidas.
- Conclusão de todas as etapas de um evento que teve commit e falhou depois no refresh.

O estado estrutural consistente é necessário, mas não suficiente para liberar operação baseada em saldo.

## Cenário de liberação com total errado

Exemplo lógico, não executado: havia 5 UN ativas e total persistido 5. DELETE confirma no banco; atualização do total falha. Restam zero itens, mas o total continua 5.

- Se o erro individual não acionar a recuperação, a barreira não força recarga nem revisão.
- Se acionar, a recarga pode mostrar carrinho vazio e demanda com 5 realizadas. Estágio aberto sem itens e cadastro compatível passam na validação estrutural.
- `_dirty` é limpo; a primeira tentativa seguinte é rejeitada para revisão e limpa `_reviewRequired`.
- A tentativa posterior fica permitida pela barreira, sem reparação do total. O scan pode recusar quantidade por considerar o total antigo; separar/conferir tudo pode ser recusado pelo teste de total geral antes de chegar ao serviço.

No sentido inverso, total persistido menor que o físico pode permitir uma pré-validação de scan com saldo aparente excessivo. As mutações legadas não reservam saldo atomicamente no servidor. O resultado depende do caminho e das regras instaladas; não é garantia de que toda tentativa será gravada.

`addAll` relê registros físicos, mas isso não elimina seus defeitos de abatimento por produto sem unidade e por linha repetida. Nem uma segunda chamada ao botão nem uma nova recarga são reparadores genéricos de saldo.

## Ciclo de vida, eventos e escopo

- `receivedChange` invalida somente quando uma recuperação está em andamento. A revisão é um contador local de mudanças observadas, não versão transacional do documento no servidor. Atualização sem broadcast, evento perdido ou alteração que ocorra depois da leitura pode não ser detectada.
- O registro/remoção de leitores durante uma recarga também altera a revisão. Isso ajuda a não ignorar telas que mudaram, mas não certifica a cobertura dos dados.
- `unregister` remove leitor e validador daquele owner. Como basta haver um leitor e não há vínculo persistido entre pendência e documento, a infraestrutura permite limpar uma pendência usando os leitores que restarem ou forem registrados depois. Não foi demonstrado um caminho normal de navegação que explore isso; é uma lacuna de escopo a cobrir antes de tratar a barreira como reconciliação por operação.
- Fechar/reabrir o processo perde as flags. As validações de entrada existentes não equivalem a recuperar uma intenção pendente durável.
- Listas paginadas, leitores e validadores fazem consultas separadas. Mesmo três tentativas estáveis não garantem snapshot transacional entre dois coletores.

## Proposta de liberação segura, ainda não aplicada

1. **Acionar corretamente a recuperação.** Aplicar a política de resultado incerto para erro de mutação já emitida sem prova de ausência de efeitos, incluindo erro de negócio individual. Não confundir essa correção com consistência de saldo: ela apenas inicia a recuperação necessária.
2. **Vincular a pendência ao escopo.** Registrar empresa/documento/operação e dados necessários para consultar recibo; exigir leitores e validadores que cubram esse escopo. Trocar de tela não deve atestar recuperação de outro documento. Persistir intenções incertas quando houver contrato idempotente.
3. **Separar estados.** Distinguir leitura pendente, leitura incompleta, divergência estrutural, divergência de saldo, revisão do operador e apto a gravar. Uma mensagem “grades atualizadas” deve significar leitura concluída, não reparação concluída. Confirmação do operador não deve contornar divergência detectada.
4. **Validar quantitativos por contrato.** Comparar demanda, total persistido e execução física na mesma granularidade definida: empresa/documento, vínculo de carrinho/estágio, produto/unidade ou linha de origem. Tratar CA, FN, conversão, precisão e linhas repetidas explicitamente. Não comparar somas brutas de unidades diferentes nem exigir igualdade por linha quando o sistema guarda agregado na primeira.
5. **Manter bloqueio se houver divergência.** Conservar diagnóstico das chaves e valores divergentes. Permitir leitura, saída e reconciliação autorizada; não liberar novas ações de saldo só porque as consultas responderam. Não zerar totais locais para parecer consistente.
6. **Reparar no servidor.** Comando transacional de recomposição/consulta de recibo, independente de haver itens no carrinho. Corrigir somente derivados no escopo afetado, mantendo linhas legítimas. Depois consultar snapshot/versão e validar novamente. Não reaplicar a mutação original nem usar INSERT/DELETE de teste para provocar refresh.
7. **Publicar grades coerentes.** Carregar resultados temporários e aplicar conjunto consistente após as leituras necessárias, ou indicar explicitamente recarga parcial. Preservar a barreira em erro e impedir ação sobre mistura de estados. Adotar versão do servidor para snapshots e eventos; contador local não substitui essa versão.
8. **Validar novamente na gravação.** Após recuperação, outro coletor ainda pode alterar o saldo. A operação de domínio no servidor deve conferir estado/versão e reservar saldo atomicamente. A barreira do desktop não é lock distribuído.

No legado, uma verificação cliente pode sinalizar divergências nas granularidades já bem definidas, mas não deve inventar alocação entre linhas ou converter unidades por suposição. A reparação exige a definição de saldo documentada em [Item e totais](./item-totais-concorrencia.md).

## Validação futura (não executada)

Adicionar casos isolados para: total antigo com zero itens; total menor que o físico; linhas repetidas/unidades diferentes; estruturalmente válido mas quantitativamente divergente; leitor inicial aplicado e segundo falhando; validador falhando; mudança durante recarga; ausência de validador obrigatório; troca/fechamento de documento com pendência; reinício; primeira tentativa rejeitada e segunda bloqueada enquanto houver divergência; reparo com versão validada; evento perdido ou atrasado. Os testes existentes de `SocketRecovery` verificam a mecânica de recarga/revisão, não certificam consistência quantitativa do documento.

## Fontes

`lib/src/app/socket_recovery.dart`, `app_socket_config.dart`, `lib/src/repository/socket_event_repository.dart`, `lib/src/service/carrinho_recovery_validation.dart`, controllers `SepararController`, `ConferirController`, `SeparacaoController` e `ConferenciaController`; `test/src/app/socket_recovery_test.dart`.

Servidor `D:\Developer\Node\data7-api-pix Campo`: `src/sql/expedicao/expedicao.item.separar.consulta.sql` e `expedicao.item.conferir.consulta.sql`. Relacionados: [erros após gravação](./erros-pos-gravacao.md), [reconferir tudo](./reconferir-tudo.md), [lotes](./separar-conferir-tudo.md), [concorrência](./concorrencia-idempotencia.md).
