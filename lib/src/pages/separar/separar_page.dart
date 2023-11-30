import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_page.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/separar/widget/separar_itens_widget.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/footer/footer_page.dart';

class SepararPage extends StatelessWidget {
  final ExpedicaoSepararConsultaModel separarConsulta;

  const SepararPage({
    super.key,
    required this.separarConsulta,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<SepararController>(
      init: SepararController(),
      builder: (controller) {
        return Scaffold(
          body: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //** HEADER BUTTON **//
                SpaceButtonsHeadFormElement(width: double.infinity, children: [
                  ButtonHeadForm(
                    title: controller.iniciada
                        ? 'Pausar Separação'
                        : 'Iniciar Separação',
                    onPressed: !controller.iniciada
                        ? controller.iniciarSeparacao
                        : controller.pausarSeparacao,
                    icon: !controller.iniciada
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
                    title: 'Adicionar Carrinho',
                    onPressed: controller.adicionarCarrinho,
                    icon: const Icon(
                      BootstrapIcons.cart4,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                ]),

                //** SEPARAR ITENS **//
                SepararItensWidget(
                  size: Size(size.width, ((size.height - 81) * .6)),
                ),

                //** SEPARAR CARRINHOS **//
                SepararCarrinhoPage(
                  size: Size(size.width, (size.height - 81) * .4),
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
