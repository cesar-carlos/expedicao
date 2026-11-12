# Consulta HTTP

Query PascalCase. Validação Zod no servidor antes do controller. Página: `Page`, `Offset`, `Limit` — as mesmas constantes de [paginação](./paginacao.md).

O coletor de expedição **não** usa estas rotas para carrinho, separar ou conferir. Isso vai por [Socket.IO](./consulta-socket.md).

A conexão HTTP **não** exige token.

## Query de página

| Query | Padrão | Regra |
| --- | --- | --- |
| `Page` | 1 | Maior que 0 |
| `Offset` | `(Page - 1) * Limit` | Se vier, substitui o cálculo a partir de `Page` |
| `Limit` | 1500 | Informado pelo cliente é respeitado (teto técnico `SQL_INT_MAX`) |

## Resposta de lista

```json
{
  "data": [],
  "total": 0,
  "page": 1,
  "limit": 1500,
  "totalPages": 0,
  "offset": 0
}
```

`GET /usuarios` inclui `offset`. Login e versão podem omitir `offset` e manter `totalPages`.

`total` chama a mesma consulta **sem** página explícita. O helper aplica então o padrão 1500: `total` reflete no máximo 1500 linhas. A página de `data` segue o `Limit` pedido.

Consulta por chave única (`CodUsuario`, `CodLoginApp`) devolve um registro, sem envelope de página.

Parâmetro inválido: 400 com `message` e `errors[]`. Demais falhas: texto prefixado em `message`. [Erros](./erros.md).

## Rotas

| Método | Caminho | Filtros de negócio |
| --- | --- | --- |
| `GET` | `/usuarios` | `CodUsuario`, `NomeUsuario`, `CodEmpresa`, `Ativo` |
| `GET` | `/expedicao/login-app` | `Nome`, `CodLoginApp`, `Ativo` |
| `POST` | `/expedicao/login-app` | body `Nome`, `Senha` |
| `POST` | `/expedicao/create-login-app` | body `Nome`, `Senha`, `CodUsuario`, `FotoUsuario` |
| `PUT` | `/expedicao/login-app?CodLoginApp=` | senha, ativo, foto |
| `GET` | `/versaoapp` | `NomeApp`, `CodVersaoApp`, `Ativo` |

`POST` / `PUT` / `DELETE` em `/usuarios` respondem 405. Inclusão de usuário do aplicativo fica em `/expedicao/create-login-app`.

Senha do login-app: bcrypt 12 rounds. A consulta não devolve senha. Foto entra e sai em base64.

Este coletor hoje autentica a tela de login localmente e usa Socket.IO para o restante. As rotas HTTP existem no servidor para o outro cliente e para cadastro.
