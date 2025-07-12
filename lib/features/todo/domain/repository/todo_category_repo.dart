import 'package:dailycore/features/todo/domain/models/todo_category.dart';

abstract class TodoCategoryRepo {
  Future initializeCategory();

  Future<List<TodoCategory>> loadCategories();

  Future addCategory(TodoCategory newCategory);

  Future updateCategory(TodoCategory category);

  Future deleteCategory(TodoCategory category);
}
