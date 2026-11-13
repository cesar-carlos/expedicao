# Geração de Item e totais sob concorrência

Revisão estática de 2026-11-13, continuação de [concorrência e idempotência](./concorrencia-idempotencia.md). Propostas abaixo **não implementadas**. Nenhuma consulta à API/base, execução de SQL, migração ou teste real. Caminhos `src/` referem-se ao servidor `D:\Developer\Node\data7-api-pix Campo`; caminhos `lib/`, ao desktop.

## Geração atual de Item

Os inserts SQL usam `CASE WHEN @Item = '00000' OR @Item = '' THEN FORMAT(ISNULL(MAX(CAST(Item AS INT)), 0) + 1, '00000') ELSE @Item END`. O cálculo não declara bloqueio serializável. A atomicidade do INSERT não garante exclusividade entre duas leituras do MAX.

| Arquivo em `src/sql/expedicao/` | Escopo do MAX |
| --- | --- |
| `expedicao.item.separacao.insert.sql`, `expedicao.item.separar.insert.sql` | Empresa + documento de separação |
| `expedicao.item.conferencia.insert.sql`, `expedicao.item.conferir.insert.sql` | Empresa + documento de conferência |
| `expedicao.carrinho.percurso.estagio.insert.sql`, `expedicao.carrinho.percurso.agrupamento.insert.sql` | Empresa + percurso |

A busca também encontrou o padrão em `expedicao.item.armazenar.insert.sql` e `expedicao.separacao.usuario.setor.insert.sql`; devem entrar no inventário da migração, sem presumir o mesmo escopo de chave.

Exemplo: A e B observam MAX=7 e tentam Item=8. Conforme índices/isolamento instalados, pode ocorrer disputa de chave ou deadlock. Uma chave única é defesa necessária, mas não decide se a intenção já foi executada. Repetir após erro com novo Item pode duplicar a ação de negócio.

Há outro risco mesmo sem simultaneidade: excluir a maior linha permite reutilizar seu Item no próximo insert. Uma resposta ou evento atrasado pode então se referir à mesma chave de uma linha diferente. A proposta deve impedir reutilização de identificadores já publicados.

### Correção recomendada para a sequência

Manter Item textual por compatibilidade e introduzir contador monotônico por **tipo de entidade + empresa + documento/percurso**. Tipos distintos não devem compartilhar contador por acidente.

1. Criar contador com chave única do escopo. Inicializá-lo a partir do maior Item válido em migração controlada; detectar itens não numéricos, colisões normalizadas (`1`/`00001`) e valores fora do limite. Não calcular o MAX livremente a cada operação.
2. Reservar N valores com incremento atômico e `OUTPUT` do contador, dentro da mesma transação que grava o lote. Tratar criação de contador ausente com bloqueio de intervalo/serialização; `SELECT` seguido de `INSERT` sem proteção repete a corrida.
3. Guardar e devolver os Items efetivamente gravados no recibo idempotente. Não decrementar contador por exclusão. Não exigir ausência de lacunas; rollback de uma reserva ainda não publicada é diferente de reutilizar uma chave já confirmada.
4. Auditar/manter unicidade das chaves completas nas tabelas de destino. Definir tratamento de Item explícito legado/importado: rejeitar no novo comando normal ou reconciliar contador sob o mesmo bloqueio. Não permitir que o caminho legado continue gerando MAX + 1 fora da proteção.
5. Verificar capacidade antes da reserva. FORMAT com máscara de cinco zeros não limita o valor a cinco caracteres. O repositório de conferência passa Item como `VarChar(5)` e o de separação como `VarChar(6)`; o DTO/SQL do estágio usa cinco. O esquema instalado precisa ser inspecionado antes de fixar um limite ou ampliar tipos. Não truncar nem voltar para zero ao esgotar.

Alternativa de transição: bloquear uma linha-pai existente por escopo (`UPDLOCK, HOLDLOCK`) antes do MAX e manter o bloqueio até o commit, ou usar `sp_getapplock` exclusivo com proprietário Transaction e checar o retorno. Isso só serializa os caminhos que seguem o mesmo protocolo; o lock deve preceder leitura/validação/gravação. MAX protegido ainda reutiliza o maior Item excluído, portanto não substitui o contador monotônico.

