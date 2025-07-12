// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/delete_confirmation.dart';
import '../domain/models/todo.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import '../utils/todo_utils.dart';

class SubTodoTile extends StatelessWidget {
  const SubTodoTile({
    super.key,
    required this.subTodo,
    required this.todo,
    this.shouldLoadAllTodos = false,
  });

  final SubTodo subTodo;
  final Todo todo;
  final bool shouldLoadAllTodos;

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCrudCubit>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Dismissible(
        key: ValueKey(subTodo.id),
        confirmDismiss: (direction) async {
          return await showDeleteBox(context, 'Delete this sub todo?');
        },
        onDismissed: (direction) {
          context.read<TodoCrudCubit>().deleteSubtodo(
            todo.id,
            subTodo,
            shouldLoadAllTodos: shouldLoadAllTodos,
          );
        },
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Checkbox(
                shape: CircleBorder(),
                value: subTodo.isCompleted,
                onChanged:
                    (v) => todoCubit.toggleSubTodoCompletion(
                      todo.id,
                      subTodo,
                      shouldLoadAllTodos: shouldLoadAllTodos,
                    ),
              ),
              title: Text(subTodo.text, style: TextStyle(fontSize: 14)),
              trailing: Icon(Icons.drag_indicator, color: Colors.black12),
              onTap:
                  () => showEditSubTodoBox(
                    context,
                    todo.id,
                    subTodo,
                    shouldLoadAllTodos,
                  ),
            ),
            Divider(indent: 30, endIndent: 20),
          ],
        ),
      ),
    );
  }
}
