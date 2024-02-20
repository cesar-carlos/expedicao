import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/common/footer/footer_page.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_page.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_page.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';

class ConferirPage extends StatelessWidget {
  const ConferirPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<ConferirController>(
      builder: (ConferirController controller) {
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
                      ButtonHeadForm(
                        title: controller.iniciada
                            ? 'Pausar Conferencia'
                            : 'Iniciar Conferencia',
                        icon: controller.iniciada
                            ? const Icon(
                                BootstrapIcons.pause_btn_fill,
                                color: Colors.white,
                                size: 33,
                              )
                            : const Icon(
                                BootstrapIcons.play_btn_fill,
                                color: Colors.white,
                                size: 33,
                              ),
                      ),
                      ButtonHeadForm(
                        title: 'Conferir Carrinho',
                        shortCut: 'F4',
                        shortCutActive: true,
                        onPressed: controller.btnAdicionarCarrinho,
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
                        title: 'Quebra de carrinho',
                        shortCut: 'F6',
                        shortCutActive: false,
                        onPressed: () {},
                        icon: const Icon(
                          BootstrapIcons.exclamation_circle_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                      ButtonHeadForm(
                        title: 'Ass. Agrupamento',
                        onPressed: () {},
                        shortCut: 'F7',
                        shortCutActive: false,
                        icon: const Icon(
                          BootstrapIcons.grid_3x3_gap_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                      ButtonHeadForm(
                        title: 'Finalizar Conferencia',
                        onPressed: controller.btnFinalizarConferencia,
                        shortCut: 'F12',
                        shortCutActive: true,
                        icon: const Icon(
                          BootstrapIcons.clipboard_check_fill,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                    ],
                  ),

                  //** CONFERIR CARRINHOS **//
                  ConferirCarrinhoPage(
                    size: Size(size.width, (size.height - 81) * .43),
                  ),

                  ConferidoCarrinhoPage(
                    size: Size(size.width, ((size.height - 81) * .57)),
                  ),

                  //** FOOTER **//
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
