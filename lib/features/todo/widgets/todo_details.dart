// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/todo/domain/models/todo.dart';
import 'package:dailycore/features/todo/utils/todo_utils.dart';

import '../../../components/date_picker/pick_date.dart';
import '../../../components/date_picker/pick_date_cubit.dart';
import '../../../utils/spaces.dart';
import '../domain/models/todo_category.dart';
import '../presentation/cubit/category_cubit/category_cubit.dart';
import '../presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'subtodo_tile.dart';

class TodoDetails extends StatelessWidget {
  final Todo todo;

  const TodoDetails({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCrudCubit>();
    final todoController = TextEditingController(text: todo.text);
    TodoCategory selectedCategory = TodoCategory(
      id: todo.category.id,
      name: todo.category.name,
    );
    String selectedPriority = todo.priority;
    return Stack(
      children: [
        // FORM-------------------------------------------------------------------------------
        ListView(
          padding: EdgeInsets.all(20),
          children: [
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
                  final initialValue = state.categoryList.indexWhere(
                    (category) => category.id == selectedCategory.id,
                  );
                  return DropdownMenu(
                    width: double.infinity,
                    inputDecorationTheme: InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    label: Text('Select Category'),
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
              todo.dueDate ?? DateTime.now(),
              allowNull: true,
            ),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(),
              ),
              width: double.infinity,
              label: Text('Select Priority'),
              initialSelection: todo.priority,
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

            // SUBTODOS----------------------------------------------------------------------------
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SubTodos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => showAddSubTodoBox(context, todo.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 0,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(Icons.add),
                          label: Text('Add'),
                        ),
                      ],
                    ),
                  ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      context.read<TodoCrudCubit>().reorderSubTodo(
                        id: todo.id,
                        newIndex: newIndex,
                        oldIndex: oldIndex,
                      );
                    },
                    itemCount: todo.subTodos.length,
                    itemBuilder: (context, index) {
                      return SubTodoTile(
                        key: ValueKey(todo.subTodos[index].id),
                        subTodo: todo.subTodos[index],
                        todo: todo,
                      );
                    },
                  ),
                  verticalSpace(16),
                ],
              ),
            ),
          ],
        ),

        // ADD AND UPDATE BUTTONS-------------------------------------------------------------------
        Positioned(
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
                          todoCubit.updateTodo(
                            Todo(
                              id: todo.id,
                              text: todoController.text,
                              category: selectedCategory,
                              priority: selectedPriority,
                              dueDate: selectedDate,
                              subTodos: todo.subTodos,
                            ),
                          );

                          Navigator.pop(context);
                          context.read<DateCubit>().clearDate();
                        },
                        child: Text('Update'),
                      ),
                    );
                  },
                ),
                horizontalSpace(12),
                ElevatedButton(
                  onPressed: () => showDeleteTodoBox(context, todo),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
