import 'dart:math' show Random;

import 'package:flutter/material.dart';

Color dailyCoreGreen = Color.fromARGB(255, 48, 175, 146);
Color dailyCoreOrange = Color.fromARGB(255, 228, 162, 100);
Color dailyCoreRed = Color.fromARGB(255, 245, 85, 85);
Color dailyCoreBlue = Color.fromARGB(255, 69, 152, 216);

List<Color> colorSelections = [
  Color(0xFF16a085),
  Color(0xFF27ae60),
  Color(0xFF2980b9),
  Color(0xFF8e44ad),
  Color(0xFF2c3e50),
  Color(0xFFf1c40f),
  Color(0xFFe67e22),
  Color(0xFFe74c3c),
  Color(0xFFB33771),
  Color(0xFF82589F),
  Color(0xFFEAB543),
  Color(0xFF182C61),
  Color(0xFF2c2c54),
  Color(0xFF34ace0),
  Color(0xFFffb142),
];

List<IconData> iconSelections = [
  Icons.home,
  Icons.sports_gymnastics,
  Icons.book,
  Icons.games,
  Icons.cabin,
  Icons.account_box,
  Icons.palette,
  Icons.music_note,
  Icons.sledding_rounded,
  Icons.outdoor_grill,
  Icons.work_rounded,
  Icons.accessibility_rounded,
  Icons.account_balance_rounded,
  Icons.account_balance_wallet_rounded,
  Icons.airline_seat_individual_suite_rounded,
  Icons.airplanemode_active_rounded,
  Icons.airport_shuttle_rounded,
  Icons.sports_basketball_rounded,
  Icons.sports_esports_rounded,
  Icons.sports_motorsports_rounded,
  Icons.wysiwyg_rounded,
  Icons.wine_bar_rounded,
  Icons.weekend_rounded,
  Icons.bar_chart_rounded,
  Icons.bedtime_rounded,
  Icons.cake_rounded,
  Icons.shopping_bag,
  Icons.camera_alt_rounded,
  Icons.shopping_cart_rounded,
];

Color fromArgb32(int argb) => Color.fromARGB(
  (argb >> 24) & 0xFF,
  (argb >> 16) & 0xFF,
  (argb >> 8) & 0xFF,
  argb & 0xFF,
);

int randomIndex(int length) {
  final random = Random();
  return random.nextInt(length);
}
