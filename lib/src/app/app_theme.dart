import 'package:flutter/material.dart' as classic;

class AppTheme {
  static classic.ThemeData get classicTheme => classic.ThemeData(
        useMaterial3: true,
        brightness: classic.Brightness.light,
        primaryColor: classic.Colors.blueGrey,
        visualDensity: classic.VisualDensity.standard,
        colorScheme: classic.ColorScheme.fromSwatch(
            primarySwatch: classic.Colors.blueGrey),
        appBarTheme: classic.AppBarTheme(
          backgroundColor: classic.Colors.blueGrey[300],
          foregroundColor: classic.Colors.white,
        ),
      );
}
