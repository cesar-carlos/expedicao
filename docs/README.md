# Documentação do coletor

Contratos de lista, consulta e erro deste aplicativo Flutter contra o servidor de expedição (HTTP + Socket.IO).

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs`.
Comece por `docs/comunicacao.md`. Guia dos coletores: `docs/socket/protecoes-cliente.md` (já no servidor / escutar agora / ainda não). Regras 26–27 em `docs/expedicao/regras.md`. Este desktop **já** escuta `servidor.emergencia.listen`. `Where` neste app é lista `{ key, value }`; string SQL legado ainda é aceita no servidor. Handshake **sem token**.

## Contratos

Leia nesta ordem:

1. [Contratos](./contratos/README.md) — o que o coletor manda e o que volta
2. [Consulta Socket.IO](./contratos/consulta-socket.md) — envelope `Where` / `Pagination` / `OrderBy` / `Mutation`
3. [Paginação](./contratos/paginacao.md) — `LIMIT` 1500, `OFFSET/FETCH`, unidade de medida
4. [Where](./contratos/where.md) — `QueryBuilder.buildWhereList()` (`{ key, value }`)
5. [Consultas](./contratos/consultas.md) — catálogo dos eventos; scan do carrinho e `carrinho.percurso.estagio`
6. [Conversão de unidade](./contratos/conversao-unidade.md) — `ConversaoUnidadeMedida.Codigo` (JSON `CodigoBarras`); documento inteiro em memória
7. [Listen da situação](./contratos/listen-situacao.md) — inventário dos listens (separação, conferência e binds sem tela)
8. [Proteções do servidor](./contratos/protecoes-servidor.md) — já no ar; emergência **já neste desktop**; ainda não (regras 26–27)
9. [Chave de Item](./contratos/item-chave.md) — `00001` na tabela, `1` na grade; excluir / separar tudo / conferir tudo
10. [Setor de estoque](./contratos/setor-estoque.md) — separação usa `CodSetorEstoque`; conferência usa `CodSetorConferencia`; `null` ou `0` no usuário ou no item libera
11. [Recuperar carrinho](./contratos/recuperar-carrinho.md) — F11 na tela inicial vs F11 dentro do carrinho; último/penúltimo estágio cancelado
12. [Agrupar carrinho](./contratos/agrupar-carrinho.md) — F6 destino / F7 assistente na conferência; origem `AGRUPADO`, cadastro `LIBERADO`
13. [Modais](./contratos/modais.md) — não usar `Get.back()` no overlay de carregamento
14. [Erros](./contratos/erros.md) — prefixo `[50014]` / `[SQL-CONN]`, `AppError`, snackbar
15. [Consulta HTTP](./contratos/consulta-http.md) — login, usuários e versão (não usam Socket.IO)

## Domínio (já neste repositório)

- [Separação de estoque](./separacao/separacao_estoque_documentation.md) — páginas, controllers e serviços de picking
- [Conferência](./conferencia/README.md) — índice das regras que valem no conferir (setor, listen, item, conversão, agrupar)

## Domínio (servidor)

Regras, situações, triggers, comunicação e proteções ficam na documentação do servidor:

- `docs/comunicacao.md` — HTTP + Socket.IO; emergência na conexão
- `docs/socket/README.md` — catálogo; item 7 = proteções para os coletores
- `docs/socket/listen.md` — o que o servidor emite; canal `servidor.emergencia.listen`
- `docs/socket/protecoes-cliente.md` — guia para agentes deste Flutter e do `exp`
- `docs/expedicao/regras.md` — regra 26 (lista não recusa o pedido) e 27 (emergência; desktop já escuta)
- `docs/expedicao/situacoes.md`
- `docs/expedicao/fluxo-separacao-conferencia.md`
- `docs/expedicao/triggers.md`
- `docs/expedicao/indices.md`
- `AGENTS.md` (servidor) — aponta `docs/socket/protecoes-cliente.md` para os agentes dos coletores

Ponto de entrada neste repositório: [AGENTS.md](../AGENTS.md).
