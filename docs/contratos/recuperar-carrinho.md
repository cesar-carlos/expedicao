# Recuperar carrinho e itens

Dois botões **F11**, papéis diferentes. Conferência **não** tem recuperação.

| Onde | Botão | O que faz |
| --- | --- | --- |
| Tela inicial (`SepararPage`) | Recuperar Carrinho | Bipa um carrinho **liberado** cujo **último** estágio está **cancelado nesta separação**, abre um estágio novo e copia os itens |
| Dentro do carrinho (`SeparacaoPage`) | Recuperar Itens | Copia os itens do **penúltimo** estágio (cancelado, desta separação) para o carrinho **já aberto** |

Cancelar um carrinho: estágio `CANCELADA`, cadastro `LIBERADO`, itens `CA`. Recuperar **não** reabre o estágio cancelado — grava linhas novas `SP` no estágio atual.

Não confundir com **Reabrir Carrinho** (F6): reabre o **mesmo** estágio finalizado.

## Recuperar Carrinho (tela inicial)

`SepararController.recuperarCarrinho`. Scan: `CarrinhoDialogView` (mesmo portão de adicionar: cadastro `LIBERADO`).

Permite só se **todas** forem verdadeiras:

1. Documento **não** está `SEPARADO` nem `CANCELADA`
2. Cadastro do carrinho existe e está `LIBERADO`
3. O carrinho já teve estágio (`carrinho.percurso.estagio.select` por `CodEmpresa` + `CodCarrinho`, `OrderBy` percurso + `Item`)
4. O **último** estágio está `CANCELADA`
5. `Origem = SE`
6. `CodOrigem` = `CodSepararEstoque` deste documento

Depois: `adicionarCarrinho` (estágio novo `EM SEPARACAO`) → `addRecuperados` → abre o carrinho.

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

Só item com situação `CA` no estágio cancelado. Para cada um:

1. Ainda está na lista a separar (mesmo produto + unidade)
2. `AppHelper.setorPermitido` (usuário `codSetorEstoque`, item `codSetorEstoque`; `null`/`0` libera)
3. Quantidade = `AppHelper.quantidadeRecuperar` — não estoura o pedido (`quantidadePedido − já separado SP`)

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

Setor: [setor-estoque.md](./setor-estoque.md). `Item`: [chave de Item](./item-chave.md).

## Teste manual

1. Separar itens, cancelar o carrinho (Del). Cadastro volta `LIBERADO`. F11 na tela inicial, bipar o mesmo código: abre estágio novo com os itens. Qtd. Separada volta.
2. Documento `SEPARADO` (como na foto): F11 recusa. Não é recuperação de documento finalizado.
3. Abrir um carrinho novo do mesmo código, F11 **Recuperar Itens**: traz o penúltimo cancelado. Visualização recusa.
4. Carrinho que só existiu em conferência (`Origem = CO`): F11 na separação recusa origem.
5. Item de outro setor, usuário setorizado: o item **não** volta no carrinho recuperado.
6. Conferência: não há F11 de recuperar.
