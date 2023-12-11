import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/footer/footer_page.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_page.dart';
import 'package:app_expedicao/src/pages/conferir/widget/conferir_itens_widget.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';

class ConferirPage extends StatelessWidget {
  const ConferirPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<ConferirController>(
      builder: (controller) {
        return Scaffold(
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
                      // onPressed: !controller.iniciada
                      //     ? controller.iniciarConferencia
                      //     : controller.pausarConferencia
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
                      onPressed: () {}, //controller.adicionarCarrinho,
                      icon: const Icon(
                        BootstrapIcons.cart4,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    ButtonHeadForm(
                      title: 'Finalizar Conferencia',
                      onPressed: () {}, //controller.finalizarSeparacao,
                      icon: const Icon(
                        BootstrapIcons.grid_3x3_gap_fill,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ],
                ),

                //** CONFERIR CARRINHOS **//
                ConferirCarrinhoPage(
                  size: Size(size.width, (size.height - 81) * .4),
                ),

                //** CONFERIR ITENS **//
                ConferirItensWidget(
                  size: Size(size.width, ((size.height - 81) * .6)),
                ),

                //** FOOTER **//
                const FooterPage()
              ],
            ),
          ),
        );
      },
    );
  }
}
