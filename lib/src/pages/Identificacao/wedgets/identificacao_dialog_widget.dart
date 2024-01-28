import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/Identificacao/identificacao_controller.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/Identificacao/model/identificacao_model.dart';

class IdentificacaoDialogWidget {
  final spaceBarHeadFormElement = 30.5;

  IdentificacaoDialogWidget() {}

  Future<IdentificacaoModel?> show() async {
    final size = Get.size;
    final context = Get.context!;
    final controller = IdentificacaoController();

    return await showDialog<IdentificacaoModel>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 500,
          height: 312,
          child: Column(children: [
            //** HEADER BAR **//
            BarHeadFormElement(
              title: 'Identificação',
              widthBar: size.width - 654,
              onPressedCloseBar: () => Get.back(),
            ),

            //** BODY **//
            Container(
              padding: const EdgeInsets.only(left: 60, top: 10, right: 60),
              width: 500,
              height: 312 - spaceBarHeadFormElement,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                color: Color(Colors.white.value),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(children: [
                  Text(
                    'Identificação',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    validator: controller.validUser,
                    controller: controller.userController,
                    focusNode: controller.userFocusNode,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(),
                      labelText: 'Usuario',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    validator: controller.validPassword,
                    controller: controller.passwordController,
                    onFieldSubmitted: controller.onFieldSubmittedPassword,
                    focusNode: controller.passwordFocusNode,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                  ),

                  ///** FOOTER BUTTON **//
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonFormElement(
                          name: 'Cancelar',
                          padding: const EdgeInsets.only(left: 5),
                          onPressed: controller.cancelar,
                        ),
                        ButtonFormElement(
                          name: 'Login',
                          focusNode: controller.loginFocusNode,
                          padding: const EdgeInsets.only(left: 5),
                          onPressed: controller.login,
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
