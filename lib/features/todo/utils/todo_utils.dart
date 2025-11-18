import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../components/custom_textfield.dart';
import '../../../components/date_picker/pick_date.dart';
import '../../../components/date_picker/pick_date_cubit.dart';
import '../../../localization/locales.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo.dart';
import '../domain/models/todo_category.dart';
import '../presentation/cubit/category_cubit/category_cubit.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';

List<Todo> getTodaysTodos(List<Todo> todos, {bool loadThreeTodos = false}) {
  List<Todo> todaysTodos = [];
  for (var todo in todos) {
    if (todo.dueDate != null &&
        todo.dueDate!.day == DateTime.now().day &&
        todo.dueDate!.month == DateTime.now().month &&
        todo.dueDate!.year == DateTime.now().year) {
      todaysTodos.add(todo);
    }
  }
  if (loadThreeTodos && todaysTodos.length <= 3) {
    return todaysTodos;
  }

  if (loadThreeTodos && todaysTodos.length > 3) {
    todaysTodos.removeRange(3, todaysTodos.length);
  }

  return todaysTodos;
}

List<Todo> getOverdueTodos(List<Todo> todos) {
  List<Todo> overDueTodos = [];
  for (var todo in todos) {
    if (todo.dueDate != null &&
        todo.dueDate!.isBefore(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        )) {
      overDueTodos.add(todo);
    }
  }

  return overDueTodos;
}

List<Todo> searchTodos(List<Todo> todos, String keyword) {
  List<Todo> specifiedTodos = [];
  if (keyword.isNotEmpty) {
    for (var todo in todos) {
      if (todo.text.toLowerCase().contains(keyword.toLowerCase())) {
        specifiedTodos.add(todo);
      }
    }
    return specifiedTodos;
  } else {
    return todos;
  }
}

List<Todo> getUpcomingTodos(List<Todo> todos, DateTime date) {
  List<Todo> upcomingTodos = [];
  for (var todo in todos) {
    if (todo.dueDate != null &&
        todo.dueDate!.year == date.year &&
        todo.dueDate!.month == date.month &&
        todo.dueDate!.day == date.day) {
      upcomingTodos.add(todo);
    }
  }
  return upcomingTodos;
}

void showAddTodoBox(BuildContext context) {
  final todoCubit = context.read<TodoCrudCubit>();
  final todoController = TextEditingController();
  TodoCategory? selectedCategory;
  String selectedPriority = '';
  int selectedTimeReminder = 0;
  bool shouldAddtoExpense = false;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 16,
                right: 16,
              ),
              width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocale.addTodo.getString(context),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: 30),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  customTextfield(
                    context,
                    AppLocale.whatIsTobeDone.getString(context),
                    todoController,
                  ),
                  verticalSpace(12),
                  BlocBuilder<TodoCategoryCubit, TodoCategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        // final initialValue = state.categoryList.indexWhere(
                        //   (category) => category.id == selectedCategory.id,
                        // );
                        return DropdownMenu(
                          inputDecorationTheme: InputDecorationTheme(
                            border: UnderlineInputBorder(),
                          ),
                          enableFilter: true,
                          enableSearch: true,
                          width: double.infinity,
                          label: Text(
                            AppLocale.selectCategory.getString(context),
                          ),
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
                    DateTime.now(),
                    allowNull: true,
                    useDateAndTime: true,
                  ),
                  DropdownMenu(
                    width: double.infinity,
                    inputDecorationTheme: InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    label: Text(AppLocale.selectPriority.getString(context)),
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
                          onSelected: (value) {
                            selectedTimeReminder = value ?? 0;
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                              label: AppLocale.onTime.getString(context),
                              value: 0,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '5 ${AppLocale.minsBefore.getString(context)}',
                              value: 5,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '15 ${AppLocale.minsBefore.getString(context)}',
                              value: 15,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '30 ${AppLocale.minsBefore.getString(context)}',
                              value: 30,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '1 ${AppLocale.hoursBefore.getString(context)}',
                              value: 60,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '2 ${AppLocale.hoursBefore.getString(context)}',
                              value: 120,
                            ),
                            DropdownMenuEntry(
                              label:
                                  '3 ${AppLocale.hoursBefore.getString(context)}',
                              value: 180,
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<DateCubit, DateTime?>(
                    builder: (context, selectedDate) {
                      if (selectedDate != null) {
                        return verticalSpace(30);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: shouldAddtoExpense,
                        shape: CircleBorder(),
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          setModalState(() {
                            shouldAddtoExpense = !shouldAddtoExpense;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          AppLocale.addToFinanceTracker.getString(context),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(30),
                  BlocBuilder<DateCubit, DateTime?>(
                    builder: (context, selectedDate) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (todoController.text.isEmpty) {
                              errorToast(
                                context,
                                AppLocale.nameMustNotEmpty.getString(context),
                              );
                            } else if (selectedDate != null &&
                                selectedDate.isBefore(DateTime.now())) {
                              warningToast(
                                context,
                                AppLocale.invalidDeadline.getString(context),
                              );
                            } else {
                              todoCubit.addTodo(
                                todoController.text,
                                selectedDate,
                                selectedCategory,
                                selectedPriority,
                                shouldAddtoExpense,
                                selectedTimeReminder,
                              );
                              Navigator.pop(context);
                              context.read<DateCubit>().clearDate();
                              successToast(
                                context,
                                AppLocale.newTodoAdded.getString(context),
                              );
                            }
                          },
                          child: Text(AppLocale.add.getString(context)),
                        ),
                      );
                    },
                  ),
                  verticalSpace(20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showAddSubTodoBox(BuildContext context, int id) {
  final todoCubit = context.read<TodoCrudCubit>();
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(AppLocale.addSubtodo.getString(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextfield(
                  context,
                  AppLocale.subtodo.getString(context),
                  textController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocale.cancel.getString(context)),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isEmpty) {
                  errorToast(
                    context,
                    AppLocale.subtodoMustNotBeEmpty.getString(context),
                  );
                } else {
                  todoCubit.addNewSubTodo(id, textController.text);
                  Navigator.pop(context);
                  successToast(
                    context,
                    AppLocale.newSubtodoAdded.getString(context),
                  );
                }
              },
              child: Text(AppLocale.add.getString(context)),
            ),
          ],
        ),
  );
}

void showEditSubTodoBox(
  BuildContext context,
  int id,
  SubTodo subTodo,
  bool shouldLoadAllTodos,
) {
  final todoCubit = context.read<TodoCrudCubit>();
  final textController = TextEditingController(text: subTodo.text);
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(AppLocale.editSubtodo.getString(context)),
          content: customTextfield(
            context,
            AppLocale.subtodo.getString(context),
            textController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocale.cancel.getString(context)),
            ),
            BlocBuilder<DateCubit, DateTime?>(
              builder: (context, selectedDate) {
                return TextButton(
                  onPressed: () {
                    if (textController.text.isEmpty) {
                      errorToast(
                        context,
                        AppLocale.subtodoMustNotBeEmpty.getString(context),
                      );
                    } else {
                      todoCubit.updateSubTodo(
                        id,
                        SubTodo(id: subTodo.id, text: textController.text),
                        shouldLoadAllTodos: shouldLoadAllTodos,
                      );
                      Navigator.pop(context);
                      successToast(
                        context,
                        AppLocale.subtodoUpdated.getString(context),
                      );
                    }
                  },
                  child: Text('Update'),
                );
              },
            ),
          ],
        ),
  );
}

// }
