// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/todo/domain/models/todo.dart';
import 'package:dailycore/features/todo/utils/todo_utils.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../components/custom_textfield.dart';
import '../../../components/date_picker/pick_date.dart';
import '../../../components/date_picker/pick_date_cubit.dart';
import '../../../localization/locales.dart';
import '../../../utils/delete_confirmation.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo_category.dart';
import '../presentation/cubit/category_cubit/category_cubit.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'subtodo_tile.dart';

class TodoDetails extends StatefulWidget {
  final Todo todo;

  const TodoDetails({super.key, required this.todo});

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  late TextEditingController todoController;
  late TodoCategory selectedCategory;
  late String selectedPriority;
  late bool shouldAddToExpense;
  late int selectedTimeReminder;

  @override
  void initState() {
    todoController = TextEditingController(text: widget.todo.text);

    selectedCategory = TodoCategory(
      id: widget.todo.category.id,
      name: widget.todo.category.name,
    );
    selectedPriority = widget.todo.priority;
    selectedTimeReminder = widget.todo.timeReminder;
    shouldAddToExpense = widget.todo.shouldAddToExpense;
    print(widget.todo.timeReminder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCrudCubit>();

    return Stack(
      children: [
        // FORM-------------------------------------------------------------------------------
        ListView(
          padding: EdgeInsets.all(20),
          children: [
            customTextfield(
              context,
              AppLocale.whatIsTobeDone.getString(context),
              todoController,
            ),
            verticalSpace(28),
            BlocBuilder<TodoCategoryCubit, TodoCategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  final initialValue = state.categoryList.indexWhere(
                    (category) => category.id == selectedCategory.id,
                  );
                  return DropdownMenu(
                    width: double.infinity,
                    inputDecorationTheme: InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    label: Text(AppLocale.selectCategory.getString(context)),
                    initialSelection: state.categoryList[initialValue],
                    onSelected: (value) {
                      selectedCategory = value!;
                    },
                    dropdownMenuEntries: List.generate(
                      state.categoryList.length,
                      (index) => DropdownMenuEntry(
                        value: state.categoryList[index],
                        label: state.categoryList[index].name,
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            verticalSpace(20),
            Text('Deadline'),
            verticalSpace(8),
            customDatePicker(
              context,
              widget.todo.dueDate,
              allowNull: true,
              useDateAndTime: true,
            ),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(),
              ),
              width: double.infinity,
              label: Text(AppLocale.selectPriority.getString(context)),
              initialSelection: widget.todo.priority,
              onSelected: (value) {
                selectedPriority = value ?? '';
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  label: AppLocale.low.getString(context),
                  value: 'Low',
                ),
                DropdownMenuEntry(
                  label: AppLocale.medium.getString(context),
                  value: 'Medium',
                ),
                DropdownMenuEntry(
                  label: AppLocale.high.getString(context),
                  value: 'High',
                ),
                DropdownMenuEntry(
                  label: AppLocale.none.getString(context),
                  value: '',
                ),
              ],
            ),
            verticalSpace(20),
            BlocBuilder<DateCubit, DateTime?>(
              builder: (context, selectedDate) {
                if (selectedDate != null) {
                  return DropdownMenu(
                    width: double.infinity,
                    inputDecorationTheme: InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    label: Text(
                      AppLocale.whenShouldWeRemindYou.getString(context),
                    ),
                    initialSelection: widget.todo.timeReminder,
                    onSelected: (value) {
                      selectedTimeReminder = value ?? 0;
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        label: AppLocale.onTime.getString(context),
                        value: 0,
                      ),
                      DropdownMenuEntry(
                        label: '5 ${AppLocale.minsBefore.getString(context)}',
                        value: 5,
                      ),
                      DropdownMenuEntry(
                        label: '15 ${AppLocale.minsBefore.getString(context)}',
                        value: 15,
                      ),
                      DropdownMenuEntry(
                        label: '30 ${AppLocale.minsBefore.getString(context)}',
                        value: 30,
                      ),
                      DropdownMenuEntry(
                        label: '1 ${AppLocale.hoursBefore.getString(context)}',
                        value: 60,
                      ),
                      DropdownMenuEntry(
                        label: '2 ${AppLocale.hoursBefore.getString(context)}',
                        value: 120,
                      ),
                      DropdownMenuEntry(
                        label: '3 ${AppLocale.hoursBefore.getString(context)}',
                        value: 180,
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
            verticalSpace(20),
            Row(
              children: [
                Checkbox(
                  value: shouldAddToExpense,
                  shape: CircleBorder(),
                  visualDensity: VisualDensity.compact,
                  onChanged: (value) {
                    setState(() {
                      shouldAddToExpense = !shouldAddToExpense;
                    });
                  },
                ),
                Expanded(
                  child: Text(AppLocale.addToFinanceTracker.getString(context)),
                ),
              ],
            ),
            verticalSpace(30),

            // SUBTODOS----------------------------------------------------------------------------
            _buildSubTodos(context),
          ],
        ),

        // ADD AND UPDATE BUTTONS-------------------------------------------------------------------
        _buildButtons(context, todoCubit),
      ],
    );
  }

  Positioned _buildButtons(BuildContext context, TodoCrudCubit todoCubit) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            BlocBuilder<DateCubit, DateTime?>(
              builder: (context, selectedDate) {
                return Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDate != null &&
                          selectedDate.isBefore(DateTime.now())) {
                        warningToast(
                          context,
                          AppLocale.invalidDeadline.getString(context),
                        );
                      } else {
                        todoCubit.updateTodo(
                          Todo(
                            id: widget.todo.id,
                            text: todoController.text,
                            category: selectedCategory,
                            priority: selectedPriority,
                            dueDate: selectedDate,
                            subTodos: widget.todo.subTodos,
                            shouldAddToExpense: shouldAddToExpense,
                          ),
                        );

                        Navigator.pop(context);
                        context.read<DateCubit>().clearDate();
                      }
                    },
                    child: Text('Update'),
                  ),
                );
              },
            ),
            horizontalSpace(12),
            ElevatedButton(
              onPressed: () async {
                final result = await showDeleteBox(
                  context,
                  AppLocale.deleteThisTodo.getString(context),
                );
                if (result == true) {
                  todoCubit.deleteTodo(widget.todo);
                  Navigator.pop(context);
                  successToast(
                    context,
                    AppLocale.todoDeleted.getString(context),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildSubTodos(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocale.subTodos.getString(context),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ElevatedButton.icon(
                  onPressed: () => showAddSubTodoBox(context, widget.todo.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.add),
                  label: Text(AppLocale.add.getString(context)),
                ),
              ],
            ),
          ),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              context.read<TodoCrudCubit>().reorderSubTodo(
                id: widget.todo.id,
                newIndex: newIndex,
                oldIndex: oldIndex,
              );
            },
            itemCount: widget.todo.subTodos.length,
            itemBuilder: (context, index) {
              return SubTodoTile(
                key: ValueKey(widget.todo.subTodos[index].id),
                subTodo: widget.todo.subTodos[index],
                todo: widget.todo,
              );
            },
          ),
          verticalSpace(16),
        ],
      ),
    );
  }
}
