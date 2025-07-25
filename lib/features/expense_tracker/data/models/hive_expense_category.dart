import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/expense_category.dart';

class ExpenseCategoryHive extends HiveObject {
  late int id;
  late String name;
  late int color;
  late String iconName;
  late String type;

  ExpenseCategory toDomain() {
    return ExpenseCategory(
      id: id,
      name: name,
      color: fromArgb32(color),
      iconName: iconName,
      type: type,
    );
  }

  static ExpenseCategoryHive fromDomain(ExpenseCategory category) {
    return ExpenseCategoryHive()
      ..id = category.id
      ..name = category.name
      ..color = category.color.toARGB32()
      ..iconName = category.iconName
      ..type = category.type;
  }

  ExpenseCategoryHive uncategorized() {
    return ExpenseCategoryHive()
      ..id = 00
      ..name = 'Uncategorized'
      ..color = 0xFF000000
      ..iconName = 'task'
      ..type = 'Expense';
  }
}
