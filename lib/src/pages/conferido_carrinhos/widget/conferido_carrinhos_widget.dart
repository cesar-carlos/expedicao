import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid.dart';

class ConferidoCarrinhosWidget extends StatelessWidget {
  final Size size;

  const ConferidoCarrinhosWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferidoCarrinhosController>(
      //tag: 'conferidoCarrinhos',
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
                  'CARRINHOS',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Expanded(child: ConferidoCarrinhoGrid()),
          ]),
        );
      },
    );
  }
}
