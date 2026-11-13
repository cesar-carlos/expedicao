# Agrupar carrinho

Só **conferência**. Separação não agrupa.

Junta carrinhos já `CONFERIDO` num **destino**. Não copia nem move `ItemConferencia`. O estágio de origem vira `AGRUPADO`, o cadastro físico volta `LIBERADO` e grava `CarrinhoPercursoAgrupamento` apontando para o destino. O destino **permanece** `CONFERIDO`.

Não confundir com **salvar** o carrinho (F10: `CONFERINDO` → `CONFERIDO`) nem com **cancelar** (Del na grade de conferidos).

## Duas entradas

| Onde | Atalho | Papel do carrinho |
| --- | --- | --- |
| Grade de conferidos (`ConferidoCarrinhosController.groupCart`) | F6 na linha, ou F6 na tela | O carrinho **selecionado** (ou o primeiro `CONFERIDO`) é o **destino** |
| Cabeçalho da conferência | F7 Assistente | Bipa o **destino** neste documento, depois abre o mesmo modal |

O assistente recusa se o **documento** já está `CONFERIDO` / `CANCELADA` / `EMBALANDO` / `EMBALADO` / `EM ENTREGA` / `ENTREGUE`. F6 no destino `CONFERIDO` ainda abre o modal em **visualização** quando o documento não está aberto (`EM ANDAMENTO` ou `EM CONFERENCIA`).

## Destino

O assistente (`faindCart`) consulta `carrinho.percurso.agrupamento.consulta` com `CodEmpresa` + `Origem` + `CodOrigem` + `CodigoBarrasCarrinho` (**equals**, não `LIKE`) e `Situacao != CANCELADA`.

Permite só se:

1. Achou o código **neste** conferir
2. Situação do estágio = `CONFERIDO`

| Recusa | Mensagem |
| --- | --- |
| Sem linha | *Carrinho não encontrado.* |
| Situação ≠ `CONFERIDO` | *Carrinho não disponível* / *O carrinho informado com situacao …* |
| Documento já fechado (só F7) | *Conferencia …, não é possível agrupar.* |
| F6 em estágio ≠ `CONFERIDO` | *Não é possível agrupar um carrinho que estaja …* |

`CarrinhoAgrupador = 'S'` **não é um tipo fixo no cadastro**. A view calcula esse indicador quando existem vínculos não cancelados apontando para o carrinho como destino, na mesma empresa, percurso e origem. Esse carrinho pode continuar recebendo origens, mas não pode ser agrupado em outro enquanto tiver vínculos ativos. Sem esses vínculos, o indicador volta a `N`.

## Grade do modal

`carrinhosPercurso`: `CodEmpresa` + `CodCarrinhoPercurso` + `Origem` + `CodOrigem` + `CodCarrinho != destino` + `Situacao != CANCELADA`, `allRows` por `ItemCarrinhoPercurso`.

O app ainda filtra:

1. Sem agrupador, **ou** já agrupado **neste** destino (`CodCarrinhoAgrupador`)
2. Situação `AGRUPADO`, `CONFERIDO`, `EMBALANDO` ou `EM ENTREGA` (as duas últimas só visual)
3. `CarrinhoAgrupador != 'S'` (não é destino de vínculos ativos)

Agrupar de verdade só aceita `CONFERIDO`.

## Scan no modal

Bipa um carrinho **da grade** (não o destino). Comparar com `AppHelper.sameBarCode` (trim; `CHAR` no SQL traz espaço).

| Recusa | Mensagem |
| --- | --- |
| Código vazio | *Valor invalido!* |
| Fora da grade | *Carrinho não encontrado na lista de carrinhos disponiveis para agrupamento!* |
| Já `AGRUPADO` | *Carrinho já agrupado!* |
| ≠ `CONFERIDO` | *Não é possível agrupar um carrinho que esteja …* |

## O que a mutação grava

### Agrupar um (`agruparCarrinho`)

1. Recusa destino = origem, `CarrinhoAgrupador = 'S'`, situação ≠ `CONFERIDO`
2. Cadastro da origem → `LIBERADO`
3. `CarrinhoPercursoEstagio` da origem → `AGRUPADO` (`Item` com `itemSequenceKey`)
4. Insert agrupamento com `Item = '00000'` (sentinela `MAX+1`), `CodCarrinhoAgrupador` = destino, origem `CO`

Itens conferidos **ficam** no estágio agrupado. O físico fica livre para outro uso.

### Agrupar tudo (F7 no modal)

Consulta `CarrinhoAgrupador = 'N'` + `Situacao = CONFERIDO` (exceto o destino) e chama `agruparCarrinho` em cada um.

### Desagrupar um (`cancelarAgrupamento`)

