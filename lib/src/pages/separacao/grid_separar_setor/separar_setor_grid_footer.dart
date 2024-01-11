import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_controller.dart';

class SepararSetorGridFooter extends StatelessWidget {
  const SepararSetorGridFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararSetorGridController>(builder: (controller) {
      return Container(
        height: 30,
        color: Colors.grey[200],
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Total de Itens: ${controller.itensSort.length}',
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
