# Documentação do coletor

Contratos de lista, consulta e erro deste aplicativo Flutter contra o servidor de expedição (HTTP + Socket.IO).

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs`.
Comece por `docs/comunicacao.md`. `Where` das consultas no servidor é lista `{ key, value }`; string SQL é recusada.

## Contratos

Leia nesta ordem:

1. [Contratos](./contratos/README.md) — o que o coletor manda e o que volta
2. [Consulta Socket.IO](./contratos/consulta-socket.md) — envelope `Where` / `Pagination` / `OrderBy` / `Mutation`
3. [Paginação](./contratos/paginacao.md) — `LIMIT` 1500, `OFFSET/FETCH`, unidade de medida
4. [Where](./contratos/where.md) — `QueryBuilder` neste app (ainda string SQL) e o que o servidor aceita
5. [Consultas](./contratos/consultas.md) — catálogo dos eventos; scan do carrinho e `carrinho.percurso.estagio`
6. [Erros](./contratos/erros.md) — prefixo `[50014]` / `[SQL-CONN]`, `AppError`, snackbar
7. [Consulta HTTP](./contratos/consulta-http.md) — login, usuários e versão (não usam Socket.IO)

## Domínio (já neste repositório)

- [Separação de estoque](./separacao/separacao_estoque_documentation.md) — páginas, controllers e serviços de picking

## Domínio (servidor)

Regras, situações, triggers e índices ficam na documentação do servidor:

- `docs/expedicao/regras.md`
- `docs/expedicao/situacoes.md`
- `docs/expedicao/fluxo-separacao-conferencia.md`
- `docs/expedicao/triggers.md`
- `docs/expedicao/indices.md`