1. Estágio tem de ser `AGRUPADO` e `ItemAgrupamento` preenchido
2. Cadastro ainda `LIBERADO` **e** estágio ainda é o último uso da origem; o destino também precisa continuar no último uso validado. `LIBERADO` sozinho não basta: o físico pode ter sido usado em outro documento e liberado novamente
3. Estágio → `CONFERIDO`
4. Agrupamento → `CANCELADA` (`Item` = `itemSequenceKey(ItemAgrupamento)`)
5. Insert `expedicao.cancelamento` com `Origem = AG`
6. Cadastro → `CONFERIDO`

### Desagrupar tudo (F8)

Linhas `AGRUPADO` deste destino, depois recarrega os `CONFERIDO`.

| Recusa | Mensagem |
| --- | --- |
| Cadastro ≠ `LIBERADO` | *Carrinho não removido* — *não está liberado para cancelamento* |
| Sem `ItemAgrupamento` | *Agrupamento não encontrado* |
| Visualização | *Operação não permitida em modo de visualização!* |

## Atalhos no modal

| Tecla | Ação |
| --- | --- |
| F6 | Agrupar a linha (selecionada, senão o primeiro `CONFERIDO`) |
| Del | Desagrupar a linha (selecionada, senão o primeiro `AGRUPADO`). Ignorado se o scan tem foco |
| F7 | Agrupar tudo |
| F8 | Desagrupar tudo |
| ESC | Fecha (mesmo efeito do X e do botão Fechar) |
| F12 | Fecha o modal — agrupar já gravou; consome o evento para não finalizar a conferência atrás |

Sem badge de F12 no botão Fechar. Listen `carrinho.percurso.agrupamento.*.listen` **não** atualiza esta grade: em operação normal, a tela usa a resposta da mutação. A grade de conferidos atualiza pelo `carrinho.percurso.estagio.update.listen`. Na recuperação, o modal relê destino e lista e substitui as linhas (inclusive lista vazia); remove seu callback ao fechar e ignora resultados tardios.

## `Item` / código de barras

Tabela guarda `'00001'`. `select` / `update` / insert sentinela usam `AppHelper.itemSequenceKey`. Grade compara com `sameGridItem`.

Scan: `equals('CodigoBarrasCarrinho', …)` no assistente; `sameBarCode` na grade. Não `LIKE '%…%'` — pega prefixo de outro carrinho e, em `CHAR`, falha no espaço à direita.

## Código

| Papel | Dart |
| --- | --- |
| F6 destino | `ConferidoCarrinhosController.groupCart` |
| F7 assistente | `CarrinhosAgruparAssistenteController.faindCart` |
| Modal | `CarrinhosAgruparController` |
| Grade | `CarrinhosAgruparGridController` |
| Mutação | `CarrinhoPercursoEstagioAgruparService` |
| Consulta | `carrinho.percurso.agrupamento.consulta` |
| Tabela | `carrinho.percurso.agrupamento.insert` / `.update` / `.select` |

`Item`: [chave de Item](./item-chave.md). Scan do cadastro (outra tela): [consultas](./consultas.md).

## Teste manual

Roteiro para execução futura; **não executado nesta revisão**.

1. Conferência `EM CONFERENCIA`, dois carrinhos `CONFERIDO`. F6 no destino, bipar o outro: origem vira `AGRUPADO`, cadastro `LIBERADO`, destino segue `CONFERIDO`.
2. F7 Agrupar tudo: todos os `CONFERIDO` elegíveis (exceto destino e carrinhos com indicador `S`) entram.
3. Del / F8: só funciona se o físico ainda está `LIBERADO`. Reusar o cadastro em outro documento bloqueia o desagrupar.
4. Documento já `CONFERIDO`: F7 recusa; F6 abre só visualização.
5. Bipar código curto com espaço no `CHAR`: acha o carrinho. Código de outro documento: *não encontrado*.
6. Separação: não há F6/F7 de agrupar.

## Revisão de integridade — 2026-11-13

### Regras identificadas no código e esclarecidas

