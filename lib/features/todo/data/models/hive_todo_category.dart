import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../../utils/colors_and_icons.dart';
import '../../domain/models/todo_category.dart';

class TodoCategoryHive extends HiveObject {
  late int id;
  late String name;
  late int color;
  late Map<String, dynamic> icon;

  TodoCategory toDomain() {
    return TodoCategory(
      id: id,
      name: name,
      color: fromArgb32(color),
      icon: IconData(icon['code_point'], fontFamily: icon['font_family']),
    );
  }

  static TodoCategoryHive fromDomain(TodoCategory category) {
    return TodoCategoryHive()
      ..id = category.id
      ..name = category.name
      ..color = category.color.toARGB32()
      ..icon = {
        'code_point': category.icon.codePoint,
        'font_family': category.icon.fontFamily,
      };
  }

  TodoCategoryHive uncategorized() {
    return TodoCategoryHive()
      ..id = 00
      ..name = 'Uncategorized'
      ..color = 0xFF000000
      ..icon = {
        'code_point': Icons.task.codePoint,
        'font_family': Icons.task.fontFamily,
      };
  }
}
