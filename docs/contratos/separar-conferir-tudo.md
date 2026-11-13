# Separar tudo e conferir tudo: saldo, linhas e unidades

Revisão estática em 2026-11-13. Código lido, sem executar aplicativo, API, SQL ou testes reais. Este documento distingue comportamento atual, defeitos encontrados e proposta de correção; não registra uma correção já implementada.

## Caminho atual

| Etapa | Separar tudo | Conferir tudo |
| --- | --- | --- |
| Entrada | `SeparacaoController.onSepararTudo` | `ConferenciaController.onConferirTudo` |
| Bloqueios na tela | `_processando`, modo visualização, comparação de totais da grade e diálogo de identificação | Os mesmos tipos de bloqueio |
| Serviço | `SeparacaoAdicionarItemService.addAll` | `ConferenciaAdicionarItemService.addAll` |
| Demanda | Tabela de itens a separar, empresa + documento inteiro, `allRows` | View de itens a conferir, empresa + documento + carrinho físico, `allRows` |
| Já realizado | Tabela de itens separados, empresa + documento inteiro | Tabela de itens conferidos, empresa + documento + percurso e estágio CO atual |
| Saldo por linha | Quantidade da linha menos soma de todos os registros não CA do mesmo produto | Mesmo cálculo, dentro da seleção de realizados acima |
| Nova linha | SP, unidade da linha de demanda, estágio atual, Item vazio | CF, unidade da linha de demanda, estágio atual, Item vazio |
| Envio/retorno | `insertAll`, releitura da view e verificação de uma linha por Item retornado | Idem; view filtrada pelo carrinho físico |

Os dois serviços ignoram `QuantidadeSeparacao`/`QuantidadeConferida` da demanda no cálculo e somam registros físicos. Isso evita depender diretamente de um total cacheado incorreto, mas não corrige a granularidade do cálculo. A leitura da demanda e a dos realizados são separadas, sem snapshot transacional.

Os modelos de item bipado registram produto, unidade e estágio, mas não uma chave explícita da linha de `ItemSepararEstoque`/`ItemConferir` atendida. O Item novo identifica a própria bipagem, não a linha do pedido. Não há alocação persistida por linha de origem.

## Achados

### 1. A quantidade realizada é descontada várias vezes

Para cada linha `i` do produto, o código calcula `max(0, quantidade[i] - realizadoDoProduto)`. O mesmo realizado é usado em todas as linhas. O lote correto, **se as linhas forem demandas aditivas na mesma unidade**, deve abater o realizado uma única vez da soma da demanda.

Exemplos aritméticos derivados do código, sem execução:

| Demanda do mesmo produto/unidade | Realizado | Novas quantidades atuais | Pendente agregado esperado |
| --- | --- | --- | --- |
| 5 UN + 5 UN | 0 UN | 5 + 5 = 10 UN | 10 UN |
| 5 UN + 5 UN | 3 UN | 2 + 2 = 4 UN | 7 UN |
| 5 UN + 5 UN | 5 UN | nenhuma | 5 UN |
| 2 UN + 8 UN | 3 UN | 0 + 5 = 5 UN | 7 UN |

Logo, repetição de produto não implica excesso em todo caso: com mesma unidade e sem concorrência, este cálculo tende a deixar saldo sem atender. Se a primeira linha de 5 UN de um lote foi gravada e a segunda falhou, a retomada passa a calcular zero para ambas; a recarga e revisão de falha parcial não bastam para completar o lote corretamente.

Não corrigir apenas adicionando um acumulador das novas linhas ao realizado e mantendo a subtração por linha. Isso faria o caso sem realizado de 5 + 5 gerar apenas 5. É necessário agrupar demanda e abater realizado uma vez, ou alocar realizado entre linhas segundo regra explícita.

### 2. Unidades diferentes são misturadas no abatimento

O filtro dos realizados compara produto, não `CodUnidadeMedida`. Não há chamada de conversão nos dois `addAll`. A quantidade calculada é enviada com a unidade da linha corrente.

