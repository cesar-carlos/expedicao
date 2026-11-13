# Exclusão e cancelamento individual de itens

Revisão estática em 2026-11-13. Sem execução de app, API, SQL ou testes reais. Os achados abaixo não foram corrigidos nesta revisão; as propostas exigem implementação e validação próprias.

## Caminhos distintos

| Caminho | Operação | Uso encontrado |
| --- | --- | --- |
| Remover item na grade de separação | `SeparacaoRemoverItemService.remove(item)` → DELETE | Callback `_onRemoveItemSeparacaoGrid` |
| Remover item na grade de conferência | `ConferenciaRemoverItemService.remove(item)` → DELETE | Callback `_onRemoveItemConferenciaGrid` |
| Cancelar item de separação | `SeparacaoCancelarItemService.cancelar(item)` → UPDATE com Situacao CA | Método disponível; nenhuma chamada encontrada em `lib`/`test` nesta revisão |
| Cancelar item de conferência | `ConferenciaCancelarItemService.cancelar(item)` → UPDATE com Situacao CA | Método disponível; nenhuma chamada encontrada em `lib`/`test` nesta revisão |

Os cancelamentos de carrinho usam métodos de lote; não comprovam uso do método individual. Não atribuir ao cancelamento individual a atualização visual do botão excluir. DELETE elimina a linha; CA conserva a linha e a exclui das somas ativas. Não são alternativas intercambiáveis sem decisão de negócio.

Na UI de exclusão há verificação de modo visualização e confirmação. Separação também verifica `setorPermitido` usando o setor do item selecionado. A validação de setor da conferência está comentada por orientação explícita do projeto; esta revisão não a reativa. Os serviços individuais não repetem a validação de setor.

## Seleção, identidade e gravação

Os quatro métodos normalizam Item com `itemSequenceKey` e consultam por empresa + documento + Item. Não incluem percurso/estágio esperado nessa consulta nem chamam `assertLatestStage`. Isso identifica a linha no documento, mas não confirma que ela continua vinculada ao carrinho/estágio apresentado na tela.

Os dois métodos de exclusão e o cancelamento de conferência recusam consulta vazia. O cancelamento de separação percorre a lista vazia e termina normalmente. Nenhum dos quatro exige explicitamente `response.length == 1`; percorrem todos os registros retornados. A unicidade física é esperada, mas não foi verificada no banco.

DELETE no servidor usa empresa/documento/Item, sem condição de versão ou situação anterior. Cancelar relê o DTO, altera apenas Situacao no cliente e envia **o DTO inteiro**; o SQL UPDATE regrava quantidade, produto, unidade, estágio, sessão e dados da bipagem. Assim, uma alteração feita por outro escritor entre SELECT e UPDATE pode ser sobrescrita por valores antigos. Esses métodos não registram separadamente motivo, usuário e instante do cancelamento individual; preservam os campos de autoria da bipagem no DTO.

Marcar novamente CA não diminui novamente a soma física quando a linha permanece inalterada e o total é recomputado excluindo CA. Isso não torna o pedido plenamente idempotente: o UPDATE completo, a ausência de versão, os efeitos de refresh e eventual reutilização de Item continuam relevantes.

Os handlers de DELETE devolvem DTOs solicitados, não `OUTPUT DELETED` com a quantidade efetivamente afetada. Entre a consulta prévia e o DELETE, outro coletor pode já ter removido a linha. A resposta de uma linha não comprova que esta tentativa removeu uma linha. O UPDATE de separação também responde a partir dos DTOs enviados; a conferência relê a view para montar sua resposta, sem fornecer uma versão esperada/recibo idempotente.

## Recomposição visual da exclusão

Depois de `remove` concluir, ambos os controllers:

1. Removem da grade do carrinho o objeto selecionado `el`.
2. Buscam a primeira linha da demanda por `CodProduto`, sem unidade ou Item de origem.
3. Subtraem `el.quantidade` do total dessa linha e limitam o resultado a zero.

