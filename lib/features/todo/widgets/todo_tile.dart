import 'package:dailycore/features/expense_tracker/presentation/pages/add_edit_expense_page.dart';
import 'package:dailycore/features/todo/widgets/subtodo_tile.dart';
import 'package:dailycore/theme/theme_helper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../localization/locales.dart';
import '../../../utils/colors_and_icons.dart';
import '../../../utils/dates_utils.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({super.key, required this.todo, required this.onTap});

  final Todo todo;
  final VoidCallback onTap;

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  late bool checked;
  @override
  void initState() {
    checked = widget.todo.isCompleted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          16,
          0,
          widget.todo.subTodos.isEmpty ? 10 : 0,
        ),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ThemeHelper.containerColor(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!ThemeHelper.isDark(context))
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
                        id: widget.todo.id,
                        newIndex: newIndex,
                        oldIndex: oldIndex,
                        shouldLoadAllTodos: true,
                      );
                    },
                    itemCount: widget.todo.subTodos.length,
                    itemBuilder: (context, index) {
                      return SubTodoTile(
                        key: ValueKey(widget.todo.subTodos[index].id),
                        subTodo: widget.todo.subTodos[index],
                        todo: widget.todo,
                        shouldLoadAllTodos: true,
                      );
                    },
                  ),
                ),
                verticalSpace(widget.todo.subTodos.isNotEmpty ? 12 : 0),
                widget.todo.subTodos.isNotEmpty
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
                              color: dailyCoreBlue.withAlpha(
                                ThemeHelper.isDark(context) ? 200 : 100,
                              ),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              controller.expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color:
                                  ThemeHelper.isDark(context)
                                      ? Colors.white
                                      : Colors.black38,
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
      switch (widget.todo.priority) {
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

    String getPriorityText() {
      switch (widget.todo.priority) {
        case 'Low':
          return AppLocale.low.getString(context);
        case 'Medium':
          return AppLocale.medium.getString(context);
        case 'High':
          return AppLocale.high.getString(context);

        default:
          return '';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(8),
                Text(
                  widget.todo.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                verticalSpace(8),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        getPriorityText(),
                        style: TextStyle(
                          color: getPriorityColor(),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      if (widget.todo.priority.isNotEmpty) VerticalDivider(),
                      widget.todo.category.id == 00
                          ? SizedBox.shrink()
                          : Text(
                            widget.todo.category.name,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                      if (widget.todo.category.id != 00) VerticalDivider(),
                      Text(
                        widget.todo.dueDate == null
                            ? 'No due date'
                            : formattedDateAndTime(widget.todo.dueDate!),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            checkColor: Colors.white,
            shape: CircleBorder(),
            value: checked,
            onChanged: (v) async {
              setState(() {
                checked = v!;
              });
              await Future.delayed(Duration(milliseconds: 300));
              todoCubit.toggleCompletion(widget.todo);
              if (widget.todo.shouldAddToExpense &&
                  widget.todo.isCompleted == false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddEditExpensePage(
                          isFromTodoOrHabit: true,
                          noteFromTodoOrHabit: widget.todo.text,
                        ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
