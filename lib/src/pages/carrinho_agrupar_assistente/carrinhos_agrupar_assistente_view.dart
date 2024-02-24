import 'package:get/get.dart';
import 'package:flutter/material.dart';
//import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar_assistente/model/carrinhos_agrupar_assistente_view_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar_assistente/carrinhos_agrupar_assistente_controller.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class CarrinhosAgruparAssistenteView {
  static const double _spaceHeadlement = 30;
  static const double _widthForm = 580;
  static const double _heightForm = 350;

  CarrinhosAgruparAssistenteView._();

  static Future<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?> show({
    required BuildContext context,
    required CarrinhosAgruparAssistenteViewModel input,
    bool canCloseWindow = false,
  }) async {
    Get.find<AppEventState>()..canCloseWindow = canCloseWindow;

    return await showDialog<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CarrinhosAgruparAssistenteController>(
          init: CarrinhosAgruparAssistenteController(input),
          builder: (CarrinhosAgruparAssistenteController controller) {
            return RawKeyboardListener(
              focusNode: controller.formFocusNode,
              onKey: controller.handleKeyEvent,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: _widthForm,
                  height: _heightForm - _spaceHeadlement,
                  child: Column(children: [
                    BarHeadFormElement(
                      title: controller.title,
                      widthBar: _widthForm,
                      onPressedCloseBar: controller.onPressedCloseBar,
                    ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                'CARRINHO AGRUPAMENTO',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Descrição: ${controller.descricaoCarrinho}',
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Situação: ${controller.situacaoCarrinho}',
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Estagio : ${controller.estagioCarrinho}',
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Setor: ${controller.setorEstoque}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///** CODIGO CARRINHO  **//
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        autofocus: true,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        focusNode: controller.focusNodeCodigoCarrinho,
                        controller: controller.controllerCodigoCarrinho,
                        onChanged: controller.onChangedCodigoCarrinho,
                        onSubmitted: controller.onSubmittedCodigoCarrinho,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 27),
                        decoration: const InputDecoration(
                          hintText: 'Código Carrinho',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
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
                            name: '   Continuar   ',
                            padding: const EdgeInsets.only(left: 5),
                            focusNode: controller.focusNodeButtonContinuar,
                            onPressed: controller.onPressedContinuar,
                          )
                        ],
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
