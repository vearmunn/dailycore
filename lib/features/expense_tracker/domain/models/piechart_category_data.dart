import 'package:flutter/material.dart';

class CategoryData {
  late int id;
  late String categoryName;
  late double amount;
  late Color color;
  late String iconName;

  CategoryData({
    required this.id,
    required this.categoryName,
    required this.amount,
    required this.color,
    required this.iconName,
  });
}
