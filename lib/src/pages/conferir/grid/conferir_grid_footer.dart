import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';

class ConferirGridFooter extends StatelessWidget {
  const ConferirGridFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirGridController>(builder: (controller) {
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
