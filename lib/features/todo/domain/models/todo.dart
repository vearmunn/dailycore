// ignore_for_file: public_member_api_docs, sort_constructors_first
/* TO DO MODEL

Define what todo object is like

*/

import 'package:dailycore/features/todo/domain/models/todo_category.dart';

class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final DateTime? dueDate;
  final String priority;
  final TodoCategory category;
  final List<SubTodo> subTodos;
  final DateTime? repeatDate;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false,
    this.priority = '',
    this.dueDate,
    required this.category,
    this.repeatDate,
    this.subTodos = const [],
  });
}

class SubTodo {
  final int id;
  final String text;
  final bool isCompleted;

  SubTodo({required this.id, required this.text, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory SubTodo.fromMap(Map<String, dynamic> map) {
    return SubTodo(
      id: map['id'] as int,
      text: map['text'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}
