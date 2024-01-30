import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho/carrinho_controller.dart';

class AdicionarCarrinhoDialogWidget {
  final bool canCloseWindow;
  final double widthForm = 600;
  final double heightForm = 400;
  final double spaceBarHeadForm = 30.5;
  final BuildContext context = Get.context!;
  final Size size = Get.size;

  AdicionarCarrinhoDialogWidget({required this.canCloseWindow});

  Future<ExpedicaoCarrinhoConsultaModel?> show() async {
    Get.find<AppEventState>()..canCloseWindow = canCloseWindow;

    return await showDialog<ExpedicaoCarrinhoConsultaModel>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                Get.find<AppEventState>()..canCloseWindow = true;
                Get.back();
              }
            }
          },
          child: GetBuilder<CarrinhoController>(
            init: CarrinhoController(),
            builder: (controller) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: widthForm,
                  height: heightForm,
                  child: Column(
                    children: [
                      //** HEADER BAR **//
                      BarHeadFormElement(
                        widthBar: size.width - 554,
                        title: 'Adicionar Carrinho',
                        onPressedCloseBar: () => Get.back(),
                      ),

                      //** BODY **//
                      Container(
                        width: widthForm,
                        height: heightForm - spaceBarHeadForm,
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
              );
            },
          ),
        );
      },
    );
  }
}
