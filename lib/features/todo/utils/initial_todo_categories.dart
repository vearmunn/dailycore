import 'package:flutter/material.dart';

import '../domain/models/todo_category.dart';

final List<TodoCategory> initialTodoCategories = [
  TodoCategory(
    id: 00,
    name: 'Uncategorized',
    color: Colors.black,
    iconName: 'task',
  ),
  TodoCategory(
    id: 1,
    name: 'Work',
    color: Color(0xFF4A90E2), // flat blue
    iconName: 'work',
  ),
  TodoCategory(
    id: 2,
    name: 'Personal',
    color: Color(0xFF7ED6DF), // soft cyan
    iconName: 'person',
  ),
  TodoCategory(
    id: 3,
    name: 'Shopping',
    color: Color(0xFFF19066), // warm orange
    iconName: 'shopping_cart',
  ),
  TodoCategory(
    id: 4,
    name: 'Health',
    color: Color(0xFFEA7773), // calm red
    iconName: 'fitness_center',
  ),
  TodoCategory(
    id: 5,
    name: 'Learning',
    color: Color(0xFF70A1FF), // lighter blue
    iconName: 'school',
  ),
  TodoCategory(
    id: 6,
    name: 'Finance',
    color: Color(0xFF2ED573), // flat green
    iconName: 'attach_money',
  ),
];
