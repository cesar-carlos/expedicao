import 'package:app_expedicao/src/pages/separar_carrinhos/widget/separar_carrinhos_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/separar/widget/separar_itens_widget.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/footer/footer_page.dart';

class SepararPage extends StatelessWidget {
  final ProcessoExecutavelModel processoExecutavel;
  const SepararPage({super.key, required this.processoExecutavel});

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

                // //** SEPARAR CARRINHOS **//
                SepararCarrinhosWidget(
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
