import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';

class SepararOBsDialogWidget {
  final Size size = Get.size;
  final BuildContext context = Get.context!;
  final controller = Get.find<SepararController>();
  final spaceBarHeadFormElement = 30.5;

  SepararOBsDialogWidget();

  Future<bool?> show() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 600,
          height: 400,
          child: Column(children: [
            //** HEADER BAR **//
            BarHeadFormElement(
              widthBar: size.width,
              title: 'Adicionar Observação',
              onPressedCloseBar: () {}, //ADD CLIER OBSERVACAO CLOSE X
            ),

            //** BODY **//
            Container(
              width: 600,
              height: 400 - spaceBarHeadFormElement,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                color: Color(Colors.white.value),
              ),
              child: Column(children: [
                ///** DETALHES CARRINHO **//
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (_, __) {
                        return Column(
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
                                controller: controller.historicoController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black38,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            //const SizedBox(height: 10),
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
                              height: 170,
                              child: TextField(
                                maxLines: 10,
                                keyboardType: TextInputType.multiline,
                                controller: controller.observacaoController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black38,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                ///** FOOTER BUTTON **//
                Container(
                  padding: const EdgeInsets.only(right: 30, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonFormElement(
                        name: 'Cancelar',
                        padding: const EdgeInsets.only(left: 5),
                        onPressed: () => Get.back(),
                      ),
                      ButtonFormElement(
                        name: '   Salvar   ',
                        padding: const EdgeInsets.only(left: 5),
                        onPressed: () => Get.back(result: true),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