| Regra | Evidência e efeito |
| --- | --- |
| `CarrinhoAgrupador` é derivado dos vínculos ativos | SQL do servidor `src/sql/expedicao/expedicao.carrinho.percurso.agrupamento.consulta.sql`: conta vínculos não cancelados por empresa, percurso, origem e destino. Não é configuração permanente do cadastro |
| A situação da view pode esconder divergência do estágio | O SQL usa `COALESCE(cpa.Situacao, cpe.Situacao)`. Por isso o serviço agora consulta também a tabela de estágio antes de gravar, sem confiar só na situação exibida |
| Um destino com origens ativas não pode virar origem de outro agrupamento | `agruparCarrinho` recusa indicador `S`; evita encadear um grupo em outro. O destino pode receber mais origens, desde que continue `CONFERIDO` e não possua vínculo como origem |
| Todos os participantes pertencem à mesma conferência | O serviço valida empresa/percurso do contexto, `Origem = CO` e igualdade de `CodOrigem` entre origem e destino. As consultas de lista e lote também incluem `CodOrigem` |
| Desagrupar usa a chave do vínculo, não a chave do estágio | `ItemAgrupamento` identifica o registro cancelado; `ItemCarrinhoPercurso` identifica o estágio. A tabela deve confirmar esse vínculo ativo, a origem `CO` e o mesmo destino antes da alteração |
| Vínculo ativo único por estágio | A view deve devolver uma linha exata para o participante. A recuperação recusa vínculos ativos duplicados, estágio `AGRUPADO` sem vínculo ou vínculo ainda ativo com estágio já `CONFERIDO` |
| A origem física fica reutilizável; os itens não mudam de lugar | Agrupar libera o cadastro, altera estágio e insere vínculo. Não insere, atualiza, move nem exclui `ItemConferencia` |
| O cancelamento tem registro de auditoria próprio | Desagrupar grava `expedicao.cancelamento` com `Origem = AG`, percurso em `CodOrigem`, chave do agrupamento em `ItemOrigem`, usuário do processo e data/hora atuais |
| Os comandos “tudo” são sequenciais | Cada carrinho usa as mesmas verificações da ação individual. Uma falha interrompe o laço; não desfaz anteriores, não inicia posteriores e não repete o lote automaticamente |
| A consulta final de desagrupar tudo não é recibo exato das linhas alteradas | Recarrega os `CONFERIDO` do contexto, exceto o destino; pode incluir carrinhos que já estavam conferidos antes da ação |

As regras de interface (situação do documento, modo de visualização, atalhos e filtro da grade) continuam descritas acima. A revisão reforçou no serviço as regras de escopo, estado persistido, vínculo ativo e último uso, para que a validação não dependa somente da linha da grade.

### Reutilização e dados antigos na tela

Antes da primeira gravação, o serviço relê as linhas exatas da origem e do destino, o cadastro e o estágio. Ambos precisam continuar no último uso encontrado no histórico completo do carrinho, incluindo cancelados, ordenado por percurso e `Item` numérico. Uma origem reutilizada e depois liberada novamente continua sendo recusada, mesmo que seu cadastro esteja `LIBERADO`; um destino reutilizado também impede a ação.

Para agrupar, os cadastros de origem e destino precisam estar `CONFERIDO`, os estágios precisam estar `CONFERIDO` e a origem não pode ter vínculo ativo. Para desagrupar, a origem precisa estar `AGRUPADO`, com cadastro `LIBERADO`; destino permanece `CONFERIDO`. Se o vínculo mudou desde a seleção da linha, a tentativa é recusada antes das gravações.

### Falhas parciais e recuperação

A ordem das gravações permanece a listada acima: agrupar tem três commits; desagrupar tem quatro. Não existe transação única, compensação automática ou replay. Falha após uma confirmação marca a ação como parcial e exige releitura antes de qualquer nova mutação.

A recuperação do documento de conferência compara também `CarrinhoPercursoAgrupamento` com os estágios. Um estágio `AGRUPADO` exige exatamente um vínculo ativo. Um vínculo ativo exige estágio compatível e destino distinto, no mesmo documento/percurso, em situação compatível. Estágios que avançaram para `EMBALANDO`, `EMBALADO`, `EM ENTREGA` ou `ENTREGUE` são preservados como estados posteriores, sem tentar desfazer o fluxo. Vínculos cancelados não contam como ativos.

O modal aberto participa da recarga: substitui a grade, atualiza nome/código/situação do destino e passa a visualização se ele deixou de estar `CONFERIDO`. O callback é removido ao fechar. O histórico antigo continua consultável quando o físico foi reutilizado, mas isso não autoriza alterar seu cadastro atual.

Se a releitura detectar divergência, mantém o bloqueio e orienta regularização no servidor. Não é possível provar que a auditoria de cancelamento foi gravada apenas pela situação final das tabelas. Tampouco a releitura elimina a corrida entre verificar e gravar: outro coletor pode alterar o carrinho nesse intervalo. A garantia completa exige validação atômica e idempotência no servidor.

### Evidência local

`test/src/service/carrinho_agrupamento_recovery_test.dart` executa os serviços/repositórios com socket em memória: caminhos completos, falha em cada gravação, falha no segundo carrinho dos comandos “tudo”, reutilização da origem e do destino com cadastro aparentemente compatível, documento divergente, vínculo ativo indevido e duplicidade de vínculo. Também verifica a recuperação das falhas parciais e a ausência de mutações de itens/destino.

Suíte completa: **187 testes locais aprovados**. Não foram executados testes reais, gravações SQL ou chamadas à API de testes.
