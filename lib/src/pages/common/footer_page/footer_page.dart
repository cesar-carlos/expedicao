import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/common/footer_page/footer_page_controller.dart';
import 'package:app_expedicao/src/app/app_color.dart';

class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final processoExecutavel = Get.find<ProcessoExecutavelModel>();

    return GetBuilder<FooterPageController>(
      init: FooterPageController(),
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          height: 21,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColor.backGroundBar),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: controller.isConnected == true
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        controller.isConnected == true
                            ? const Text(
                                'Conectado',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              )
                            : const Text(
                                'Desconectado',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9,
                                ),
                              ),
                        Container(
                          height: 12,
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 2,
                            width: 20,
                          ),
                        ),
                        Text(
                          '${AppHelper.capitalize(processoExecutavel.origem)}: ${AppHelper.capitalize(processoExecutavel.codOrigem.toString())}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                        Container(
                          height: 12,
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 2,
                            width: 20,
                          ),
                        ),
                        Text(
                          '${AppHelper.capitalize(processoExecutavel.nomeUsuario)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: const Image(
                    image: AssetImage('assets/images/log_white32px.png'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Versão: 1.0.29',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
