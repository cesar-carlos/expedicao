import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/footer/footer_page_controller.dart';
import 'package:app_expedicao/src/app/app_color.dart';

class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FooterPageController>(builder: (controller) {
      return SizedBox(
        width: double.infinity,
        height: 21,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: AppColor.backGroundBar),
          child: Row(
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    // controller.isConnected == true
                    //     ? const Icon(
                    //         BootstrapIcons.database_fill_check,
                    //         color: Colors.white,
                    //         size: 15,
                    //       )
                    //     : const Icon(
                    //         BootstrapIcons.database_fill_x,
                    //         color: Colors.red,
                    //         size: 15,
                    //       ),
                    // const SizedBox(width: 5),
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
                  ],
                ),
              ),
              const Spacer(),
              const Image(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/log_white32px.png'),
              ),
              const Spacer(),
              Container(
                width: 200,
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Versão: 1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
