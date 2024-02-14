import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferencia/widget/scan_conferencia_item_widget.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

class ConferenciaPage {
  static const String title = 'Conferência';
  static const double _spaceHeadlement = 30;

  ConferenciaPage._();

  static Future<void> show({
    required Size size,
    required bool canCloseWindow,
    required BuildContext context,
    required ExpedicaoCarrinhoPercursoEstagioConsultaModel
        percursoEstagioConsulta,
  }) async {
    Get.find<AppEventState>()..canCloseWindow = canCloseWindow;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ConferenciaController>(
          init: ConferenciaController(percursoEstagioConsulta),
          builder: (controller) {
            return RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.f7) {
                    controller.onConferirTudo();
                  }

                  if (event.logicalKey == LogicalKeyboardKey.f8) {
                    controller.onReconferirTudo();
                  }

                  if (event.logicalKey == LogicalKeyboardKey.escape) {
                    Get.find<AppEventState>()..canCloseWindow = true;
                    Get.back();
                  }
                }
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: size.width * 0.95,
                  height: size.height * 0.8,
                  child: Column(children: [
                    BarHeadFormElement(
                      title: title,
                      widthBar: size.width,
                      onPressedCloseBar: controller.onPressedCloseBar,
                    ),
                    _dailog(size, controller, percursoEstagioConsulta),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _dailog(
    Size size,
    ConferenciaController controller,
    ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta,
  ) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.8 - _spaceHeadlement,
          child: Column(children: [
            //** HEADER BUTTON **//
            SpaceButtonsHeadFormElement(
              width: double.infinity,
              children: [
                ButtonHeadForm(
                  title: 'Conferir tudo',
                  shortCut: 'F7',
                  shortCutActive: true,
                  onPressed: controller.onConferirTudo,
                  icon: const Icon(
                    BootstrapIcons.list_check,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
                ButtonHeadForm(
                  title: 'Reconferir tudo',
                  shortCut: 'F8',
                  shortCutActive: true,
                  onPressed: controller.onReconferirTudo,
                  icon: const Icon(
                    BootstrapIcons.list_task,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
                ButtonHeadForm(
                  title: 'Sobra de carrinho',
                  onPressed: controller.onSobraCarrinho,
                  icon: const Icon(
                    BootstrapIcons.exclamation_circle_fill,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              ],
            ),

            //LEITOR CODIGO DE BARRAS
            ScanConferenciaItemWidget(percursoEstagioConsulta, size: size),

            //tabs
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: DefaultTabController(
                  initialIndex: controller.viewMode ? 0 : 1,
                  length: 2,
                  animationDuration: const Duration(milliseconds: 500),
                  child: Column(children: [
                    Container(
                      color: Colors.white,
                      constraints: const BoxConstraints.expand(height: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TabBar(
                          indicatorColor: Colors.black45,
                          overlayColor:
                              MaterialStateProperty.all(Colors.black12),
                          indicatorPadding: EdgeInsets.zero,
                          tabs: const [
                            Row(children: [
                              Icon(
                                size: 20,
                                BootstrapIcons.list_task,
                              ),
                              Spacer(),
                              Text(
                                'Conferencia',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Spacer(),
                            ]),
                            Row(children: [
                              Icon(
                                size: 20,
                                BootstrapIcons.list_check,
                              ),
                              Spacer(),
                              Text(
                                'Carrinho',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Spacer(),
                            ]),
                          ]),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        ConferenciaCarrinhoGrid(percursoEstagioConsulta),
                        const ConferirGrid()
                      ]),
                    ),
                  ]),
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
