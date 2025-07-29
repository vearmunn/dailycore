// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../localization/locales.dart';
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
          return await showDeleteBox(
            context,
            AppLocale.deleteThisSubTodo.getString(context),
          );
        },
        onDismissed: (direction) {
          context.read<TodoCrudCubit>().deleteSubtodo(
            todo.id,
            subTodo,
            shouldLoadAllTodos: shouldLoadAllTodos,
          );
          errorToast(context, AppLocale.subTodoDeleted.getString(context));
        },
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.drag_indicator,
                color:
                    ThemeHelper.isDark(context)
                        ? Colors.white24
                        : Colors.black12,
              ),
              title: Text(subTodo.text, style: TextStyle(fontSize: 14)),
              trailing: Checkbox(
                checkColor: Colors.white,
                shape: CircleBorder(),
                value: subTodo.isCompleted,
                onChanged:
                    (v) => todoCubit.toggleSubTodoCompletion(
                      todo.id,
                      subTodo,
                      shouldLoadAllTodos: shouldLoadAllTodos,
                    ),
              ),
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