Exemplo: demanda 10 UN + 2 CX e realizado 2 UN. O algoritmo gera 8 UN e zero CX, embora não haja caixa realizada. No sentido inverso, 1 CX realizada abate numericamente 1 de uma demanda de 10 UN, independentemente do fator. O resultado só seria válido sob uma convenção de unidade comum que esses métodos não verificam.

O scan individual tem outro caminho: resolve o código de conversão, aplica fator e grava a unidade da linha selecionada. Isso não prova que todo documento com unidades distintas já esteja normalizado. Também não se deve aplicar automaticamente o fator de bip às quantidades de demanda: elas podem já estar expressas na unidade da linha, causando dupla conversão.

### 3. Demanda e realizado têm escopos diferentes na conferência

`_getConferirItensCarrinho` busca o carrinho físico pela view. `_getConferenciaItensCarrinho` busca apenas o estágio CO atual. Se houver registros ativos de outro estágio CO do mesmo carrinho/documento, ficam fora do saldo do lote. O refresh do servidor, por sua vez, soma por empresa/documento/carrinho/produto, incluindo estágios que apareçam nesse escopo da view.

Esse cenário exige revisão do histórico permitido; não foi demonstrado em base real. É uma lacuna de escopo que pode permitir nova conferência de quantidade já ativa em outro estágio.

Não igualar os filtros colocando o estágio CO atual em `ItemConferir`: pelas regras 4–6 do servidor, `ItemConferir.ItemCarrinhoPercurso` aponta para o estágio da **separação**. A correspondência entre demanda SE e execução CO precisa ser definida, preservando o carrinho/documento e suas utilizações.

### 4. Atualização visual concentra produtos repetidos numa linha

Após o lote, os controllers usam `Map<int, ...>` por `codProduto`, buscam uma linha com `findCodProduto` e acumulam nela as quantidades retornadas. A unidade e o Item da demanda não entram na chave desse mapa.

Exemplo: duas linhas de 5 UN sem realizado geram 10 UN corretamente no lote, mas o incremento local pode deixar a primeira linha com 10 e a segunda com zero. Unidades diferentes também são acumuladas numericamente nessa mesma linha. O fato de as bipagens estarem presentes na grade do carrinho não comprova distribuição correta na grade de demanda.

O servidor tem limitação semelhante: os refreshes de totais selecionam a primeira linha por produto e não agrupam unidade. Portanto, apenas trocar o incremento local por uma reconsulta não resolve o modelo de total por linha. Ver [Item e totais](./item-totais-concorrencia.md).

### 5. Total geral não prova que todas as linhas foram atendidas

Os controllers recusam a ação quando `totalRealizado >= totalDemanda` na grade. Os métodos `totalQuantity`/`totalQuantitySeparetion` somam todas as linhas, sem separar produto ou unidade.

Mesmo na mesma unidade, demanda P=5 e Q=5 com realizado P=10 e Q=0 passa no critério de conclusão por total geral, embora Q esteja pendente. Com unidades distintas, a soma também perde significado físico. Dados antigos da grade ou totais persistidos incorretos podem recusar o lote antes de o serviço reler as tabelas.

### 6. Regras operacionais que permanecem

- Os lotes não chamam `setorPermitido`. Separar tudo pode incluir outro setor, apesar do filtro no scan individual; conferir tudo também não filtra. Isso já é o comportamento documentado, não autorização para mudar a regra silenciosamente.
- Realizados com situação CA são excluídos; outras situações, inclusive FN, entram na soma. Os serviços não usam a situação do estágio como parte desse filtro de quantidade.
- Saldo não positivo é ignorado. Lista de inserts vazia retorna `[]`; isso não comprova ausência de pendências por linha, como mostram os exemplos.
- Todas as novas linhas vão para o estágio atual. O lote não mantém o Item de origem da demanda no registro de bipagem.
- `runSocketMutation` protege a operação local e sinaliza gravação parcial/incerta. `insertAll` não torna o lote transacional no servidor. Dois coletores ainda podem ler o mesmo saldo e ambos gravar.
- Releitura e comparação dos Items retornados verificam presença das linhas gravadas, não correção de unidade, saldo ou alocação da demanda.

