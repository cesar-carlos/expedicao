import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separacao/separacao_controller.dart';

class SeparacaoCarrinhoPage extends StatelessWidget {
  const SeparacaoCarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoController>(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Separacao Carrinho',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
