import 'package:flutter/material.dart';

class ExpenseCategory {
  final int id;
  final String name;
  final Color color;
  final IconData icon;
  final String type;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.type,
    this.color = Colors.black,
    this.icon = Icons.task,
  });
}
