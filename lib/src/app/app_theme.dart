import 'package:flutter/material.dart' as classic;
import 'package:fluent_ui/fluent_ui.dart' as fluent;

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

  static fluent.FluentThemeData get fluentTheme => fluent.FluentThemeData(
        scaffoldBackgroundColor: fluent.Colors.white,
        visualDensity: fluent.VisualDensity.adaptivePlatformDensity,
        brightness: fluent.Brightness.light,
        accentColor: fluent.Colors.green,
        selectionColor: const classic.Color.fromARGB(255, 174, 204, 192),
      );

  static fluent.FluentThemeData get fluentDarkTheme => fluent.FluentThemeData(
        scaffoldBackgroundColor: fluent.Colors.black,
        visualDensity: fluent.VisualDensity.adaptivePlatformDensity,
        brightness: fluent.Brightness.dark,
        accentColor: fluent.Colors.green,
        selectionColor: const classic.Color.fromARGB(255, 174, 204, 192),
      );
}
