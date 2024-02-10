import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';

class CarrinhosAgruparGridFooter extends StatelessWidget {
  const CarrinhosAgruparGridFooter({super.key});

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;

    return GetBuilder<CarrinhosAgruparGridController>(
      builder: (controller) {
        return Container(
          height: 54,
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
      },
    );
  }
}
