import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/observacao_dialog_controller.dart';
import 'package:app_expedicao/src/pages/common/observacao_dialog/model/observacao_dialog_view_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';

class ObservacaoDialogView {
  static const double _barHeadHeight = 30;
  static const double _widthForm = 600;
  static const double _heightForm = 400;

  static Future<ObservacaoDialogViewModel?> show({
    required BuildContext context,
    required ObservacaoDialogViewModel viewModel,
    bool canCloseWindow = false,
  }) async {
    return await showDialog<ObservacaoDialogViewModel>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final _appEventState = Get.find<AppEventState>();
        _appEventState.canCloseWindow = canCloseWindow;

        return GetBuilder<ObservacaoDialogController>(
          init: ObservacaoDialogController(viewModel),
          builder: (ObservacaoDialogController controller) {
            return RawKeyboardListener(
              focusNode: controller.formFocusNode,
              onKey: controller.handleKeyEvent,
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: _widthForm,
                  height: _heightForm,
                  child: Column(
                    children: [
                      BarHeadFormElement(
                        widthBar: _widthForm,
                        title: viewModel.title,
                        onPressedCloseBar: controller.onPressedCloseBar,
                      ),

                      //** BODY **//
                      Container(
                        width: _widthForm,
                        height: _heightForm - _barHeadHeight,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          color: Color(Colors.white.value),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 5, right: 30),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Histórico',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: TextField(
                                        maxLength: 50,
                                        focusNode:
                                            controller.historicoFocusNode,
                                        controller:
                                            controller.historicoController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.black38,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Observação',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 175,
                                      child: TextField(
                                        maxLines: 10,
                                        keyboardType: TextInputType.multiline,
                                        focusNode:
                                            controller.observacaoFocusNode,
                                        controller:
                                            controller.observacaoController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black38),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ///** FOOTER BUTTON **//
                            Container(
                              padding: EdgeInsets.only(right: 30, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonFormElement(
                                    name: 'Cancelar',
                                    padding: const EdgeInsets.only(left: 5),
                                    onPressed: controller.onPressedCancelar,
                                  ),
                                  ButtonFormElement(
                                    name: '   Salvar   ',
                                    padding: const EdgeInsets.only(left: 5),
                                    onPressed: controller.onPressedSalvar,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
