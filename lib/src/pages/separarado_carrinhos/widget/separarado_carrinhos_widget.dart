import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid.dart';

class SeparadoCarrinhosWidget extends StatelessWidget {
  final Size size;

  const SeparadoCarrinhosWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparadoCarrinhosController>(
      //tag: 'separadoCarrinhos',
      builder: (controller) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Column(children: [
            Container(
              width: size.width,
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: Text(
                  'CARRINHOS SEPARADOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SeparadoCarrinhoGrid(),
            ),
          ]),
        );
      },
    );
  }
}
