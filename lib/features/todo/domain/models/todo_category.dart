import 'package:flutter/material.dart';

class TodoCategory {
  final int id;
  final String name;
  final Color color;
  final String iconName;

  TodoCategory({
    required this.id,
    required this.name,
    this.color = Colors.black,
    this.iconName = 'task',
  });
}

TodoCategory uncategorized() {
  return TodoCategory(
    id: 00,
    name: 'Uncategorized',
    color: Colors.black,
    iconName: 'task',
  );
}
