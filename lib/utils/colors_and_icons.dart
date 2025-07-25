import 'dart:math' show Random;

import 'package:flutter/material.dart';

const Color dailyCoreGreen = Color.fromARGB(255, 48, 175, 146);
const Color dailyCoreOrange = Color.fromARGB(255, 228, 162, 100);
const Color dailyCoreRed = Color.fromARGB(255, 245, 85, 85);
const Color dailyCoreBlue = Color.fromARGB(255, 69, 152, 216);

List<Color> colorSelections = [
  Color(0xFF16a085), // greenish teal
  Color(0xFF27ae60), // emerald
  Color(0xFF2980b9), // blue
  Color(0xFF8e44ad), // purple
  Color(0xFF2c3e50), // dark blue gray
  Color(0xFFf39c12), // orange yellow
  Color(0xFFd35400), // pumpkin
  Color(0xFFc0392b), // red
  Color(0xFF7f8c8d), // gray
  Color(0xFF34495e), // navy blue
  Color(0xFFe67e22), // carrot
  Color(0xFF1abc9c), // turquoise
  Color(0xFF9b59b6), // amethyst
  Color(0xFF3498db), // peter river
  Color(0xFFe74c3c), // alizarin
  Color(0xFFf1c40f), // sun flower
  Color(0xFFe84393), // pink
  Color(0xFF00cec9), // cyan
  Color(0xFF6c5ce7), // indigo
  Color(0xFF74b9ff), // light blue
];

List<IconData> iconSelections = [
  Icons.home,
  Icons.work,
  Icons.school,
  Icons.fitness_center,
  Icons.shopping_cart,
  Icons.local_hospital,
  Icons.flight_takeoff,
  Icons.book,
  Icons.cake,
  Icons.movie,
  Icons.music_note,
  Icons.restaurant,
  Icons.directions_run,
  Icons.pets,
  Icons.nightlight_round,
  Icons.wb_sunny,
  Icons.computer,
  Icons.build,
  Icons.sports_esports,
  Icons.savings,
  Icons.camera_alt,
  Icons.brush,
  Icons.local_cafe,
  Icons.event,
  Icons.phone,
  Icons.lock,
  Icons.lightbulb,
  Icons.car_rental,
  Icons.bedtime,
  Icons.cleaning_services,
  Icons.map,
  Icons.language,
  Icons.handyman,
  Icons.eco,
  Icons.group,
  Icons.timer,
  Icons.mic,
  Icons.note,
  Icons.wine_bar,
  Icons.wallet,
  Icons.gamepad,
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
