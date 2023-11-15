import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';

class SepararCarrinhoGridFooter extends StatelessWidget {
  const SepararCarrinhoGridFooter({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SepararCarrinhoGridController>();

    return Container(
      height: 30,
      color: Colors.grey[200],
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(
          () => Text(
            'Total de Itens: ${controller.itens.length}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        )
      ]),
    );
  }
}
