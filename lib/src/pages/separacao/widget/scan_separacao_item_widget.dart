import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/pages/common/widget/quantity_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';
import 'package:app_expedicao/src/pages/common/widget/scan_widget.dart';

class ScanSeparacaoItemWidget extends StatelessWidget {
  final Size size;
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  const ScanSeparacaoItemWidget(
    this.percursoEstagioConsulta, {
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoController>(builder: (controller) {
      return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            Get.find<AppEventState>().canCloseWindow = true;
            Get.back();
          }
        },
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width - 115,
                child: Column(
                  children: [
                    //** SCAN **//
                    Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: ScanWidget(
                            viewMode: !controller.viewMode,
                            scanController: controller.scanController,
                            scanFocusNode: controller.scanFocusNode,
                            onSubmittedScan: controller.onSubmittedScan,
                          ),
                        ),
                        const SizedBox(width: 7),

                        //** QUANTIDADE **//
                        Expanded(
                          flex: 2,
                          child: QuantityWidget(
                            viewMode: !controller.viewMode,
                            qtdController: controller.quantidadeController,
                            qtdFocusNode: controller.quantidadeFocusNode,
                            onSubmittedQtd: controller.onSubmittedQuantity,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    //** Display **//
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: TextField(
                        readOnly: false,
                        controller: controller.displayController,
                        focusNode: controller.displayFocusNode,
                        cursorHeight: 22,
                        decoration: const InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          prefixIcon: Icon(
                            size: 20,
                            BootstrapIcons.file_text,
                            color: Colors.black87,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            ),
                          ),
                          labelText: '',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