Uma SEQUENCE global é opção apenas se o negócio aceitar numeração global/lacunas e os tamanhos forem migrados. Não trocar silenciosamente a numeração por documento por uma sequência global.

## Atualização atual dos totais

| Fluxo | Leitura e destino | Problema adicional à corrida |
| --- | --- | --- |
| Separação | `separacao.item.event.ts::refreshItensSepararConsulta` soma ItemSeparacaoEstoque não CA por empresa/documento/produto, lê até cinco linhas do pedido e atualiza a primeira | Não agrupa unidade nem distribui por linha de origem. |
| Conferência | `conferencia.item.event.ts::refreshItensConferirConsulta` chama soma por empresa/documento/carrinho/produto, escolhe primeira linha da consulta e grava QuantidadeConferida | Soma não agrupa unidade; carrinho vem do join com estágio. A consulta usa view com joins de cadastros. |

Fontes: eventos em `src/socket/separacao.item/` e `src/socket/conferencia.item/`; `src/repository/expedicao/sql.server.expedicao.item.separacao.repository.ts::sumQuantidadeAtiva`; `sql.server.expedicao.item.conferencia.consulta.repository.ts::querySumQuantidadeAtiva`.

Os SUM excluem CA e incluem demais situações. Os totais vêm de leituras separadas dos updates. Intercalação possível: A soma 5; B insere, soma 8 e grava 8; A grava 5. As views de pedido selecionam as colunas armazenadas (`QuantidadeSeparacao`/`QuantidadeConferida`), portanto simplesmente recarregar a grade não recompõe um total incorreto.

Os updates `expedicao.item.separar.update.sql` e `expedicao.item.conferir.update.sql` gravam **o DTO inteiro**, não apenas o total. Um refresh baseado em leitura antiga pode também restaurar produto, unidade, quantidade pedida, setor ou vínculo de estágio antigos, conforme o DTO. Trocar por UPDATE somente da coluna derivada reduz esse dano, mas não elimina a corrida do total.

No update do item bipado, os handlers atualizam a linha e chamam refresh com o payload novo. Se produto, documento ou estágio/carrinho mudar, também é necessário recompor o grupo antigo. Os novos comandos devem proibir alterações de identidade não suportadas ou capturar a linha anterior e recalcular a união das chaves antigas/novas. DELETE precisa preservar a chave anterior para zerar o grupo quando sair o último item; cancelamento e reativação também mudam o saldo.

### Correção recomendada para os totais

Escolher e publicar primeiro a granularidade: linha do pedido/snapshot, ou produto em unidade canônica. Definir conversão, precisão/arredondamento, repetição de produto em várias linhas e vínculo com estágio. A soma de quantidades em unidades diferentes não deve ser legitimada apenas porque é o comportamento atual. Usar tipos decimais definidos no contrato para quantidades de negócio; hoje há bindings SQL Float e double no app.

Fluxo proposto de um comando curto no servidor:

1. Iniciar transação real; resolver recibo idempotente e adquirir bloqueios dos recursos envolvidos em ordem determinística (compatível também com a ordem das triggers). Revalidar versões após adquirir os bloqueios. Se as chaves antigas só forem descobertas por leitura prévia, revalidá-las dentro da transação.
2. Ler estado anterior e saldo sob a mesma proteção; validar situação atual, propriedade do carrinho, conversão e teto. Reservar Items quando necessário e aplicar todas as linhas.
3. Recalcular, a partir das tabelas físicas e vínculos necessários, todos os grupos antigos e novos afetados, inclusive totais zero. Evitar joins apenas descritivos que possam multiplicar linhas; conferir unicidade dos joins necessários. Atualizar **somente** colunas derivadas e versão, por chave completa e granularidade definida.
4. Registrar recibo e eventos pendentes, efetuar commit e responder com Items, totais e versão do mesmo resultado. Não fazer a manutenção essencial do total em um refresh posterior ao commit.

