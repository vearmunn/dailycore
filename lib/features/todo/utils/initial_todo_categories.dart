import 'package:flutter/material.dart';

import '../domain/models/todo_category.dart';

final List<TodoCategory> initialTodoCategories = [
  TodoCategory(
    id: 00,
    name: 'Uncategorized',
    color: Colors.black,
    icon: Icons.task,
  ),
  TodoCategory(
    id: 1,
    name: 'Work',
    color: Color(0xFF4A90E2), // flat blue
    icon: Icons.work,
  ),
  TodoCategory(
    id: 2,
    name: 'Personal',
    color: Color(0xFF7ED6DF), // soft cyan
    icon: Icons.person,
  ),
  TodoCategory(
    id: 3,
    name: 'Shopping',
    color: Color(0xFFF19066), // warm orange
    icon: Icons.shopping_cart,
  ),
  TodoCategory(
    id: 4,
    name: 'Health',
    color: Color(0xFFEA7773), // calm red
    icon: Icons.fitness_center,
  ),
  TodoCategory(
    id: 5,
    name: 'Learning',
    color: Color(0xFF70A1FF), // lighter blue
    icon: Icons.school,
  ),
  TodoCategory(
    id: 6,
    name: 'Finance',
    color: Color(0xFF2ED573), // flat green
    icon: Icons.attach_money,
  ),
];
