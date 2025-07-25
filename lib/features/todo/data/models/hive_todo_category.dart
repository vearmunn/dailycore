import 'package:hive_ce/hive.dart';

import '../../../../utils/colors_and_icons.dart';
import '../../domain/models/todo_category.dart';

class TodoCategoryHive extends HiveObject {
  late int id;
  late String name;
  late int color;
  late String iconName;

  TodoCategory toDomain() {
    return TodoCategory(
      id: id,
      name: name,
      color: fromArgb32(color),
      iconName: iconName,
    );
  }

  static TodoCategoryHive fromDomain(TodoCategory category) {
    return TodoCategoryHive()
      ..id = category.id
      ..name = category.name
      ..color = category.color.toARGB32()
      ..iconName = category.iconName;
  }

  TodoCategoryHive uncategorized() {
    return TodoCategoryHive()
      ..id = 00
      ..name = 'Uncategorized'
      ..color = 0xFF000000
      ..iconName = 'task';
  }
}
