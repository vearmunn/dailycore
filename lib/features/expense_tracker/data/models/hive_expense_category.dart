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
      color: color,
      icon: icon,
      type: type,
    );
  }

  static ExpenseCategoryHive fromDomain(ExpenseCategory category) {
    return ExpenseCategoryHive()
      ..id = category.id
      ..name = category.name
      ..color = category.color
      ..icon = category.icon
      ..type = category.type;
  }
}
