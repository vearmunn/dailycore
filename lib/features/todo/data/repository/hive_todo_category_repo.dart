import 'package:dailycore/features/todo/data/models/hive_todo.dart';
import 'package:dailycore/features/todo/data/models/hive_todo_category.dart';
import 'package:dailycore/features/todo/domain/models/todo_category.dart';
import 'package:dailycore/features/todo/domain/repository/todo_category_repo.dart';
import 'package:dailycore/features/todo/utils/initial_todo_categories.dart';
import 'package:hive_ce/hive.dart';

import '../../../../hive_boxes/boxes.dart';

class HiveTodoCategoryRepo implements TodoCategoryRepo {
  final box = Hive.box<TodoCategoryHive>(todoCategoryBox);
  final todosBox = Hive.box<TodoHive>(todoBox);
  @override
  Future<List<TodoCategory>> loadCategories() async {
    var categoryList =
        box.values.map((category) => category.toDomain()).toList();
    return categoryList;
  }

  @override
  Future addCategory(TodoCategory newCategory) async {
    final categoryHive = TodoCategoryHive.fromDomain(newCategory);
    return box.add(categoryHive);
  }

  @override
  Future deleteCategory(int id) async {
    TodoCategoryHive soonToBeDeletedCategory = box.values.firstWhere(
      (categoryFromBox) => categoryFromBox.id == id,
    );

    final todos = todosBox.values.map((todo) => todo).toList();
    for (var todo in todos) {
      if (todo.category.id == id) {
        todo.category = TodoCategoryHive().uncategorized();
        await todo.save();
      }
    }

    await soonToBeDeletedCategory.delete();
  }

  @override
  Future updateCategory(TodoCategory category) async {
    TodoCategoryHive updatingCategory = box.values.firstWhere(
      (categoryFromBox) => categoryFromBox.id == category.id,
    );

    updatingCategory.name = category.name;
    updatingCategory.color = category.color.toARGB32();
    updatingCategory.iconName = category.iconName;
    final todos = todosBox.values.map((todo) => todo).toList();
    for (var todo in todos) {
      if (todo.category.id == category.id) {
        todo.category.name = category.name;
        todo.category.iconName = category.iconName;
        todo.category.color = category.color.toARGB32();
        await todo.save();
      }
    }
    updatingCategory.save();
  }

  @override
  Future initializeCategory() async {
    final uncategorizedCategory = box.values.any(
      (category) => category.id == 00,
    );
    if (!uncategorizedCategory) {
      for (var category in initialTodoCategories) {
        box.add(TodoCategoryHive.fromDomain(category));
      }
    }
  }
}
