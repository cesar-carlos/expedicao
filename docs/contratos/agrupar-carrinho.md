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

`CarrinhoAgrupador = 'S'` no cadastro marca um carrinho **tipo agrupador**. Pode ser destino. **Não** entra na lista para ser agrupado em outro.

## Grade do modal

`carrinhosPercurso`: `CodEmpresa` + `CodCarrinhoPercurso` + `Origem` + `CodCarrinho != destino` + `Situacao != CANCELADA`, `allRows` por `ItemCarrinhoPercurso`.

O app ainda filtra:

1. Sem agrupador, **ou** já agrupado **neste** destino (`CodCarrinhoAgrupador`)
2. Situação `AGRUPADO`, `CONFERIDO`, `EMBALANDO` ou `EM ENTREGA` (as duas últimas só visual)
3. `CarrinhoAgrupador != 'S'`

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
2. Cadastro ainda `LIBERADO` — se alguém já reusou o físico, recusa
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
| ESC | Fecha (mesmo efeito do X) |
| F12 | **Consome** o evento — não há confirmar; evita finalizar a conferência atrás |

Sem badge de F12. Listen `carrinho.percurso.agrupamento.*.listen` **não** atualiza esta grade: a tela usa a resposta da mutação. A grade de conferidos atualiza pelo `carrinho.percurso.estagio.update.listen`.

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

1. Conferência `EM CONFERENCIA`, dois carrinhos `CONFERIDO`. F6 no destino, bipar o outro: origem vira `AGRUPADO`, cadastro `LIBERADO`, destino segue `CONFERIDO`.
2. F7 Agrupar tudo: todos os `CONFERIDO` (exceto destino e tipo `S`) entram.
3. Del / F8: só funciona se o físico ainda está `LIBERADO`. Reusar o cadastro em outro documento bloqueia o desagrupar.
4. Documento já `CONFERIDO`: F7 recusa; F6 abre só visualização.
5. Bipar código curto com espaço no `CHAR`: acha o carrinho. Código de outro documento: *não encontrado*.
6. Separação: não há F6/F7 de agrupar.
