import 'package:flutter/material.dart';

class CategoryData {
  late int id;
  late String categoryName;
  late double amount;
  late Color color;
  late IconData icon;

  CategoryData({
    required this.id,
    required this.categoryName,
    required this.amount,
    required this.color,
    required this.icon,
  });
}
