import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/Identificacao/identificacao_controller.dart';

class IdentificacaoPage extends StatelessWidget {
  const IdentificacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return GetBuilder<IdentificacaoController>(
      builder: (_) => Scaffold(),
    );
  }
}
