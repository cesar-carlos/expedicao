import 'package:app_expedicao/src/model/expedicao_percurso_estagio_consulta_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';

class ScanItemWidget extends StatelessWidget {
  final ExpedicaoPercursoEstagioConsultaModel percursoEstagioConsulta;

  const ScanItemWidget(
    this.percursoEstagioConsulta, {
    required this.size,
    super.key,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoController>(builder: (controller) {
      return Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width - 100,
              child: Column(
                children: [
                  //** SCAN **//
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          enabled: !controller.viewMode(),
                          controller: controller.scanController,
                          focusNode: controller.scanFocusNode,
                          onSubmitted: controller.onSubmittedScan,
                          textAlign: TextAlign.start,
                          cursorHeight: 22,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            prefixIcon: const Icon(
                              size: 20,
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
                            labelText: 'Leitor código de barras',
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),

                      //** quantidade **//
                      Expanded(
                        child: TextField(
                          enabled: !controller.viewMode(),
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
