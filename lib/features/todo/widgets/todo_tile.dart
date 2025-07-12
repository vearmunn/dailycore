// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dailycore/features/todo/widgets/subtodo_tile.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors_and_icons.dart';
import '../../../utils/dates_utils.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo, required this.onTap});

  final Todo todo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 16, 0, todo.subTodos.isEmpty ? 10 : 0),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ExpandableNotifier(
          child: ScrollOnExpand(
            scrollOnCollapse: true,
            scrollOnExpand: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                verticalSpace(10),
                Expandable(
                  collapsed: SizedBox.shrink(),
                  expanded: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      context.read<TodoCrudCubit>().reorderSubTodo(
                        id: todo.id,
                        newIndex: newIndex,
                        oldIndex: oldIndex,
                        shouldLoadAllTodos: true,
                      );
                    },
                    itemCount: todo.subTodos.length,
                    itemBuilder: (context, index) {
                      return SubTodoTile(
                        key: ValueKey(todo.subTodos[index].id),
                        subTodo: todo.subTodos[index],
                        todo: todo,
                        shouldLoadAllTodos: true,
                      );
                    },
                  ),
                ),
                verticalSpace(todo.subTodos.isNotEmpty ? 12 : 0),
                todo.subTodos.isNotEmpty
                    ? Builder(
                      builder: (context) {
                        var controller =
                            ExpandableController.of(context, required: true)!;
                        return GestureDetector(
                          onTap: () => controller.toggle(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(40),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              controller.expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black38,
                            ),
                          ),
                        );
                      },
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final todoCubit = context.read<TodoCrudCubit>();

    Color getPriorityColor() {
      switch (todo.priority) {
        case 'Low':
          return dailyCoreGreen;
        case 'Medium':
          return dailyCoreOrange;
        case 'High':
          return dailyCoreRed;

        default:
          return Colors.transparent;
      }
    }

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          shape: CircleBorder(),
          value: todo.isCompleted,
          onChanged: (v) => todoCubit.toggleCompletion(todo),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, color: Colors.grey, size: 16),
                  horizontalSpace(4),
                  Text(
                    todo.dueDate == null
                        ? 'No due date'
                        : formattedDate(todo.dueDate!),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              verticalSpace(8),
              Text(
                todo.text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              verticalSpace(4),
              todo.category.name == 'none'
                  ? SizedBox.shrink()
                  : Text(
                    todo.category.name,
                    style: TextStyle(color: Colors.grey),
                  ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: getPriorityColor().withValues(
              alpha: todo.priority == '' ? 0 : 0.1,
            ),
          ),

          child: Text(
            todo.priority,
            style: TextStyle(
              color: getPriorityColor(),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
