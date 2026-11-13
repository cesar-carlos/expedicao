# AGENTS

Ponto de entrada para quem altera este coletor desktop (`app_expedicao`).

## Fonte oficial

Contratos **deste app**: `docs/README.md`. Comece por `docs/contratos/README.md`.

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs`.

1. `docs/comunicacao.md` — HTTP + Socket.IO, handshake sem token, emergência na conexão
2. `docs/socket/protecoes-cliente.md` — já no servidor / escutar agora / ainda não (guia dos dois Flutter)
3. `docs/socket/listen.md` — o que o servidor emite; `servidor.emergencia.listen`
4. `docs/expedicao/regras.md` — regra 26 (lista não recusa o pedido) e 27 (emergência; desktop já escuta)

Neste repositório: `docs/contratos/protecoes-servidor.md`.

## Regras em `.cursor/rules/`

- `atalhos-teclado.mdc` — F12 confirma, ESC fecha modal
- `socket-listen.mdc` — `allEvent`, situação, grade sem duplicar
- `protecoes-servidor.mdc` — `servidor.emergencia.listen`, `Where` lista, sem token
- `setor-estoque.mdc`, `item-chave.mdc`, `agrupar-carrinho.mdc`, `recuperar-carrinho.mdc`, `conversao-unidade.mdc`

## Estado (2026-11-13)

- Canal `servidor.emergencia.listen`: **já registrado** (`ServidorEmergenciaService`, `allEvent: true`).
- `Where` vai como lista (`QueryBuilder.buildWhereList()`). Handshake **sem token**.
- Não escuta `separar.consulta.listen` e não refaz a consulta no tick do listen.
- `exp` ainda deve espelhar o listener de emergência.
