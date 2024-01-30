import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/separacao/widget/scan_separacao_item_widget.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid.dart';

class SeparacaoPage {
  static const String title = 'Separar';
  static const double _spaceHeadlement = 30;

  SeparacaoPage._();

  static Future<void> show({
    required Size size,
    required bool canCloseWindow,
    required BuildContext context,
    required ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
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
          child: GetBuilder<SeparacaoController>(
            init: SeparacaoController(percursoEstagioConsulta),
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
                      onPressedCloseBar: controller.onPressedCloseBar,
                    ),
                    _dailog(size, controller, percursoEstagioConsulta),
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
    SeparacaoController controller,
    ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta,
  ) {
    return GetBuilder<SeparacaoController>(
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
                  title: 'Separar tudo',
                  onPressed: controller.onSepararTudo,
                  icon: const Icon(
                    BootstrapIcons.list_check,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
                ButtonHeadForm(
                  title: 'Reconferir tudo',
                  onPressed: controller.onReconferirTudo,
                  icon: const Icon(
                    BootstrapIcons.list_task,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              ],
            ),

            //LEITOR CODIGO DE BARRAS
            ScanSeparacaoItemWidget(percursoEstagioConsulta, size: size),

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
                                'Carrinho',
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
                                'Separação',
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
                        Container(
                          color: Colors.white70,
                          child: SeparacaoCarrinhoGrid(
                            percursoEstagioConsulta,
                          ),
                        ),
                        Container(
                          color: Colors.white70,
                          //child: const SepararSetorGrid(),
                          child: const SepararGrid(),
                        ),
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
