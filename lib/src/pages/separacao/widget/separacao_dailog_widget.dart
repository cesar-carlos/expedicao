import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid.dart';

class SeparacaoDailogWidget {
  double height = 30;
  Size size = Get.size;
  final int codCarrinho;

  SeparacaoDailogWidget({required this.codCarrinho});

  Future<void> show() async {
    await showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.8,
          child: Column(children: [
            BarHeadFormElement(widthBar: size.width, title: 'Seração'),
            dailog(),
          ]),
        ),
      ),
    );
  }

  Widget dailog() {
    return SizedBox(
      width: size.width * 0.95,
      height: size.height * 0.8 - height,
      child: Column(children: [
        //** HEADER BUTTON **//
        SpaceButtonsHeadFormElement(
          width: double.infinity,
          children: [
            ButtonHeadForm(
              title: 'Separar tudo',
              onPressed: () {},
              icon: const Icon(
                //BootstrapIcons.list_check,
                BootstrapIcons.magic,
                color: Colors.white,
                size: 33,
              ),
            ),
            ButtonHeadForm(
              title: 'Reconferir tudo',
              onPressed: () {},
              icon: const Icon(
                BootstrapIcons.list_task,
                color: Colors.white,
                size: 33,
              ),
            ),
          ],
        ),

        //tabs
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: DefaultTabController(
              length: 2,
              animationDuration: const Duration(milliseconds: 100),
              child: Column(children: [
                Container(
                  color: Colors.white,
                  constraints: const BoxConstraints.expand(height: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TabBar(
                      indicatorColor: Colors.black45,
                      overlayColor: MaterialStateProperty.all(Colors.black12),
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
                      child: SeparacaoCarrinhoGrid(codCarrinho: codCarrinho),
                    ),
                    Container(
                      color: Colors.white70,
                      child: SepararGrid(),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        )
      ]),
    );
  }
}
