import 'package:hive_ce/hive.dart';

import '../../domain/models/todo_category.dart';

class TodoCategoryHive extends HiveObject {
  late int id;
  late String name;

  TodoCategory toDomain() {
    return TodoCategory(id: id, name: name);
  }

  static TodoCategoryHive fromDomain(TodoCategory category) {
    return TodoCategoryHive()
      ..id = category.id
      ..name = category.name;
  }
}
