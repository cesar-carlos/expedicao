# Consulta HTTP

Query PascalCase. Validação Zod no servidor antes do controller. Página: `Page`, `Offset`, `Limit` — as mesmas constantes de [paginação](./paginacao.md).

O coletor de expedição **não** usa estas rotas para carrinho, separar ou conferir. Isso vai por [Socket.IO](./consulta-socket.md).

A conexão HTTP **não** exige token.

Revisado em 2026-11-13 contra `docs/contratos/consulta-http.md` e `docs/http/login-app.md` do servidor. As rotas abaixo são o contrato disponível; não significam que este desktop já as consome.

## Query de página

| Query | Padrão | Regra |
| --- | --- | --- |
| `Page` | 1 | Maior que 0 |
| `Offset` | `(Page - 1) * Limit` | Se vier, substitui o cálculo a partir de `Page` |
| `Limit` | 1500 | Informado pelo cliente é respeitado (teto técnico `SQL_INT_MAX`) |

`Offset` seleciona a página que contém o deslocamento: `page = floor(Offset / Limit) + 1`. O deslocamento efetivo é `(page - 1) * Limit`. Exemplo: `Offset=75&Limit=50` retorna a página 2 a partir de 50. `Offset=0` prevalece sobre `Page`. Enviar múltiplos de `Limit`; não assumir deslocamento arbitrário como no Socket.IO.

## Limitações dos filtros HTTP

Os controllers escolhem o primeiro filtro aplicável; **não** combinam os filtros:

| Rota | Prioridade |
| --- | --- |
| `/usuarios` | `CodUsuario` → `NomeUsuario` → `CodEmpresa` → `Ativo=S` → todos |
| `/expedicao/login-app` | `CodLoginApp` → `Nome` → `Ativo=S` → todos |
| `/expedicao/versaoapp` | `CodVersaoApp` → `NomeApp` → `Ativo=S` → todos |

`Ativo=N` é válido, mas sozinho retorna a lista geral. `NomeUsuario=Joao&Ativo=S` busca pelo nome sem restringir o status. Não usar esses filtros como garantia de autorização ou de seleção exclusiva de ativos/inativos.

## Resposta de lista

```json
{
  "message": "N usuário(s) encontrado(s)",
  "data": [],
  "total": 0,
  "page": 1,
  "limit": 1500,
  "totalPages": 0,
  "offset": 0
}
```

`offset` pode ser omitido conforme a busca, inclusive em `/usuarios` por empresa ou apenas `Ativo=S`. Não exigir esse campo para decodificar a lista.

`total` chama a mesma consulta **sem** página explícita. O helper aplica então o padrão 1500: `total` reflete no máximo 1500 linhas. A página de `data` segue o `Limit` pedido.

Consulta por chave única (`CodUsuario`, `CodLoginApp`, `CodVersaoApp`) devolve `{ "message": "…", "data": { }, "total": 1 }`, sem campos de página. Registro ausente: 404 com `message`. O registro fica em `data`, não na raiz.

Parâmetro inválido: 400 com `message` e `errors[]`. Demais falhas: texto prefixado em `message`. [Erros](./erros.md).

## Rotas

| Método | Caminho | Filtros de negócio |
| --- | --- | --- |
| `GET` | `/usuarios` | `CodUsuario`, `NomeUsuario`, `CodEmpresa`, `Ativo` |
| `GET` | `/expedicao/login-app` | `Nome`, `CodLoginApp`, `Ativo` |
| `POST` | `/expedicao/login-app` | body `Nome`, `Senha` |
| `POST` | `/expedicao/create-login-app` | body `Nome`, `Senha`, `CodUsuario`, `FotoUsuario` |
| `PUT` | `/expedicao/login-app?CodLoginApp=` | `Senha`, `Ativo`, `CodUsuario`, `FotoUsuario` |
| `GET` | `/expedicao/versaoapp` | `NomeApp`, `CodVersaoApp`, `Ativo` |

Não existem `/versaoapp` na raiz nem `/expedicao/consult-login-app`. Login e atualização respondem 200 `{ message, user }`; criação responde 201 com esse mesmo formato. Não confundir `user` dessas operações com `data` das consultas.

`POST` / `PUT` / `DELETE` em `/usuarios` respondem 405. Inclusão de usuário do aplicativo fica em `/expedicao/create-login-app`.

Senha do login-app: bcrypt 12 rounds. A consulta não devolve senha. Foto entra e sai em base64.

Este coletor hoje autentica a tela de login localmente e usa Socket.IO para o restante. As rotas HTTP existem no servidor para o outro cliente e para cadastro.

Uso HTTP confirmado neste desktop: `AppClientHttp.ping` chama `GET /health` na configuração da API. O 200 confirma que o HTTP responde; **não** testa banco, handshake Socket.IO nem permissão de negócio. O cliente usa 8 s para conexão e 20 s para envio/leitura; o ping usa 8 s também para envio/leitura.

Carrinho, separação e conferência usam Socket.IO. `/expedicao/separacao` e `/expedicao/conferir`, sem `/notify`, respondem 501; não são fallback HTTP para falha do socket.

`POST /internal/sockets/emergencia` é loopback do operador: emite `servidor.emergencia.listen`. Este coletor **não** chama essa rota — só escuta o Socket.IO. [Proteções](./protecoes-servidor.md).
