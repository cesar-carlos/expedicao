import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/model/identificacao_dialog_view_model.dart';
import 'package:app_expedicao/src/pages/common/Identificacao_dialog/identificacao_dialog_controller.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class IdentificacaoDialogView {
  static const double _widthForm = 500;
  static const double _heightForm = 312;
  static const double _spaceHeadlement = 30.5;

  static Future<IdentificacaoDialogViewModel?> show({
    required BuildContext context,
    bool canCloseWindow = false,
  }) async {
    return await showDialog<IdentificacaoDialogViewModel>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final _appEventState = Get.find<AppEventState>();
        _appEventState.canCloseWindow = canCloseWindow;

        return GetBuilder<IdentificacaoDialogController>(
          init: IdentificacaoDialogController(),
          builder: (IdentificacaoDialogController controller) {
            return RawKeyboardListener(
              focusNode: controller.formFocusNode,
              onKey: controller.handleKeyEvent,
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: _widthForm,
                  height: _heightForm,
                  child: Column(children: [
                    //** HEADER BAR **//
                    BarHeadFormElement(
                      title: 'Identificação',
                      widthBar: _widthForm + 80,
                      onPressedCloseBar: () => Get.back(),
                    ),

                    //** BODY **//
                    Container(
                      padding:
                          const EdgeInsets.only(left: 60, top: 10, right: 60),
                      width: _widthForm,
                      height: _heightForm -
                          IdentificacaoDialogView._spaceHeadlement,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10)),
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
                            onFieldSubmitted:
                                controller.onFieldSubmittedPassword,
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
          },
        );
      },
    );
  }
}
