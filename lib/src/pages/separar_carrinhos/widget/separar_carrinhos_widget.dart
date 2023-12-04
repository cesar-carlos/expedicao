import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid.dart';

class SepararCarrinhosWidget extends StatelessWidget {
  final Size size;

  const SepararCarrinhosWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararCarrinhosController>(
      //tag: 'separarCarrinhos',
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SepararCarrinhoGrid(),
            ),
          ]),
        );
      },
    );
  }
}
