import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/widget/separar_carrinhos_widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';

class SepararCarrinhoPage extends StatelessWidget {
  final Size size;

  const SepararCarrinhoPage({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararCarrinhosController>(
      builder: (controller) {
        return SepararCarrinhosWidget(size: size);
      },
    );
  }
}
