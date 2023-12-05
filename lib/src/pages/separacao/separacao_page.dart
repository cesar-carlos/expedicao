import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/separacao/widget/scan_item_widget.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid.dart';

class SeparacaoPage {
  late String title;
  double height = 30;
  Size size = Get.size;

  final SeparacaoController _controller;
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoPage(this.percursoEstagioConsulta)
      : _controller = SeparacaoController(percursoEstagioConsulta) {
    Get.lazyPut(() => _controller);
    title = _controller.viewMode
        ? 'Separação - Visualização'
        : 'Separação - Edição';
  }

  Future<void> show() async {
    await showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.8,
          child: Column(children: [
            BarHeadFormElement(widthBar: size.width, title: title),
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
              onPressed: _controller.onSepararTudo,
              icon: const Icon(
                BootstrapIcons.list_check,
                color: Colors.white,
                size: 33,
              ),
            ),
            ButtonHeadForm(
              title: 'Reconferir tudo',
              onPressed: _controller.onReconferirTudo,
              icon: const Icon(
                BootstrapIcons.list_task,
                color: Colors.white,
                size: 33,
              ),
            ),
          ],
        ),

        //LEITOR CODIGO DE BARRAS
        ScanItemWidget(percursoEstagioConsulta, size: size),

        //tabs
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: DefaultTabController(
              initialIndex: _controller.viewMode ? 0 : 1,
              length: 2,
              animationDuration: const Duration(milliseconds: 500),
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
                      child: SeparacaoCarrinhoGrid(percursoEstagioConsulta),
                    ),
                    Container(
                      color: Colors.white70,
                      child: const SepararGrid(),
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
