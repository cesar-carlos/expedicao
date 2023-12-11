import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/conferido_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/widget/conferido_carrinhos_widget.dart';

class ConferidoCarrinhoPage extends StatelessWidget {
  final Size size;

  const ConferidoCarrinhoPage({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferidoCarrinhosController>(
      builder: (controller) {
        return ConferidoCarrinhosWidget(size: size);
      },
    );
  }
}
