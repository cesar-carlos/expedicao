import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid.dart';

class ConferirCarrinhosWidget extends StatelessWidget {
  final Size size;

  const ConferirCarrinhosWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirCarrinhosController>(
      //tag: 'conferirCarrinhos',
      builder: (controller) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Column(children: [
            Container(
              width: size.width,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  'CONFERENCIA CARRINHOS ${controller.expedicaoSituacaoDisplay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: ConferirCarrinhoGrid(),
            ),
          ]),
        );
      },
    );
  }
}
