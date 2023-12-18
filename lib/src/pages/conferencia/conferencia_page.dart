import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid.dart';
import 'package:app_expedicao/src/pages/conferencia/widget/scan_conferencia_item_widget.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_head_form_element.dart';
import 'package:app_expedicao/src/pages/common/form_element/space_button_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid.dart';
import 'package:app_expedicao/src/pages/common/form_element/bar_head_form_element.dart';
import 'package:app_expedicao/src/pages/conferencia/conferencia_controller.dart';

class ConferenciaPage {
  late String title = 'Conferência';
  double height = 30;
  Size size = Get.size;

  final ConferenciaController _controller = Get.find();
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  ConferenciaPage(this.percursoEstagioConsulta) {
    title = _controller.viewMode
        ? 'Confereicia - Visualização'
        : 'Confereicia - Edição';
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
              title: 'Conferir tudo',
              onPressed: _controller.onConferirTudo,
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
            // ButtonHeadForm(
            //   title: 'Sobra de carrinho',
            //   onPressed: _controller.onSobraCarrinho,
            //   icon: const Icon(
            //     BootstrapIcons.exclamation_circle_fill,
            //     color: Colors.white,
            //     size: 33,
            //   ),
            // ),
          ],
        ),

        //LEITOR CODIGO DE BARRAS
        ScanConferenciaItemWidget(percursoEstagioConsulta, size: size),

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
                            'Conferencia',
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
                            'Carrinho',
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
                    ConferenciaCarrinhoGrid(percursoEstagioConsulta),
                    const ConferirGrid()
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
