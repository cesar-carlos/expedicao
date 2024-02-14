import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_footer.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/carrinhos_agrupar_controller.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class CarrinhosAgruparPage {
  static const double _spaceHeadlement = 30;
  static const String title = 'Agrupar Carrinhos';

  CarrinhosAgruparPage._();

  static Future<void> show({
    required Size size,
    required bool canCloseWindow,
    required BuildContext context,
    required ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel
        carrinhoPercursoAgrupamento,
  }) async {
    Get.find<AppEventState>()..canCloseWindow = canCloseWindow;

    await showDialog(
      barrierDismissible: false,
      context: context,
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
          child: GetBuilder<CarrinhosAgruparController>(
            init: CarrinhosAgruparController(carrinhoPercursoAgrupamento),
            builder: (controller) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: size.width * 0.95,
                  height: size.height * 0.8,
                  child: Column(children: [
                    BarHeadFormElement(
                      title: title,
                      widthBar: size.width,
                      onPressedCloseBar: () => Get.back(),
                    ),
                    _dailog(size, controller, carrinhoPercursoAgrupamento),
                  ]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _dailog(
    Size size,
    CarrinhosAgruparController controller,
    ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel
        carrinhoPercursoAgrupamento,
  ) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.8 - _spaceHeadlement,
          child: Column(
            children: [
              //** HEADER BUTTON **//
              SpaceButtonsHeadFormElement(
                width: double.infinity,
                children: [
                  ButtonHeadForm(
                    title: 'Agrupar tudo',
                    shortCut: 'F7',
                    onPressed: controller.onAgruparTudo,
                    icon: const Icon(
                      BootstrapIcons.layers_fill,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  ButtonHeadForm(
                    title: 'Desagrupar tudo',
                    shortCut: 'F8',
                    onPressed: controller.onDesabruparTudo,
                    icon: const Icon(
                      BootstrapIcons.layers,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                ],
              ),

              //CARRINHO AGRUPAR
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 400,
                          height: 32,
                          child: TextField(
                            readOnly: true,
                            cursorHeight: 22,
                            controller: controller.controllerNomeCarrinho,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Carrinho selecionado',
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              prefix: Container(
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  size: 15,
                                  BootstrapIcons.cart_fill,
                                  color: Colors.black,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 300,
                          height: 32,
                          child: TextField(
                            readOnly: true,
                            cursorHeight: 22,
                            controller: controller.controllerCodigoBarras,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Cogigo de barras',
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              prefix: Container(
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  size: 15,
                                  BootstrapIcons.upc,
                                  color: Colors.black,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 280,
                          height: 32,
                          child: TextField(
                            readOnly: true,
                            cursorHeight: 22,
                            controller: controller.controllerCarrinhoSituacao,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Situação do carrinho',
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              suffix: Container(
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  size: 15,
                                  BootstrapIcons.circle_fill,
                                  color: Colors.green,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    //ROW2
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: TextField(
                        cursorHeight: 25,
                        // enabled: viewMode,
                        controller: controller.controllerScanCarrinho,
                        focusNode: controller.focusScanCarrinho,
                        onSubmitted: controller.onSubmittedScan,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          prefixIcon: const Icon(
                            size: 25,
                            BootstrapIcons.upc,
                            color: Colors.black87,
                          ),
                          suffix: Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              size: 15,
                              BootstrapIcons.search,
                              color: Colors.black87,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Carrinho para agrupar',
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                color: Colors.white,
                child: Text(
                  'Carrinhos agrupar',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              //tabs
              Expanded(
                flex: 11,
                child: Container(
                  color: Colors.white,
                  child: CarrinhosAgruparGrid(),
                ),
              ),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: CarrinhosAgruparGridFooter(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
