import 'package:flutter/material.dart';

class TodoCategory {
  final int id;
  final String name;
  final Color color;
  final IconData icon;

  TodoCategory({
    required this.id,
    required this.name,
    this.color = Colors.black,
    this.icon = Icons.task,
  });
}
