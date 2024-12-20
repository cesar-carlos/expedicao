import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_page.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/separar/widget/separar_itens_widget.dart';
import 'package:app_expedicao/src/pages/common/footer_page/footer_page.dart';

class SepararPage extends StatelessWidget {
  final ExpedicaoSepararConsultaModel separarConsulta;
  const SepararPage({super.key, required this.separarConsulta});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<SepararController>(
      builder: (controller) {
        return RawKeyboardListener(
          focusNode: controller.formFocusNode,
          onKey: controller.handleKeyEvent,
          child: Scaffold(
            body: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceButtonsHeadFormElement(
                    width: double.infinity,
                    children: [
                      // ButtonHeadForm(
                      //   title: controller.iniciada
                      //       ? 'Pausar Separação'
                      //       : 'Iniciar Separação',
                      //   icon: controller.iniciada
                      //       ? const Icon(
                      //           BootstrapIcons.pause_btn_fill,
                      //           color: Colors.white,
                      //           size: 33,
                      //         )
                      //       : const Icon(
                      //           BootstrapIcons.play_btn_fill,
                      //           color: Colors.white,
                      //           size: 33,
                      //         ),
                      // ),

                      ButtonHeadForm(
                        title: 'Adicionar Carrinho',
                        shortCut: 'F4',
                        shortCutActive: true,
                        onPressed: controller.onAdicionarCarrinho,
                        icon: const Icon(
                          BootstrapIcons.cart4,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),

                      ButtonHeadForm(
                        title: 'Histórico/Observação',
                        shortCut: 'F5',
                        shortCutActive: true,
                        onPressed: controller.btnAdicionarObservacao,
                        icon: const Icon(
                          BootstrapIcons.file_text_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),

                      ButtonHeadForm(
                        title: 'Recuperar Carrinho',
                        shortCut: 'F11',
                        shortCutActive: true,
                        onPressed: controller.recuperarCarrinho,
                        icon: const Icon(
                          BootstrapIcons.recycle,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),

                      ButtonHeadForm(
                        title: 'Finalizar Separação',
                        onPressed: controller.btnFinalizarSeparacao,
                        shortCut: 'F12',
                        shortCutActive: true,
                        icon: const Icon(
                          BootstrapIcons.clipboard_check_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),

                      ButtonHeadForm(
                        title: 'Configuração',
                        onPressed: controller.configuracao,
                        icon: const Icon(
                          BootstrapIcons.gear_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                    ],
                  ),
                  SepararItensWidget(
                    size: Size(
                      size.width,
                      ((size.height - 81) * .6),
                    ),
                  ),
                  SeparadoCarrinhoPage(
                    size: Size(
                      size.width,
                      ((size.height - 81) * .4),
                    ),
                  ),
                  const FooterPage()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
