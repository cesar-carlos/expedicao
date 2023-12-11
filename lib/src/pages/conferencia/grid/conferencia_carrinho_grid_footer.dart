import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';

class ConferenciaCarrinhoGridFooter extends StatelessWidget {
  final int codCarrinho;
  final String item;

  const ConferenciaCarrinhoGridFooter({
    super.key,
    required this.codCarrinho,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferenciaCarrinhoGridController>(builder: (controller) {
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
