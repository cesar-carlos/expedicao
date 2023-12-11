import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separarado_carrinhos/widget/separarado_carrinhos_widget.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/separarado_carrinhos_controller.dart';

class SeparadoCarrinhoPage extends StatelessWidget {
  final Size size;

  const SeparadoCarrinhoPage({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparadoCarrinhosController>(
      builder: (controller) {
        return SeparadoCarrinhosWidget(size: size);
      },
    );
  }
}
