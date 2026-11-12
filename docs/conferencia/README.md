# Conferência

Não há um guia de páginas paralelo ao de [separação](../separacao/separacao_estoque_documentation.md). Regras deste coletor que valem na conferência:

1. [Setor](../contratos/setor-estoque.md) — usuário `CodSetorConferencia`, item `CodSetorEstoque`; `null` ou `0` em qualquer lado libera
2. [Listen da situação](../contratos/listen-situacao.md) — insert/quantidade `allEvent: false`; faixa `allEvent: true`
3. [Chave de Item](../contratos/item-chave.md) — `'00001'` na tabela, `'1'` na grade; excluir e conferir tudo
4. [Consultas](../contratos/consultas.md) — `conferir.item.consulta` e `conferencia.item.consulta` exigem `CodCarrinho`
5. [Conversão de unidade](../contratos/conversao-unidade.md) — bip em `ConversaoUnidadeMedida.Codigo`; carga do conferir inteiro ao abrir o carrinho
6. [Agrupar carrinho](../contratos/agrupar-carrinho.md) — F6 destino `CONFERIDO` / F7 assistente; origem vira `AGRUPADO` e o cadastro `LIBERADO`
7. [Modais](../contratos/modais.md) — não usar `Get.back()` no overlay de carregamento

Não há **Recuperar Carrinho** / **Recuperar Itens** na conferência. [Recuperar](../contratos/recuperar-carrinho.md) é só da separação. Agrupar é só da conferência.

Código: `lib/src/pages/conferir/`, `lib/src/pages/conferencia/`.
