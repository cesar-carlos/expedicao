import 'package:flutter/material.dart';

class AppTheme {
  static Brightness brightness(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context);

  static ThemeData get classicTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey,
        visualDensity: VisualDensity.standard,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[300],
          foregroundColor: Colors.white,
        ),
      );
}
