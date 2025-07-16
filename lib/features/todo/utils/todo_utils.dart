import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/date_picker/pick_date.dart';
import '../../../components/date_picker/pick_date_cubit.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo.dart';
import '../domain/models/todo_category.dart';
import '../presentation/cubit/category_cubit/category_cubit.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';

List<Todo> getTodaysTodos(List<Todo> todos) {
  List<Todo> todaysTodos = [];
  for (var todo in todos) {
    if (todo.dueDate != null &&
        todo.dueDate!.day == DateTime.now().day &&
        todo.dueDate!.month == DateTime.now().month &&
        todo.dueDate!.year == DateTime.now().year) {
      todaysTodos.add(todo);
    }
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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
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
                    'Add Todo',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 30),
                  ),
                ],
              ),
              verticalSpace(20),
              TextField(
                controller: todoController,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(hintText: 'E.g: Go to gym'),
              ),
              verticalSpace(28),
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
                      label: Text('Select Category'),
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
                label: Text('Select Priority'),
                onSelected: (value) {
                  selectedPriority = value ?? '';
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(label: 'Low', value: 'Low'),
                  DropdownMenuEntry(label: 'Medium', value: 'Medium'),
                  DropdownMenuEntry(label: 'High', value: 'High'),
                  DropdownMenuEntry(label: 'None', value: ''),
                ],
              ),
              verticalSpace(30),
              BlocBuilder<DateCubit, DateTime?>(
                builder: (context, selectedDate) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        todoCubit.addTodo(
                          todoController.text,
                          selectedDate,
                          selectedCategory ?? TodoCategory(id: 0, name: 'none'),
                          selectedPriority,
                        );
                        Navigator.pop(context);
                        context.read<DateCubit>().clearDate();
                      },
                      child: Text('Add'),
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
}

void showAddSubTodoBox(BuildContext context, int id) {
  final todoCubit = context.read<TodoCrudCubit>();
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Add Sub Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Subtodo....'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoCubit.addNewSubTodo(id, textController.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
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
          title: Text('Edit Sub Todo'),
          content: TextField(controller: textController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            BlocBuilder<DateCubit, DateTime?>(
              builder: (context, selectedDate) {
                return TextButton(
                  onPressed: () {
                    todoCubit.updateSubTodo(
                      id,
                      SubTodo(id: subTodo.id, text: textController.text),
                      shouldLoadAllTodos: shouldLoadAllTodos,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                );
              },
            ),
          ],
        ),
  );
}

void showDeleteTodoBox(BuildContext context, Todo todo) {
  final todoCubit = context.read<TodoCrudCubit>();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Delete this todo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoCubit.deleteTodo(todo);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        ),
  );
}
