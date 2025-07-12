import 'package:dailycore/features/todo/data/models/hive_todo.dart';
import 'package:dailycore/features/todo/data/models/hive_todo_category.dart';
import 'package:dailycore/features/todo/domain/models/todo_category.dart';
import 'package:dailycore/features/todo/domain/repository/todo_category_repo.dart';
import 'package:hive_ce/hive.dart';

import '../../../../hive_boxes/boxes.dart';

class HiveTodoCategoryRepo implements TodoCategoryRepo {
  final box = Hive.box<TodoCategoryHive>(todoCategoryBox);
  final todosBox = Hive.box<TodoHive>(todoBox);
  @override
  Future<List<TodoCategory>> loadCategories() async {
    final categoryList = box.values;

    return categoryList.map((category) => category.toDomain()).toList();
  }

  @override
  Future addCategory(TodoCategory newCategory) async {
    final categoryHive = TodoCategoryHive.fromDomain(newCategory);
    return box.add(categoryHive);
  }

  @override
  Future deleteCategory(TodoCategory category) async {
    TodoCategoryHive soonToBeDeletedCategory = box.values.firstWhere(
      (categoryFromBox) => categoryFromBox.id == category.id,
    );

    final todos = todosBox.values.map((todo) => todo).toList();
    for (var todo in todos) {
      if (todo.category.id == category.id) {
        await todo.delete();
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
    updatingCategory.save();
  }

  @override
  Future initializeCategory() async {
    final theNoneCategory = box.values.any((category) => category.id == 0);
    if (!theNoneCategory) {
      box.add(TodoCategoryHive.fromDomain(TodoCategory(id: 0, name: 'none')));
    }
  }
}
