import 'package:app_expedicao/src/pages/common/widget/scan_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';

class ScanConferenciaItemWidget extends StatelessWidget {
  final Size size;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  const ScanConferenciaItemWidget(
    this.percursoEstagioConsulta, {
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferenciaController>(builder: (controller) {
      return Container(
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
                        flex: 5,
                        child: ScanWidget(
                          viewMode: !controller.viewMode,
                          scanController: controller.scanController,
                          scanFocusNode: controller.scanFocusNode,
                          onSubmittedScan: controller.onSubmittedScan,
                        ),
                      ),
                      const SizedBox(width: 7),

                      //** quantidade **//
                      Expanded(
                        child: TextField(
                          enabled: !controller.viewMode,
                          cursorHeight: 22,
                          controller: controller.quantidadeController,
                          focusNode: controller.quantidadeFocusNode,
                          onSubmitted: controller.onSubmittedQuantity,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            NumberTextInputFormatter(
                              integerDigits: 10,
                              decimalDigits: 3,
                              decimalSeparator: ',',
                              groupDigits: 3,
                              groupSeparator: '.',
                              allowNegative: false,
                              overrideDecimalPoint: true,
                              insertDecimalPoint: false,
                              insertDecimalDigits: true,
                            ),
                          ],
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            border: OutlineInputBorder(),
                            labelText: 'Quantidade',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
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
      );
    });
  }
}
