import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_color.dart';

class AppTheme {
  static Brightness brightness(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context);

  static ThemeData get classicTheme {
    final brightness = Brightness.light;

    return ThemeData(
      brightness: brightness,
      primaryColor: AppColor.primaryColor,
      visualDensity: VisualDensity.standard,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.primarySwatch,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.backgroundColor,
        foregroundColor: AppColor.foregroundColor,
      ),
    );
  }
}
