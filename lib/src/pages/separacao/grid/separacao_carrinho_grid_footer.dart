import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';

class SeparacaoCarrinhoGridFooter extends StatelessWidget {
  final controller = Get.find<SeparacaoCarrinhoGridController>();
  final int codCarrinho;
  SeparacaoCarrinhoGridFooter({super.key, required this.codCarrinho});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[200],
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(() => Text(
              'Total de Itens: ${controller.itensCarrinho(codCarrinho: codCarrinho).length}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ))
      ]),
    );
  }
}
