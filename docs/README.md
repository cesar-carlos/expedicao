# Documentação do coletor

Contratos de comunicação, consulta, mutação e erro deste aplicativo Flutter desktop (`app_expedicao`) contra o servidor de expedição (HTTP + Socket.IO).

## Revisão de integração — 2026-11-13

Comparação com `comunicacao.md`, contratos HTTP/Socket/Where, `socket/listen.md`, `socket/protecoes-cliente.md` e regras de expedição do servidor, conferida com `AppSocketConfig` e `AppClientHttp` deste app. O outro Flutter, `app/exp`, é um consumidor separado; seu estado citado pelo servidor não foi auditado nesta revisão.

Achados incorporados:

- [Recuperação de grades e totais](./contratos/recuperacao-grades-totais.md): recarga bem-sucedida pode liberar nova tentativa com agregado incorreto; faltam validação quantitativa e vínculo da pendência ao documento. Propostas documentadas, sem alteração funcional ou teste real.

- [Erros após gravação](./contratos/erros-pos-gravacao.md): distinção entre commit no banco e confirmação no app; classificação incompleta de erro individual, limites dos testes existentes e proposta de reconciliação conservadora. Sem mudança funcional nesta revisão.

- [Excluir/cancelar item](./contratos/excluir-cancelar-item.md): desconto da quantidade antiga na primeira linha do produto, ausência de controle de versão e lacuna de classificação de erro após commit individual. Revisão documental, sem implementação ou teste real.

- [Reconferir tudo](./contratos/reconferir-tudo.md): exclusão física em vez de CA, zeragem visual indevida, limites da recuperação parcial e risco de apagar bipagens posteriores na repetição. Revisão estática; propostas não implementadas.

- [Separar tudo / conferir tudo](./contratos/separar-conferir-tudo.md): abatimento repetido da quantidade ativa por linha, mistura de unidades, concentração do total na primeira linha do produto e diferenças de escopo na conferência. Revisão estática; correções propostas, sem execução real.

- [Item e totais](./contratos/item-totais-concorrencia.md): propostas para alocação monotônica, manutenção transacional de totais, proteção contra sobrescrita por DTO antigo e adoção de versões no desktop. Não implementadas nem executadas na base.

- [Concorrência e idempotência](./contratos/concorrencia-idempotencia.md): revisão estática de dois coletores; infraestrutura transacional não exposta no contrato, ausência de recibo idempotente, disputa de Item e agregados. Sem testes reais ou confirmação da instalação das triggers no banco.

- [HTTP](./contratos/consulta-http.md): rota correta `/expedicao/versaoapp`, envelopes `data`/`user`, prioridade dos filtros, arredondamento de `Offset` e limites do `/health`.
- [Socket.IO](./contratos/consulta-socket.md): ciclo de pedidos, dedup apenas de consultas, mutações autocommit e necessidade de reconciliar o estado antes de repetir gravação sem resposta.
- [Where](./contratos/where.md) e [erros](./contratos/erros.md): warn de SQL legado não é falha, limite de parâmetros distinto da paginação e timeout local distinto de `[SQL-CONN]`.
- [Listen](./contratos/listen-situacao.md): ausência de broadcast de criação pela trigger e limites da recuperação após reconexão.

Implementado após a revisão: recarga do documento ativo e do carrinho aberto após reconexão; barreira de gravação que consulta o estado persistido após mutação sem resposta e interrompe a tentativa montada antes da recarga. Detalhes e limites: [Socket.IO](./contratos/consulta-socket.md#recuperação-da-conexão-e-gravação-incerta). Os testes simulam queda, resposta perdida, erro de lote e emergência sem gravar no servidor real. A validação operacional com dois coletores permanece necessária. Emergência global, `Where` lista, handshake sem token e ausência de reconsulta por tick do listen foram preservados.

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
