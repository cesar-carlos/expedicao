import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/splash/widget/splash_error_widget.dart';

class SplashErrorPage extends StatelessWidget {
  final String detail;
  const SplashErrorPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashErrorWidget(detail: detail),
    );
  }
}