## Proposta de correção, ainda não aplicada

1. **Definir a unidade de saldo e a granularidade.** Se linhas forem aditivas por produto/unidade, agrupar por empresa/documento/produto/unidade (e escopo de carrinho validado na conferência), somar a demanda e subtrair uma única vez o realizado correspondente. Se o negócio exigir unidade canônica, converter ambos os lados com regra versionada, precisão e arredondamento definidos. Não misturar valores brutos de unidades distintas.
2. **Definir alocação por linha quando necessária.** Setor, lote, local ou origem podem impedir agrupar linhas aparentemente iguais. Nesse caso, registrar vínculo da execução com a linha de demanda e consumir seu saldo uma vez. A escolha da primeira linha não constitui regra de alocação. Dados legados sem vínculo exigem reconciliação/política explícita.
3. **Validar escopo da conferência.** Unificar a quantidade ativa considerada pelo comando, refresh e UI, preservando a relação entre estágio SE e estágio CO. Detectar utilizações conflitantes em vez de ignorar silenciosamente o histórico.
4. **Corrigir critérios de UI.** Determinar conclusão pela ausência de saldo positivo em cada grupo/linha válido; não pela soma geral. Aplicar resultado por chave completa ou exibir grupos explícitos, sem `Map` somente por produto. Totais confirmados devem vir do mesmo modelo de saldo do servidor.
5. **Executar a intenção no servidor.** Um comando idempotente de completar saldo deve validar estado, recalcular sob bloqueio, gravar e atualizar totais na mesma transação. O cálculo no app pode servir à prévia, mas não à garantia contra dois coletores. Manter a proteção atual contra reenvio cego enquanto esse contrato não existir.
6. **Preservar regras sem decisão de negócio.** Não introduzir filtragem de setor, conversão cruzada ou distribuição de quantidades entre linhas sem contrato explícito. Estes achados não justificam uma mudança silenciosa no significado do pedido.

Para grupos aditivos já validados, a fórmula proposta é `pendente[g] = max(0, somaDemanda[g] - somaAtiva[g])`. Deduplicar a demanda pela chave física antes de somar evita contar duas vezes a mesma linha repetida por join; não deduplicar linhas físicas diferentes apenas porque têm produto e quantidade iguais.

## Casos para validação futura

O comando **reconferir tudo** é outro fluxo: exclui fisicamente os itens e não chama `addAll`. Ver [limpeza e recomposição após falha parcial](./reconferir-tudo.md) antes de considerar o lote como forma de retomada.

Sem execução nesta revisão: exemplos da tabela; múltiplos produtos com excesso num e falta noutro; mesma unidade em várias linhas/setores; unidades diferentes com fatores M e divisão; quantidade fracionária; origem duplicada por join; CA/FN; outro carrinho da separação; outro estágio CO do mesmo carrinho; lote interrompido após primeira linha; repetição após recarga; dois coletores simultâneos. Verificar saldo físico, distribuição por linha, total persistido e as duas grades, não apenas contagem de inserts.

## Fontes inspecionadas

- `lib/src/service/separacao_adicionar_item_service.dart::addAll` e `conferencia_adicionar_item_service.dart::addAll`/métodos de consulta.
- `lib/src/pages/separacao/separacao_controller.dart::onSepararTudo` e `lib/src/pages/conferencia/conferencia_controller.dart::onConferirTudo`.
- `lib/src/pages/separar/grid/separar_grid_controller.dart` e `lib/src/pages/conferir/grid/conferir_grid_controller.dart`: totais e busca por produto.
- Modelos de itens separados/conferidos e `ExpedicaoConferirItemModel.fromConsulta`.
- Servidor: `src/sql/expedicao/expedicao.item.conferir.consulta.sql`, `docs/expedicao/regras.md` (4–6), refreshes descritos em [Item e totais](./item-totais-concorrencia.md).

Relacionados: [conversão](./conversao-unidade.md), [setor](./setor-estoque.md), [chave de Item](./item-chave.md), [concorrência](./concorrencia-idempotencia.md).
