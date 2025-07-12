/*

TO DO REPOSITORY

Define what the app can do.

Notes:
- The repo in the domain layer outlines what operations the app can do, but doesn't
  worry about the specific implementation details. That's for the data layer.

- This layer is independent of any technology or framework.

*/

import 'package:dailycore/features/todo/domain/models/todo.dart';

abstract class TodoRepo {
  // get list of todos
  Future<List<Todo>> getTodos();

  // get list of todos
  Future<Todo> getSingleTodo(int id);

  // add a new todo
  Future addTodo(Todo newTodo);

  // update an existing todo
  Future updateTodo(Todo todo);

  // toggle an existing todo
  Future toggleTodo(Todo todo);

  // delete a todo
  Future deleteTodo(Todo todo);

  // add a subtodo
  Future addSubTodo(int id, SubTodo subTodo);

  // toggle a subtodo
  Future toggleSubTodo(int id, SubTodo subTodo);

  // update a subtodo
  Future updateSubTodo(int id, SubTodo subTodo);

  // delete a subtodo
  Future deleteSubTodo(int id, SubTodo subTodo);

  // reorder subtodos
  Future reorderSubTodo({
    required int id,
    required int oldIndex,
    required int newIndex,
  });
}
