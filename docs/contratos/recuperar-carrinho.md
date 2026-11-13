# Recuperar carrinho e itens

Dois botões **F11**, papéis diferentes. Conferência **não** tem recuperação.

| Onde | Botão | O que faz |
| --- | --- | --- |
| Tela inicial (`SepararPage`) | Recuperar Carrinho | Bipa um carrinho **liberado** cujo **último** estágio está **cancelado nesta separação**, abre um estágio novo e copia os itens |
| Dentro do carrinho (`SeparacaoPage`) | Recuperar Itens | Copia os itens do **penúltimo** estágio (cancelado, desta separação) para o carrinho **já aberto** |

Cancelar um carrinho: estágio `CANCELADA`, cadastro `LIBERADO`, itens `CA`. Recuperar **não** reabre o estágio cancelado — grava linhas novas `SP` no estágio atual.

Não confundir com **Reabrir Carrinho** (F6): reabre o **mesmo** estágio finalizado.

Também não confundir com [Reconferir tudo](./reconferir-tudo.md): essa ação faz DELETE físico dos itens do estágio, não gera histórico CA recuperável e não cancela o estágio.

## Recuperar Carrinho (tela inicial)

`SepararController.recuperarCarrinho`. Scan: `CarrinhoDialogView` (mesmo portão de adicionar: cadastro `LIBERADO`).

Permite só se **todas** forem verdadeiras:

1. Documento **não** está `SEPARADO` nem `CANCELADA`
2. Cadastro do carrinho existe e está `LIBERADO`
3. O carrinho já teve estágio (`carrinho.percurso.estagio.select` por `CodEmpresa` + `CodCarrinho`, `OrderBy` percurso + `Item`)
4. O **último** estágio está `CANCELADA`
5. `Origem = SE`
6. `CodOrigem` = `CodSepararEstoque` deste documento

Depois: abrir estágio novo `SEPARANDO` (cadastro `EM SEPARACAO`) → `addRecuperados` → recarregar grade → abrir o carrinho. A sequência compartilha `runSocketMutation`, inclusive as leituras posteriores à gravação.

| Recusa | Mensagem |
| --- | --- |
| Documento `SEPARADO` | *Separação já finalizada, não é possível recuperar carrinho.* |
| Documento `CANCELADA` | *Separação cancelada, não é possível recuperar carrinho.* |
| Sem cadastro | *Carrinho não encontrado* |
| Cadastro ≠ `LIBERADO` | *Carrinho não liberado* |
| Sem estágio | *Carrinho nunca esteve em percurso* |
| Último estágio ≠ `CANCELADA` | *O último estágio do carrinho precisa estar cancelado para recuperar.* |
| Último estágio origem ≠ `SE` | *Origem não é separação* |
| `CodOrigem` de outro documento | *Carrinho de outro documento* |

## Recuperar Itens (dentro do carrinho)

`SeparacaoController.onRecuperarItens`. Não bipa outro carrinho: usa o **mesmo** `CodCarrinho` do estágio aberto.

Permite só se:

1. Carrinho **não** está em visualização
2. Cadastro está `EM SEPARACAO` (é o carrinho aberto agora)
3. Há **pelo menos 2** estágios desse `CodCarrinho`
4. O **penúltimo** está `CANCELADA`
5. Penúltimo `Origem = SE`
6. Penúltimo `CodOrigem` = documento atual (`percursoEstagioConsulta.codOrigem`)
7. A consulta do estágio cancelado devolveu linhas

| Recusa | Mensagem |
| --- | --- |
| Modo visualização | *O carrinho esta em modo de visualização* |
| Cadastro ≠ `EM SEPARACAO` | *Carrinho não esta em separação* |
| Menos de 2 estágios | *Carrinho nunca esteve em percurso anteriores* |
| Penúltimo ≠ `CANCELADA` | *Carrinho não foi cancelado na separação* |
| Origem ≠ `SE` | *Origem do carrinho cancelado não é separação* |
| Outro documento | *O estágio cancelado não pertence a esta separação* |
| Sem linhas no estágio cancelado | *Itens não encontrados no carrinho cancelado* |

## O que entra na cópia (`addRecuperados`)

O serviço relê histórico completo, cadastro, documento, pedido e itens. O destino deve ser o estágio mais recente do mesmo carrinho, aberto (`SEPARANDO`/`EM SEPARACAO`), e a origem deve ser o imediatamente anterior, `CANCELADA`, `SE`, do mesmo documento. Percurso e `Item` são ordenados numericamente. Uma origem vazia ou com qualquer item diferente de `CA` bloqueia a cópia inteira: isso indica cancelamento incompleto. A lista recebida identifica a origem; quantidades e situações são obtidas novamente do servidor.

