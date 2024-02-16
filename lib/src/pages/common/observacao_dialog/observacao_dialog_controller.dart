import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/model/observacao_dialog_view_model.dart';

class ObservacaoDialogController extends GetxController {
  late FocusNode formFocusNode;
  late FocusNode historicoFocusNode;
  late FocusNode observacaoFocusNode;

  late TextEditingController historicoController;
  late TextEditingController observacaoController;

  final ObservacaoDialogViewModel _viewModel;

  ObservacaoDialogController(viewModel) : _viewModel = viewModel;

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

  void handleKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.f12) {
      //TODO: implementar salvar
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      onPressedSalvar();
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      onPressedSalvar();
    }
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
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: null);
  }

  void onPressedCancelar() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: null);
  }

  void onPressedSalvar() {
    Get.find<AppEventState>()..canCloseWindow = true;
    Get.back(result: viewModel);
  }
}
