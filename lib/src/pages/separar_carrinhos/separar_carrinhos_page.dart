import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';

class SepararCarrinhoPage extends StatelessWidget {
  const SepararCarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararCarrinhosController>(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Separar Carrinho',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
