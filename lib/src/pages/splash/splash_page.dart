import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/splash/splash_controller.dart';
import 'package:app_expedicao/src/pages/splash/widget/carregando_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (controller) {
      return SizedBox.expand(
        child: ListenableBuilder(
          listenable: controller,
          builder: (BuildContext context, Widget? child) {
            if (controller.isLoad) return const CarregandoWidget();

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