Para cada combinação de produto + unidade da origem:

1. Ainda está na lista a separar (mesmo produto + unidade)
2. `AppHelper.setorPermitido` (usuário `codSetorEstoque`, item `codSetorEstoque`; `null`/`0` libera)
3. Soma as quantidades canceladas dessa combinação e insere no máximo uma linha `SP` por combinação.
4. Quantidade = `max(0, min(totalCancelado − ativoNoDestino, quantidadePedido − ativoNoDocumento))`. Todos os itens diferentes de `CA` contam nos dois saldos, inclusive `FN`. O pedido continua sendo a primeira linha correspondente de produto + unidade; a permissão de setor é verificada nessa linha.

O abatimento do destino impede repetir a mesma cópia sequencialmente quando ainda existe saldo no pedido. Bipagens manuais equivalentes também abatem o destino: não existe vínculo persistido entre cada item cancelado e sua cópia. Não é possível distinguir automaticamente a origem dessas quantidades. Linhas canceladas no destino não abatem o saldo e podem voltar a ser recuperadas.

Produto fora da lista, de outro setor ou já completo: **pula**, não recusa o lote.

`ItemCarrinhoPercurso` no `select` usa `itemSequenceKey` (`'00001'`). `'1'` não acha a linha.

## Código

| Papel | Dart |
| --- | --- |
| Tela inicial F11 | `SepararController.recuperarCarrinho` |
| Dentro do carrinho F11 | `SeparacaoController.onRecuperarItens` |
| Cópia dos itens | `SeparacaoAdicionarItemService.addRecuperados` |
| Itens do estágio | `SeparacaoConsultaService.getSeparacaoItensCarrinho` |
| Estágios | `CarrinhoPercursoEstagioServices.select` (`CodEmpresa` + `CodCarrinho`) |
| Cancelar (origem da recuperação) | `CarrinhoPercursoEstagioCancelarService` + `SeparacaoCancelarItemService.cancelarAllItensCart` |
| Teste quantidade | `test/src/app/app_helper_grid_item_test.dart` |
| Repetição e retomada | `test/src/service/separacao_recuperacao_service_test.dart` e `separacao_recuperacao_quantidade_test.dart` |

Setor: [setor-estoque.md](./setor-estoque.md). `Item`: [chave de Item](./item-chave.md).

## Falhas parciais e limites

Antes de abrir o estágio, o F11 inicial relê o documento, verifica que a origem ainda é a última utilização e valida cadastro/estágios/itens. Antes da cópia, o serviço repete as verificações no novo destino. Um uso posterior em outro documento impede a cópia.

Se abrir o estágio, copiar parte dos produtos ou gravar um item e perder a leitura seguinte, a operação marca o documento para recuperação. Não há rollback nem repetição automática. Recarregue e revise; com estado consistente, use **Recuperar Itens** no estágio que já foi aberto. O serviço desconta as quantidades presentes e completa apenas o pendente. Se cadastro/estágio/itens estiverem incoerentes, a validação de recuperação bloqueia novas mutações até a correção.

As consultas e gravações continuam separadas. Conforme a regra 16 de `docs/expedicao/regras.md` do servidor, as mutações são autocommit. Dois coletores podem ler o mesmo saldo antes de gravar; as verificações locais não garantem exclusão mútua nem idempotência distribuída. Para eliminar essa corrida é necessário contrato transacional/idempotente no servidor. Testes desta revisão usam somente Socket em memória, sem API/SQL real.

## Roteiro manual (não executado nesta revisão)

1. Separar itens, cancelar o carrinho (Del). Cadastro volta `LIBERADO`. F11 na tela inicial, bipar o mesmo código: abre estágio novo com os itens. Qtd. Separada volta.
2. Documento `SEPARADO` (como na foto): F11 recusa. Não é recuperação de documento finalizado.
3. Abrir um carrinho novo do mesmo código, F11 **Recuperar Itens**: traz o penúltimo cancelado. Visualização recusa.
4. Carrinho que só existiu em conferência (`Origem = CO`): F11 na separação recusa origem.
5. Item de outro setor, usuário setorizado: o item **não** volta no carrinho recuperado.
6. Conferência: não há F11 de recuperar.
