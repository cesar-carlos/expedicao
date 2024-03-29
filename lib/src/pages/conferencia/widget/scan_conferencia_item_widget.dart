import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/common/widget/scan_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/quantity_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';

class ScanConferenciaItemWidget extends StatelessWidget {
  final Size size;
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

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
      );
    });
  }
}
