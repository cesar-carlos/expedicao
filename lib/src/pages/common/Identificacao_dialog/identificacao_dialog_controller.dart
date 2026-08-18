import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/model/identificacao_dialog_view_model.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';

class IdentificacaoDialogController extends GetxController {
  late FocusNode formFocusNode;
  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController(text: 'Administrador');
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode()..requestFocus();
  final loginFocusNode = FocusNode();
  final userFocusNode = FocusNode();
  final _closeGuard = DialogCloseGuard();

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
    loginFocusNode.dispose();
    formFocusNode.dispose();
    if (Get.isRegistered<AppEventState>()) {
      Get.find<AppEventState>().canCloseWindow = true;
    }
    super.onClose();
  }

  KeyEventResult handleKeyEvent(AppRawKeyEvent event) {
    if (isRawKeyDown(event)) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        cancelar();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.f12) {
        login();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void _listenFocusNode() {
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
    _closeGuard.close(context: formFocusNode.context);
  }

  void onFieldSubmittedPassword(String value) {
    loginFocusNode.requestFocus();
  }

  void login() async {
    try {
      if (formKey.currentState!.validate()) {
        //TODO: implementar login
        if (userController.text == 'Administrador' &&
            passwordController.text == '1234') {
          final identificacaoModel = IdentificacaoDialogViewModel(
            codUsuario: 1,
            nomeUsuario: userController.text,
          );

          _closeGuard.close(
            result: identificacaoModel,
            context: formFocusNode.context,
          );
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