Todos os escritores precisam aderir: insert/update/delete, cancelamento, recuperação, finalização, ERP e triggers. Se isso não for viável, centralizar a manutenção no banco com procedimentos/triggers preparados para múltiplas linhas, ou abandonar o cache e calcular o total na consulta. Escolher um responsável, evitando cálculo duplicado Node + trigger. RCSI/SNAPSHOT sozinho não impede duas intenções de consumirem o mesmo saldo.

Alternativas: calcular totais diretamente elimina o cache desatualizado, mas não dispensa reserva/validação do saldo na mutação. Atualização por delta pode ser atômica, porém exige capturar antes/depois, lidar com movimentação/CA/delete e idempotência; repetir `total += quantidade` duplica o efeito. Para os fluxos atuais, recomposição protegida é a proposta inicial mais simples de auditar.

Os repositórios hoje obtêm requests de pool separadamente. A implementação deve receber um contexto transacional comum para leitura, alocação, DML, total e recibo; chamar `beginTransaction` e continuar usando `pool.request()` não coloca esses comandos na transação. Fazer rollback e liberar recursos em erro; retry de deadlock apenas da operação inteira comprovadamente revertida, limitado e preservando a chave. Commit de resultado desconhecido exige consulta do recibo, não repetição cega.

## Ajustes necessários no app_expedicao

| Área | Mudança proposta |
| --- | --- |
| Item | Continuar deixando a geração ao servidor. Manter `itemSequenceKey`/`sameGridItem` e chave composta empresa/documento/Item; não calcular MAX, renumerar nem deduplicar por produto/quantidade. A máscara atual preenche zeros, não valida comprimento máximo. |
| `AppSocketConfig` e repositórios | Adotar comando/capacidade nova com intenção persistida, chave de idempotência, versão esperada e recibo. O contrato atual não aceita essa garantia; manter sem reenvio automático no legado. |
| `SeparacaoAdicionarItemService.addAll` / `ConferenciaAdicionarItemService.addAll` | Hoje calculam saldo por produto, sem unidade, a partir de snapshot local; múltiplas linhas podem partir do mesmo saldo sem considerar o lote em construção. Migrar para intenção de completar saldo validada no servidor, com linhas/unidades explícitas. Não usar o saldo local como autorização final. |
| Recuperação | Usar vínculo persistido com itens cancelados e resultado do comando, substituindo gradualmente a inferência por quantidade equivalente no destino. |
| Grades/listens | Aplicar totais e linhas confirmados com versão por escopo. Descartar evento anterior à versão já aplicada; detectar lacunas e recarregar snapshot. Número de revisão deve vir do servidor e seu escopo precisa estar definido, não de relógio local. |
| Falha parcial/resultado incerto | Preservar as barreiras atuais. Após contrato novo, consultar recibo e reconciliar; não criar nova intenção só porque a resposta ou o broadcast atrasou. |

Deduplicar na grade pela chave não impede uma chave reutilizada de representar outro registro nem corrige um total persistido errado. As correções prioritárias são no servidor/banco; não introduzir campos de contrato ainda inexistentes no app.

## Implantação e critérios de aceite (não executados)

Inventariar chaves, comprimentos, índices, triggers, escritores externos e todos os leitores dos totais; auditar dados e inicializar contadores em janela controlada. Disponibilizar comando versionado e proteção também para caminhos legados antes de anunciar garantia entre coletores. Reconciliar totais históricos sob controle de concorrência. Outras telas/ERP podem depender das colunas atuais; não removê-las sem migração.

Validar futuramente: dois inserts no mesmo escopo e em escopos diferentes; lote com erro na linha N; exclusão do maior Item seguida de insert; Item explícito e limite de comprimento; soma concorrente em ordem invertida; cancelamento/reativação; mudança de produto/carrinho; exclusão do último item; duas unidades e duas linhas de pedido do mesmo produto; commit com resposta perdida; eventos fora de ordem; deadlock/rollback e reinício. Conferir unicidade física, ausência de reutilização, total correto, nenhum campo de negócio sobrescrito pelo refresh e compatibilidade ERP/triggers. Nenhum desses cenários foi executado nesta revisão.
