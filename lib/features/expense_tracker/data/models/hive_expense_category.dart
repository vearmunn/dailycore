import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/expense_category.dart';

class ExpenseCategoryHive extends HiveObject {
  late int id;
  late String name;
  late int color;
  late Map<String, dynamic> icon;
  late String type;

  ExpenseCategory toDomain() {
    return ExpenseCategory(
      id: id,
      name: name,
      color: fromArgb32(color),
      icon: IconData(icon['code_point'], fontFamily: icon['font_family']),
      type: type,
    );
  }

  static ExpenseCategoryHive fromDomain(ExpenseCategory category) {
    return ExpenseCategoryHive()
      ..id = category.id
      ..name = category.name
      ..color = category.color.toARGB32()
      ..icon = {
        'code_point': category.icon.codePoint,
        'font_family': category.icon.fontFamily,
      }
      ..type = category.type;
  }

  ExpenseCategoryHive uncategorized() {
    return ExpenseCategoryHive()
      ..id = 00
      ..name = 'Uncategorized'
      ..color = 0xFF000000
      ..icon = {
        'code_point': Icons.task.codePoint,
        'font_family': Icons.task.fontFamily,
      }
      ..type = 'Expense';
  }
}
