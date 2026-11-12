# Modais e overlay de carregamento

## Fechar modal

`Get.back()` **não** fecha `showDialog` neste app quando:

- há snackbar aberto (o GetX fecha só o snackbar);
- o dialog está em `PopScope(canPop: false)` (`Navigator.canPop()` fica `false` e o `Get.back` recusa).

Sintoma: o processo no servidor termina, a grade atualiza, o spinner branco fica por cima.

Usar `Navigator.of(dialogContext).pop()` ou `DialogCloseGuard.popPage(context: …)`.

Código: `lib/src/app/app_dialog_close.dart`, `lib/src/pages/common/widget/loading_process_dialog_generic_widget.dart`.

`LoadingProcessDialogWidget` encaminha para o genérico. Não reintroduzir `Get.back()` no overlay.

## Overlay de processo

- `canPop: false` no `PopScope` do loading.
- Um latch `processStarted` no `addPostFrameCallback`: rebuild do dialog não dispara o `process()` de novo.
- Depois do `await process()`, pop no `dialogContext` se `mounted`.
- Atalho F12: [atalhos](../../.cursor/rules/atalhos-teclado.mdc) — consumir o evento.

## ESC

ESC fecha só o modal atual, mesmo efeito do X. Consumir o evento para não fechar a tela de trás.
