import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/model/observacao_dialog_view_model.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class ObservacaoDialogController extends GetxController {
  late FocusNode formFocusNode;
  late FocusNode historicoFocusNode;
  late FocusNode observacaoFocusNode;

  late TextEditingController historicoController;
  late TextEditingController observacaoController;

  final ObservacaoDialogViewModel _viewModel;
  final _closeGuard = DialogCloseGuard();

  ObservacaoDialogController(ObservacaoDialogViewModel viewModel)
      : _viewModel = viewModel;

  ObservacaoDialogViewModel get viewModel => ObservacaoDialogViewModel(
        title: 'Adicionar Observação',
        historico: historicoController.text,
        observacao: observacaoController.text,
      );

  @override
  void onInit() {
    super.onInit();
    formFocusNode = FocusNode();
    historicoFocusNode = FocusNode();
    observacaoFocusNode = FocusNode();
    historicoController = TextEditingController();
    observacaoController = TextEditingController();
    _historicoControllerListener();

    _fillFormFromViewModel();
    historicoFocusNode.requestFocus();
  }

  @override
  void onClose() {
    formFocusNode.dispose();
    historicoFocusNode.dispose();
    observacaoFocusNode.dispose();
    historicoController.dispose();
    observacaoController.dispose();

    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.f12) {
        onPressedSalvar();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.escape) {
        onPressedCancelar();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void _historicoControllerListener() {
    historicoController.addListener(() {
      final text = historicoController.text;
      if (text == text.toUpperCase()) {
        return;
      }

      final selection = historicoController.selection;
      historicoController.text = text.toUpperCase();
      historicoController.selection = selection;
    });
  }

  void _fillFormFromViewModel() {
    historicoController.text = _viewModel.historico ?? '';
    observacaoController.text = _viewModel.observacao ?? '';
  }

  void onPressedCloseBar() {
    _closeGuard.close(context: formFocusNode.context);
  }

  void onPressedCancelar() {
    _closeGuard.close(context: formFocusNode.context);
  }

  void onPressedSalvar() {
    _closeGuard.close(result: viewModel, context: formFocusNode.context);
  }
}
