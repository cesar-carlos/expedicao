# Contratos de paginação e consulta

O coletor não fala SQL direto com o banco. Toda lista passa pelo servidor: Socket.IO para expedição. O servidor oferece HTTP para login/usuários/versão; neste desktop, o uso HTTP confirmado é o `/health` na configuração da API. [Contrato HTTP](./consulta-http.md).

Esta pasta descreve o contrato **deste app**: o que montamos em Dart, o canal do pedido, a página que o servidor aplica e como o erro chega na tela.

Fonte no servidor: `D:\Developer\Node\data7-api-pix Campo\docs\contratos`. Comunicação: `docs/comunicacao.md`. Proteções: `docs/socket/protecoes-cliente.md`. Dois Flutter consomem o mesmo servidor. Mudança de nome de evento ou de envelope quebra os dois.

## Leia nesta ordem

1. [Consulta Socket.IO](./consulta-socket.md) — envelope, canal `${socket.id} <evento>`, `Data` / `Error`
2. [Paginação](./paginacao.md) — sem `LIMIT` o servidor corta em 1500
3. [Where](./where.md) — `QueryBuilder.buildWhereList()` e operadores
4. [Consultas](./consultas.md) — eventos `*.consulta` / `*.select` / `*.listen` usados aqui
5. [Conversão de unidade](./conversao-unidade.md) — `Codigo` no banco, `CodigoBarras` no JSON; carga do documento; bip
6. [Listen da situação](./listen-situacao.md) — inventário de todos os `*.listen`; insert/quantidade `allEvent: false`; faixa `allEvent: true`
7. [Proteções do servidor](./protecoes-servidor.md) — já no ar; emergência **já neste desktop**; ainda não. Fonte: `docs/socket/protecoes-cliente.md`. Regras 26–27
8. [Chave de Item](./item-chave.md) — `itemSequenceKey` / `sameGridItem`; excluir e separar/conferir tudo
9. [Setor de estoque](./setor-estoque.md) — separação `CodSetorEstoque`; conferência `CodSetorConferencia`; `null`/`0` libera
10. [Recuperar carrinho](./recuperar-carrinho.md) — F11 tela inicial (último estágio cancelado) vs F11 no carrinho (penúltimo)
11. [Agrupar carrinho](./agrupar-carrinho.md) — F6 destino / F7 assistente; só conferência; não move item
12. [Modais](./modais.md) — `Navigator.pop` / `DialogCloseGuard`; `Get.back()` não fecha loading
13. [Erros](./erros.md) — `AppError.fromSocket` / `display`
14. [Consulta HTTP](./consulta-http.md) — `Page`, `Offset`, `Limit`
15. [Concorrência e idempotência](./concorrencia-idempotencia.md) — dois coletores, autocommit, riscos de duplicação e contrato ainda necessário
16. [Item e totais sob concorrência](./item-totais-concorrencia.md) — contador monotônico, recomposição transacional, versões e ajustes propostos no desktop
17. [Separar tudo / conferir tudo](./separar-conferir-tudo.md) — abatimento repetido, unidades, escopo de carrinho e distribuição visual
18. [Reconferir tudo](./reconferir-tudo.md) — exclusão física, limpeza parcial, totais restantes e concorrência
19. [Excluir/cancelar item](./excluir-cancelar-item.md) — saldo individual, seleção antiga, unidades e erro após commit
20. [Erros após gravação](./erros-pos-gravacao.md) — commit sem resposta de sucesso, lacuna em erro de negócio individual e política proposta
21. [Recuperação de grades e totais](./recuperacao-grades-totais.md) — limites da validação estrutural e liberação com agregado persistido inconsistente

## Código neste app

| Contrato | Dart |
| --- | --- |
| Envelope de consulta | `AppSocketConfig.queryMapped` (`Where` lista). `SendQuerySocketModel` é DTO legado (Where string) |
| Envelope de mutação | `lib/src/model/send_mutation_socket_model.dart`, `send_mutations_socket_model.dart` |
| `Where` / `OrderBy` / página | `lib/src/model/pagination/query_builder.dart` |
| `LIMIT` / `OFFSET` / `PAGE` | `lib/src/model/pagination/pagination.dart` |
| Junta páginas de 500 | `lib/src/model/pagination/paged_query.dart` (`QueryBuilder.allRows`) |
| Conexão | `lib/src/app/app_socket_config.dart` (`queryMapped` / `mutateMapped`) |
| HTTP | `lib/src/app/app_client_http.dart` |
| Erro | `lib/src/app/app_error.dart` |
| Pedido de lista | `lib/src/repository/**/*_repository.dart` — `queryMapped` / `mutateMapped` |
| Broadcast | `lib/src/repository/socket_event_repository.dart` — `*_event_repository.dart` escuta `<evento>.listen` |
| Emergência do servidor | `ServidorEmergenciaService` — `servidor.emergencia.listen`, `allEvent: true` |
| Situação + `allEvent` | `lib/src/app/app_socket_listen_log.dart`, `aplicarSituacao` em `SepararController` / `ConferirController` |
| `Item` `00001` vs `1` | `lib/src/app/app_helper.dart` (`itemSequenceKey`, `sameGridItem`) |
| Conversão `Codigo` | `AppHelper.conversaoCodigo` / `sameBarCode`; `_itemUnids` no grid |
| Setor estoque / conferência | `AppHelper.setorPermitido`; usuário `codSetorEstoque` ou `codSetorConferencia` |
| Recuperar carrinho / itens | `SeparacaoAdicionarItemService.addRecuperados`; F11 tela vs F11 no carrinho |
| Agrupar carrinho | `CarrinhoPercursoEstagioAgruparService`; F6 destino, F7 assistente |
| Fechar modal | `lib/src/app/app_dialog_close.dart` — não usar `Get.back()` no loading |
| Snackbar | `LoadingProcessDialogGenericWidget` usa `AppError.display` |

## Três papéis

| Papel | Sufixo | Canal de pedido | Resposta |
| --- | --- | --- | --- |
| Consulta | `*.consulta` ou `*.select` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Data` |
| Mutação | `*.insert` / `*.update` / `*.delete` | `${socket.id} <evento>` | `Session`, `ResponseIn`, `Mutation` + broadcast `*.listen` |
| Escuta | `*.listen` | o coletor **não** emite; só escuta o nome do canal | payload da família daquele canal |

`consulta` lê a view (joins, nomes, totais). `select` lê a tabela física. Os dois usam o mesmo envelope.

A conexão **não** exige token (regra 26). HTTP e Socket.IO aceitam qualquer origem. Não preencher `handshakeAuth` até o servidor migrar. Emergência: [proteções](./protecoes-servidor.md).