Não há releitura autoritativa dos saldos nessa etapa. O serviço relê o registro antes de apagar, mas retorna `void`: a UI continua usando produto, unidade e quantidade do objeto anterior à confirmação. Se o registro mudou nesse intervalo, pode descontar quantidade ou produto errado. O limite mínimo zero oculta a divergência; não a corrige.

Exemplos aritméticos de risco, não testes executados:

| Caso | Resultado possível na UI atual |
| --- | --- |
| Mesmo produto em duas linhas de demanda; a quantidade pertence à segunda | Desconto na primeira; segunda continua realizada apesar da exclusão física. Não há vínculo persistido com a linha da demanda para resolver essa alocação. |
| Produto com linhas UN e CX; excluída uma bipagem de 1 CX | Subtrai numericamente 1 da primeira linha do produto, que pode ser UN. Não converte nem compara unidade. |
| Objeto selecionado tinha 2 UN, registro relido tinha 4 UN | DELETE remove o registro atual, mas a UI desconta 2. |
| Total da primeira linha era menor que a quantidade excluída | UI mostra zero; a diferença não é distribuída/reconciliada com outras linhas. |

O saldo de separação abrange o documento: os registros de outros carrinhos devem continuar contribuindo. Na conferência, o agregado do servidor usa documento/carrinho/produto, enquanto a grade de execução é do estágio atual. A correção precisa preservar as quantidades restantes em todos os escopos pertinentes, não apenas subtrair do primeiro resultado de busca.

O servidor também soma por produto, sem unidade, e atualiza a primeira linha da demanda. Uma reconsulta isolada evita usar o objeto antigo da UI, mas não resolve essa granularidade incorreta nem um agregado persistido desatualizado. Ver [Item e totais](./item-totais-concorrencia.md).

## Falha parcial mesmo com um único item

O DML individual pode ser atômico, mas o evento completo não é: o servidor grava o item, recalcula/grava total e consulta payloads antes de responder. O total e as leituras posteriores não compartilham uma transação com o DML inicial.

| Falha | Consequência e limite atual |
| --- | --- |
| Consulta prévia falha | Nenhuma gravação emitida por esse método; não concluir sucesso. |
| DELETE/CA confirma e refresh falha | Linha já excluída/cancelada, total possivelmente antigo; callback de sucesso não atualiza a UI. |
| Resposta perdida após commit | App marca incerteza e pede recarga/revisão; não reenvia automaticamente. |
| UI falha após retorno do serviço | A operação local do serviço já terminou; o callback de grades não está no mesmo `runSocketMutation`. A falha visual não é automaticamente marcada por esse escopo. |
| Nova tentativa após DELETE aplicado | SELECT vazio produz “item não encontrado”; isso não prova falha do pedido anterior nem repara o total restante. |
| Nova tentativa de CA | Pode reaplicar DTO e disparar refresh; não há recibo que distinga a intenção original de uma nova solicitação. |

Há uma lacuna específica na classificação de erro: `AppSocketConfig.request` marca erro explícito de mutação como incerto para identificadores SQL-*, INTERNAL_ERROR ou lista com mais de um elemento. Um erro de negócio `[500xx]` em mutação individual não atende sozinho a esse critério. Se ele vier de uma gravação posterior de total, após o DELETE/UPDATE inicial já confirmado no banco, o app pode não marcar recuperação. `SocketMutationOperation` só registra confirmação ao receber a resposta mapeada; não enxerga os commits internos do evento que terminou com erro. Essa possibilidade decorre da ordem do handler; não foi reproduzida em base real.

Por isso, o código do erro sozinho não deve ser usado para afirmar “nada gravou”. Um `[500xx]` da trigger do próprio comando inicial e um `[500xx]` de uma etapa posterior têm fronteiras diferentes. O contrato precisa informar a fase/resultado ou tornar a operação inteira atômica.

