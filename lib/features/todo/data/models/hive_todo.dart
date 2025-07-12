/* 

HIVE TO DO MODEL

*/

import 'package:dailycore/features/todo/data/models/hive_todo_category.dart';
import 'package:dailycore/features/todo/domain/models/todo.dart';
import 'package:hive_ce/hive.dart';

class TodoHive extends HiveObject {
  late int id;
  late String text;
  late bool isCompleted;
  late DateTime? dueDate;
  late String priority;
  late TodoCategoryHive category;
  late List<Map<String, dynamic>> subTodos;
  late DateTime? repeatDate;

  // convert hive object -> pure todo object to use in this app.
  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
      category: category.toDomain(),
      repeatDate: repeatDate,
      subTodos: subTodos.map((todo) => SubTodo.fromMap(todo)).toList(),
    );
  }

  // convert pure todo object -> hive object to store in hive db.
  static TodoHive fromDomain(Todo todo) {
    return TodoHive()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted
      ..dueDate = todo.dueDate
      ..priority = todo.priority
      ..category = TodoCategoryHive.fromDomain(todo.category)
      ..repeatDate = todo.repeatDate
      ..subTodos = todo.subTodos.map((todo) => todo.toMap()).toList();
  }
}
