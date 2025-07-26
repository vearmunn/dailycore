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

final Map<String, IconData> iconMap = {
  'task': Icons.task,
  'home': Icons.home,
  'person': Icons.person,
  'attach_money': Icons.attach_money,
  'work': Icons.work,
  'school': Icons.school,
  'fitness_center': Icons.fitness_center,
  'shopping_cart': Icons.shopping_cart,
  'local_hospital': Icons.local_hospital,
  'flight_takeoff': Icons.flight_takeoff,
  'subscriptions': Icons.subscriptions,
  'book': Icons.book,
  'cake': Icons.cake,
  'movie': Icons.movie,
  'music_note': Icons.music_note,
  'directions_car': Icons.directions_car,
  'restaurant': Icons.restaurant,
  'directions_run': Icons.directions_run,
  'shopping_bag': Icons.shopping_bag,
  'pets': Icons.pets,
  'nightlight_round': Icons.nightlight_round,
  'wb_sunny': Icons.wb_sunny,
  'computer': Icons.computer,
  'build': Icons.build,
  'sports_esports': Icons.sports_esports,
  'trending_up': Icons.trending_up,
  'card_giftcard': Icons.card_giftcard,
  'more_horiz': Icons.more_horiz,
  'savings': Icons.savings,
  'camera_alt': Icons.camera_alt,
  'brush': Icons.brush,
  'local_cafe': Icons.local_cafe,
  'event': Icons.event,
  'phone': Icons.phone,
  'lock': Icons.lock,
  'lightbulb': Icons.lightbulb,
  'car_rental': Icons.car_rental,
  'bedtime': Icons.bedtime,
  'cleaning_services': Icons.cleaning_services,
  'map': Icons.map,
  'language': Icons.language,
  'handyman': Icons.handyman,
  'eco': Icons.eco,
  'group': Icons.group,
  'timer': Icons.timer,
  'mic': Icons.mic,
  'note': Icons.note,
  'wine_bar': Icons.wine_bar,
  'wallet': Icons.wallet,
  'gamepad': Icons.gamepad,
  'cancel_presentation_sharp': Icons.cancel_presentation_sharp,
};

IconData getIconByName(String name) {
  return iconMap[name] ?? iconMap['task']!;
}

String getIconNameByIcon(IconData icon) {
  return iconMap.entries
      .firstWhere(
        (entry) => entry.value == icon,
        orElse: () => const MapEntry('task', Icons.task),
      )
      .key;
}

IconData getIconByIndex(int index) {
  return iconMap.values.elementAt(index);
}

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

IconData getRandomIcon() {
  final random = Random();
  final values = iconMap.values.toList();
  return values[random.nextInt(values.length)];
}
