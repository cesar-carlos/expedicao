import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeparacaoController extends GetxController {
  late TextEditingController scanController;
  late TextEditingController quantidadeController;
  late FocusNode quantidadeFocusNode;
  late FocusNode scanFocusNode;

  @override
  void onInit() {
    scanController = TextEditingController();
    quantidadeController = TextEditingController(text: '1.000');
    scanFocusNode = FocusNode()..requestFocus();
    quantidadeFocusNode = FocusNode();

    super.onInit();
  }

  @override
  void onClose() {
    scanController.dispose();
    quantidadeController.dispose();
    quantidadeFocusNode.dispose();
    scanFocusNode.dispose();
    super.onClose();
  }

  void onSubmitted(String? value) {
    if (value != null) {
      if (value.isNotEmpty) {
        quantidadeFocusNode.requestFocus();
        quantidadeController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantidadeController.text.length,
        );
      }
    }
  }
}
