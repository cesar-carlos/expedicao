# Erros

Toda falha que chega no coletor precisa ser identificável pelo prefixo. Sem o prefixo, o abort da trigger e um dump `AppError{ message: ... }` escondem a causa.

Ponto único no servidor: `classifyClientError`. Socket.IO emite `Error` como `string[]`. HTTP coloca o mesmo texto em `message`.

Neste app: `lib/src/app/app_error.dart` (`implements Exception`). Alerta de tela: `AppErrorAlert` estende `AppError`.

## Envelope Socket.IO

```json
{
  "Session": "...",
  "ResponseIn": "...",
  "Error": ["[50014] Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho."],
  "Code": "BUSINESS_RULE_VIOLATION"
}
```

- `Error` é sempre `string[]`, com **uma** linha no formato `[identificador] mensagem`.
- `Code` e `RequestId` são metadados. Este coletor pode ignorá-los; a identificação rápida está no texto de `Error`.

## Como ler o prefixo

| Prefixo | Significa | O que fazer |
| --- | --- | --- |
| `[50011]`–`[50099]` | `THROW` de regra na base | Mostrar a mensagem. Tabela abaixo |
| `[SQL-CONN]` | Falha de conexão / login / timeout | Conferir SQL Server e API |
| `[SQL-547]`, `[SQL-2627]`, … | Erro SQL conhecido, sem nome de tabela | Integridade, duplicata, lock, conversão |
| `[SQL-208]` e outros `[SQL-n]` | Erro SQL sem mapeamento específico | Ver o log do servidor (texto técnico depois do `\|`) |
| `[INVALID_PAYLOAD]` | Envelope Socket inválido | `Where` / `Mutation` / JSON |
| `[UNAUTHORIZED]` | Sem permissão | Login / sessão |
| `[NOT_FOUND]` | Registro ausente | |
| `[INTERNAL_ERROR]` | Falha não classificada | Ver o log |

O cliente **não** recebe nome de objeto, constraint nem `The transaction ended in the trigger`. Isso fica só no log do servidor.

## THROW da conferência

| Prefixo | Quando | Mensagem (resumo) |
| --- | --- | --- |
| `[50011]` | Percurso `SE` vira `SEPARADO` com quantidade pendente | Separacao nao pode ser fechada… |
| `[50012]` | Conferência obrigatória sem item em carrinho `SEPARADO` | Nao e possivel gerar conferencia sem item… |
| `[50013]` | `ItemConferir` origem `SE` apontando para estágio inválido | Item a conferir deve apontar para estagio de separacao… |
| `[50014]` | Insert de estágio `CO` sem `ItemConferir` daquele carrinho | Carrinho sem itens para conferir… |
| `[50016]` | Segunda conferência ativa, ou índice `UX_Conferir_OrigemAtiva` | Ja existe conferencia ativa… |

Cancelar carrinho **não** gera `THROW`.

Abrir carrinho sem snapshot, com as triggers na `Estacao`:

`[50014] Carrinho sem itens para conferir. Nao e possivel iniciar a conferencia deste carrinho.`

A base `Estacao` **ainda pode não** ter os scripts. Sem as triggers o `[50014]` não existe; a tela volta a ficar vazia.

## SQL interno mapeado (o que a tela mostra)

| Prefixo | Mensagem |
| --- | --- |
| `[SQL-241]` / `[SQL-245]` / `[SQL-8114]` | Data ou hora invalida / Valor incompativel… |
| `[SQL-515]` | Campo obrigatorio ausente. |
| `[SQL-547]` | Registro relacionado impede esta operacao. |
| `[SQL-1205]` | Conflito de gravacao. Tente novamente. |
| `[SQL-1222]` | O registro esta em uso. Tente novamente. |
| `[SQL-2601]` / `[SQL-2627]` | Registro duplicado. (`UX_Conferir_OrigemAtiva` vira `[50016]`) |
| `[SQL-3609]` | A operacao foi recusada pela regra do banco. |
| `[SQL-8134]` | Operacao numerica invalida. |
| `[SQL-8152]` | Texto maior do que o campo permite. |
| `[SQL-CONN]` | Falha de conexao com o banco. |

## Fluxo neste coletor

1. O repositório lê o envelope e lança `AppError.fromResponse` / `fromSocket`.
2. O serviço relança `AppError.fromUnknown(e)` — **não** embrulha com `Exception('Erro ao X: $e')`. `fromUnknown` preserva `AppError` e `AppErrorAlert`.
3. `AppError.toString()` guarda a mensagem original. `display` / `userMessage` tiram o prefixo técnico e traduzem falha de rede. O dump `AppError{ message: ... }` não deve voltar.
4. A tela usa `AppError.title` + `AppError.userDetail` (texto claro; o código `[50014]` vai no rodapé como `Código 50014`). `display` devolve só a frase, sem dump técnico.
5. Não engolir o erro com `catch { return null/false }` dentro do `process` do loading — o `[50014]` some da tela.

```dart
} catch (e) {
  completer.completeError(AppError.fromSocket(e));
}

// no serviço
} catch (e) {
  throw AppError.fromUnknown(e);
}
```

`fromUnknown` preserva `AppError` já lançado. Qualquer outro valor passa por `fromSocket` / `socketMessage`.

`socketMessage` aceita:

- `null` → `Falha ao processar a solicitacao.`
- `AppError` → `message`
- `List` → junta as linhas (o `Error` do servidor)
- `Map` com `Error` / `message` / `Message` → recorre
- `toString()`, removendo prefixos Dart `Exception: `, `Error: `, `AppError: `

Prefixos de contrato (`[500…]`, `[SQL-…]`, `[INVALID_…]`, `[INTERNAL_…]`, `[UNAUTHORIZED…]`, `[NOT_FOUND…]`) **não** são removidos. Lista de um único token entre colchetes (ex. dump de Dart) pode ser desembrulhada.

## HTTP

O mesmo texto prefixado vai em `message`. `code` replica o `Code` do Socket.

| `code` | Status |
| --- | --- |
| `INVALID_PAYLOAD` | 400 |
| `UNAUTHORIZED` | 401 |
| `NOT_FOUND` | 404 |
| `BUSINESS_RULE_VIOLATION` (`50016`) | 409 |
| `BUSINESS_RULE_VIOLATION` (demais) | 422 |
| `INTERNAL_ERROR` | 500 |

Validação de query (login, usuários) responde 400 com `message` e `errors[]` — não passa por `classifyClientError`.

## Regras deste coletor

- Não embrulhar erro de socket. `AppError.display` já é o texto da tela.
- Lista vazia em `conferir.item.consulta` **não** é conferência completa (`every()` em lista vazia no Dart não vale).
- `Carrinho não conferido!` ao salvar (F12) é ausência de `ItemConferencia` (scan). É sintoma, não o `[50014]`.
- Este app **não** deve voltar a chamar `ConferirSeparacaoAdicionarService` enquanto a trigger existir. Quem cria `Conferir` é a trigger, não o coletor.
