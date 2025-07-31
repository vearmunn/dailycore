/*

DATABASE REPO

This implements the todo repo and handles storing, retrieving, updating,
deleting in the isar db.

*/

import 'package:dailycore/features/todo/data/models/hive_todo_category.dart';
import 'package:dailycore/features/todo/domain/models/todo.dart';
import 'package:dailycore/features/todo/domain/repository/todo_repo.dart';
import 'package:dailycore/consts/boxes.dart';
import 'package:hive_ce/hive.dart';

import '../models/hive_todo.dart';

class HiveTodoRepo implements TodoRepo {
  final box = Hive.box<TodoHive>(todoBox);

  // get todos
  @override
  Future<List<Todo>> getTodos() async {
    final todoList = box.values;
    return todoList.map((todo) => todo.toDomain()).toList();
  }

  @override
  Future<Todo> getSingleTodo(int id) async {
    final singleTodo = box.values.firstWhere((todo) => todo.id == id);
    return singleTodo.toDomain();
  }

  // add todo
  @override
  Future addTodo(Todo newTodo) async {
    final todoHive = TodoHive.fromDomain(newTodo);
    return box.add(todoHive);
  }

  // update todo
  @override
  Future toggleTodo(Todo todo) async {
    TodoHive togglingTodo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == todo.id,
    );
    togglingTodo.isCompleted = !togglingTodo.isCompleted;
    for (var subTodo in togglingTodo.subTodos) {
      subTodo['isCompleted'] = togglingTodo.isCompleted;
    }
    togglingTodo.save();
  }

  // delete todo
  @override
  Future deleteTodo(Todo todo) async {
    TodoHive soonToBeDeletedTodo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == todo.id,
    );
    await soonToBeDeletedTodo.delete();
  }

  // update todo
  @override
  Future updateTodo(Todo todo) async {
    TodoHive updatingTodo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == todo.id,
    );

    updatingTodo.text = todo.text;
    updatingTodo.dueDate = todo.dueDate;
    updatingTodo.category = TodoCategoryHive.fromDomain(todo.category);
    updatingTodo.priority = todo.priority;
    updatingTodo.repeatDate = todo.repeatDate;
    updatingTodo.shouldAddToExpense = todo.shouldAddToExpense;
    updatingTodo.timeReminder = todo.timeReminder;
    updatingTodo.subTodos =
        todo.subTodos.map((subtodo) => subtodo.toMap()).toList();

    updatingTodo.save();
  }

  // add new subtodo
  @override
  Future addSubTodo(int id, SubTodo subTodo) async {
    TodoHive updatingTodo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == id,
    );

    updatingTodo.subTodos.add(subTodo.toMap());

    updatingTodo.save();
  }

  // toggle subtodo
  @override
  Future toggleSubTodo(int id, SubTodo subTodo) async {
    TodoHive todo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == id,
    );
    final togglingSubTodo = todo.subTodos.firstWhere(
      (subTodoFromBox) => subTodoFromBox['id'] == subTodo.id,
    );

    togglingSubTodo['isCompleted'] = !togglingSubTodo['isCompleted'];
    for (var subTodo in todo.subTodos) {
      if (subTodo['isCompleted'] == false) {
        todo.isCompleted = false;
      }
    }
    todo.save();
  }

  // delete subtodo
  @override
  Future deleteSubTodo(int id, SubTodo subTodo) async {
    TodoHive todo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == id,
    );
    todo.subTodos.removeWhere(
      (subTodoFromBox) => subTodoFromBox['id'] == subTodo.id,
    );

    todo.save();
  }

  // update subtodo
  @override
  Future updateSubTodo(int id, SubTodo subTodo) async {
    TodoHive todo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == id,
    );
    final updatingSubTodo = todo.subTodos.firstWhere(
      (subTodoFromBox) => subTodoFromBox['id'] == subTodo.id,
    );

    updatingSubTodo['text'] = subTodo.text;

    todo.save();
  }

  @override
  Future reorderSubTodo({
    required int id,
    required int oldIndex,
    required int newIndex,
  }) async {
    TodoHive todo = box.values.firstWhere(
      (todoFromBox) => todoFromBox.id == id,
    );

    // an adjustment needed when moving down the list
    if (oldIndex < newIndex) {
      newIndex--;
    }

    // get the subTodo we're moving
    final subTodo = todo.subTodos.removeAt(oldIndex);

    // place the subTodo in the newPosition
    todo.subTodos.insert(newIndex, subTodo);

    todo.save();
  }
}
