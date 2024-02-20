import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/pages/common/carrinho_dialog/carrinho_controller.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class CarrinhoDialogView {
  static const double _widthForm = 600;
  static const double _heightForm = 400;
  static const double _spaceBarHeadForm = 30.5;

  static Future<ExpedicaoCarrinhoConsultaModel?> show({
    required BuildContext context,
    bool canCloseWindow = false,
  }) async {
    return await showDialog<ExpedicaoCarrinhoConsultaModel>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final _appEventState = Get.find<AppEventState>();
        _appEventState.canCloseWindow = canCloseWindow;

        return GetBuilder<CarrinhoController>(
          init: CarrinhoController(),
          builder: (CarrinhoController controller) {
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
                      //** HEADER BAR **//
                      BarHeadFormElement(
                        widthBar: _widthForm + 80,
                        title: 'Adicionar Carrinho',
                        onPressedCloseBar: () => Get.back(),
                      ),

                      //** BODY **//
                      Container(
                        width: _widthForm,
                        height: _heightForm - _spaceBarHeadForm,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          color: Color(Colors.white.value),
                        ),
                        child: Column(
                          children: [
                            ///** DETALHES CARRINHO **//
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 5, right: 30),
                                child: ListenableBuilder(
                                  listenable: controller,
                                  builder: (_, __) {
                                    return Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Detalhes',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Descrição: ${controller.carrinho.descricaoCarrinho}',
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Situação: ${controller.carrinho.situacao}',
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Local: ${controller.carrinho.local}',
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Setor: ${controller.carrinho.setor}',
                                          ),
                                        ),

                                        ///** OBSERVARCAO **//
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            color: Color(Colors.white.value),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Column(
                                            children: [
                                              Text('Observação'),
                                              SizedBox(height: 2),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                            ///** CODIGO CARRINHO  **//
                            Container(
                              height: 70,
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: TextField(
                                autofocus: true,
                                autocorrect: false,
                                focusNode: controller.focusNodeCodigoCarrinho,
                                controller:
                                    controller.textControllerCodigoCarrinho,
                                keyboardType: TextInputType.number,
                                onChanged: controller.onChangedCodigoCarrinho,
                                onSubmitted: controller.onSubmittedForm,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 27,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Código Carrinho',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///** FOOTER BUTTON **//
                            Container(
                              padding:
                                  const EdgeInsets.only(right: 30, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonFormElement(
                                    name: 'Cancelar',
                                    padding: const EdgeInsets.only(left: 5),
                                    onPressed: () => Get.back(),
                                  ),

                                  //ADD NER CART
                                  ButtonFormElement(
                                    name: 'Adicionar',
                                    focusNode: controller
                                        .focusNodeBtnAdicionarCarrinho,
                                    padding: const EdgeInsets.only(left: 5),
                                    onPressed: () => controller.addCarrinho(),
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
