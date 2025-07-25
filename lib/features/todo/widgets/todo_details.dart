// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/todo/domain/models/todo.dart';
import 'package:dailycore/features/todo/utils/todo_utils.dart';

import '../../../components/custom_textfield.dart';
import '../../../components/date_picker/pick_date.dart';
import '../../../components/date_picker/pick_date_cubit.dart';
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

  @override
  void initState() {
    todoController = TextEditingController(text: widget.todo.text);

    selectedCategory = TodoCategory(
      id: widget.todo.category.id,
      name: widget.todo.category.name,
    );
    selectedPriority = widget.todo.priority;
    shouldAddToExpense = widget.todo.shouldAddToExpense;
    print(widget.todo.shouldAddToExpense);
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
            customTextfield('What is to be done?', todoController),
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
              widget.todo.dueDate ?? DateTime.now(),
              allowNull: true,
              useDateAndTime: true,
            ),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(),
              ),
              width: double.infinity,
              label: Text('Select Priority'),
              initialSelection: widget.todo.priority,
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
                Text('Add to Finance Tracker when task is done?'),
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
                  'Delete this todo ?',
                );
                if (result == true) {
                  todoCubit.deleteTodo(widget.todo);
                  Navigator.pop(context);
                  errorToast(context, 'Todo deleted!');
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
                  'SubTodos',
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
