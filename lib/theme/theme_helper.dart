import 'package:flutter/material.dart';

class ThemeHelper {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color defaultTextColor(BuildContext context) {
    return isDark(context) ? Colors.white : Colors.black;
  }

  static Color secondaryTextColor(BuildContext context) {
    return isDark(context)
        ? Colors.white.withAlpha(180) // softer white
        : Colors.black54;
  }

  static Color containerColor(BuildContext context) {
    return isDark(context) ? Color(0xFF212121) : Colors.white;
  }
}
