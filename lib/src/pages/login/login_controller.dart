import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/routes/app_router.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController(text: 'Administrador');
  final passwordController = TextEditingController();

  String? validEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  String? validPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  void login() async {
    try {
      if (formKey.currentState!.validate()) {
        if (userController.text == 'Administrador' &&
            passwordController.text == 'sql@2012') {
          Get.offNamed(AppRouter.apiConfig);
        } else {
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
          margin: const EdgeInsets.all(20),
          colorText: Colors.white,
          backgroundColor: Colors.black26,
          maxWidth: 400.0);
    }
  }

  @override
  void onClose() {
    userController.dispose();
    passwordController.dispose();
  }
}
