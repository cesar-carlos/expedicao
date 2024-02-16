import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/model/identificacao_dialog_view_model.dart';

class IdentificacaoDialogController extends GetxController {
  late FocusNode formFocusNode;
  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController(text: 'Administrador');
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode()..requestFocus();
  final loginFocusNode = FocusNode();
  final userFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    formFocusNode = FocusNode();
  }

  @override
  void onReady() async {
    super.onReady();
    _listenFocusNode();
  }

  @override
  void onClose() {
    userController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    userFocusNode.dispose();
    Get.find<AppEventState>()..canCloseWindow = true;
    super.onClose();
  }

  KeyEventResult handleKeyEvent(FocusNode focusNod, KeyEvent event) {
    // if (event.logicalKey == LogicalKeyboardKey.escape) {
    //   Get.find<AppEventState>()..canCloseWindow = true;
    //   Get.back(result: null);
    // }

    return KeyEventResult.ignored;
  }

  _listenFocusNode() {
    userFocusNode.addListener(() {
      if (userFocusNode.hasFocus) {
        userController.selection = TextSelection(
            baseOffset: 0, extentOffset: userController.text.length);
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        passwordController.selection = TextSelection(
            baseOffset: 0, extentOffset: passwordController.text.length);
      }
    });
  }

  String? validUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'Usuário é obrigatório';
    }

    return null;
  }

  String? validPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatório';
    }

    return null;
  }

  void cancelar() {
    Get.back();
  }

  void onFieldSubmittedPassword(String value) {
    loginFocusNode.requestFocus();
  }

  void login() async {
    try {
      if (formKey.currentState!.validate()) {
        //TODO: implementar login
        if (userController.text == 'Administrador' &&
            passwordController.text == 'sql@2012') {
          final identificacaoModel = IdentificacaoDialogViewModel(
            codUsuario: 1,
            nomeUsuario: userController.text,
          );

          Get.back(result: identificacaoModel);
        } else {
          passwordFocusNode.requestFocus();
          Get.snackbar("Login", "usuario ou senha inválidos",
              icon: const Icon(Icons.login_outlined, color: Colors.white),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(20),
              colorText: Colors.white,
              backgroundColor: Colors.black26,
              maxWidth: 400.0);
        }
      }
    } catch (err) {
      Get.snackbar("Login", "usuario ou senha inválidos",
          icon: const Icon(Icons.login_outlined, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(40),
          colorText: Colors.white,
          backgroundColor: Colors.black26,
          maxWidth: 600.0);
    }
  }
}
