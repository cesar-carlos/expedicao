import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferir_carrinhos/widget/conferir_carrinhos_widget.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/conferir_carrinhos_controller.dart';

class ConferirCarrinhoPage extends StatelessWidget {
  final Size size;

  const ConferirCarrinhoPage({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirCarrinhosController>(
      builder: (controller) {
        return ConferirCarrinhosWidget(size: size);
      },
    );
  }
}
