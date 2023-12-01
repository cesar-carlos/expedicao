import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/splash/widget/splash_error_widget.dart';

class SplashErrorPage extends StatelessWidget {
  final String erroCode;
  const SplashErrorPage({super.key, required this.erroCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashErrorWidget(erroCode: erroCode),
    );
  }
}
