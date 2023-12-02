import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';

class SepararGridFooter extends StatelessWidget {
  const SepararGridFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararGridController>(builder: (controller) {
      return Container(
        height: 30,
        color: Colors.grey[200],
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Total de Itens: ${controller.itens.length}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ]),
      );
    });
  }
}
