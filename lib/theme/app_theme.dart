import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: dailyCoreBlue,
      brightness: Brightness.light,
      primaryContainer: Colors.white,
    ),
    useMaterial3: true,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: dailyCoreBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: dailyCoreBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: dailyCoreBlue,
      brightness: Brightness.dark,
      primaryContainer: Colors.black,
    ),
    useMaterial3: true,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: dailyCoreBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: dailyCoreBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    ),
  );
}

Color primary(context) {
  return Theme.of(context).primaryColor;
}

Color bg(context) {
  return Theme.of(context).scaffoldBackgroundColor;
}