Recarga e validação atual verificam situações de cadastro/estágio/itens. Um item ausente ou CA em estágio aberto pode ser consistente; o validador não conhece a intenção individual nem recalcula os agregados. Recarregar a demanda pode apenas trazer de volta o total antigo persistido.

## Corridas e repetição

- Checagem de visualização/setor na tela pode ficar desatualizada durante a confirmação; ela não equivale a uma condição SQL.
- Item movido, finalizado ou cancelado por outro coletor entre leitura e gravação não é protegido por versão esperada.
- Como o Item pode ser reutilizado pelo MAX + 1 após exclusão, um DELETE/UPDATE atrasado pela mesma chave pode atingir uma nova linha. Mesmo um DELETE que seria repetível sobre chave imutável não é seguro sob reutilização de identidade.
- Os listens próprios de quantidade/exclusão são filtrados por sessão; o coletor de origem depende do caminho local. Broadcast não substitui recibo nem garante reparação do total após falha do handler.
- Uma nova execução de separar/conferir tudo após recarga ainda sofre o abatimento repetido e a mistura de unidades documentados em [lotes](./separar-conferir-tudo.md). Não usar esse lote como correção automática do saldo.

## Propostas, ainda não implementadas

1. Comando individual de domínio com intenção idempotente, chave imutável, estágio/vínculo e versão esperados. Revalidar situação e permissões no servidor, com política explícita para FN, CA e registro ausente.
2. DELETE ou transição de situação junto da recomposição dos grupos afetados na mesma transação. Para CA, atualizar apenas campos da transição e auditoria definida; não reenviar DTO completo como substituto de controle de concorrência. Devolver estado real, chaves afetadas, totais e versões.
3. Fixar granularidade por linha de demanda ou grupo produto/unidade normalizado, preservando outros carrinhos/estágios. Se houver mudança de produto/unidade/vínculo permitida, recompor os grupos antigos e novos.
4. Substituir a subtração do objeto antigo por resultado confirmado/releitura das duas grades. Abranger gravação e leitura posterior no controle local de recuperação. Se a recarga falhar, manter revisão pendente, sem inventar zero nem descontar novamente.
5. Enquanto o servidor mantiver etapas autocommit, tratar resultado de erro individual com fase desconhecida como potencialmente aplicado e exigir reconciliação, inclusive erro de negócio que possa vir após o DML. Não habilitar retry automático de DELETE/CA para “corrigir o total”.
6. Uniformizar o comportamento de registro ausente nos métodos individuais e exigir correspondência única do alvo. “Já cancelado”, “já excluído” e “não encontrado para esta intenção” precisam de semânticas próprias no recibo; consulta vazia sozinha não distingue esses casos.

## Validação futura (não executada)

Excluir/cancelar item entre linhas repetidas; UN/CX e frações; saldo em outro carrinho; seleção antiga com quantidade/produto alterado; item já CA/FN; linha ausente; dois coletores no mesmo Item; reutilização de chave; falha no DML versus falha de negócio/SQL no refresh posterior; perda de resposta; falha na leitura/atualização visual depois do sucesso. Verificar registros físicos, totais por grupo e ambas as grades, não só a mensagem ou contagem da resposta.

## Fontes

- `lib/src/pages/separacao/separacao_controller.dart::_onRemoveItemSeparacaoGrid` e `lib/src/pages/conferencia/conferencia_controller.dart::_onRemoveItemConferenciaGrid`.
- `lib/src/service/{separacao,conferencia}_{remover,cancelar}_item_service.dart`, `lib/src/app/app_socket_config.dart` e `socket_mutation_operation.dart`.
- Servidor `D:\Developer\Node\data7-api-pix Campo`: handlers `src/socket/{separacao,conferencia}.item/`, repositórios e SQL `src/sql/expedicao/expedicao.item.{separacao,conferencia}.{delete,update}.sql`.

Relacionados: [reconferir tudo](./reconferir-tudo.md), [recuperar carrinho](./recuperar-carrinho.md), [setor](./setor-estoque.md), [concorrência](./concorrencia-idempotencia.md).
