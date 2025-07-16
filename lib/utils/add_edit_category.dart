import 'package:dailycore/features/todo/presentation/cubit/category_cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/color_selector/color_icon_selector_cubit.dart';
import '../components/color_selector/color_selector_widget.dart';
import '../components/color_selector/icon_color_selected_widget.dart';
import '../components/color_selector/icon_selector_widget.dart';
import '../features/expense_tracker/domain/models/expense_category.dart';
import '../features/expense_tracker/presentation/cubit/expense_category/expense_category_cubit.dart';
import '../features/todo/domain/models/todo_category.dart';
import 'spaces.dart';

void showAddEditCategoryModalBottomSheet(
  BuildContext context, {
  bool isUpadting = false,
  ExpenseCategory? expenseCategory,
  TodoCategory? todoCategory,
  bool isExpenseCategory = true,
}) {
  final nameController = TextEditingController();
  bool showIconSelections = false;
  bool showColorSelections = false;
  String selectedType = 'Expense';

  if (isUpadting && expenseCategory != null) {
    nameController.text = expenseCategory.name;
    context.read<ColorSelectorCubit>().setColor(expenseCategory.color);
    context.read<IconSelectorCubit>().setIcon(expenseCategory.icon);
    selectedType = expenseCategory.type;
  } else if (isUpadting && todoCategory != null) {
    nameController.text = todoCategory.name;
    context.read<ColorSelectorCubit>().setColor(todoCategory.color);
    context.read<IconSelectorCubit>().setIcon(todoCategory.icon);
  }

  showModalBottomSheet(
    isScrollControlled: true, // Important for dynamic height
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUpadting ? 'Edit Category' : 'Add Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      verticalSpace(16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      verticalSpace(20),
                      Row(
                        children: [
                          colorOrIconSelected(true, () {
                            setModalState(() {
                              showColorSelections = !showColorSelections;
                              showIconSelections = false;
                            });
                          }),
                          horizontalSpace(12),
                          colorOrIconSelected(false, () {
                            setModalState(() {
                              showIconSelections = !showIconSelections;
                              showColorSelections = false;
                            });
                          }),
                        ],
                      ),
                      verticalSpace(16),
                      colorSelector(showColorSelections),
                      iconSelector(showIconSelections),
                      if (showColorSelections || showIconSelections)
                        verticalSpace(16),
                      if (isExpenseCategory)
                        Row(
                          children: [
                            horizontalSpace(12),
                            Radio(
                              activeColor: Colors.black,
                              value: 'Expense',
                              groupValue: selectedType,
                              onChanged: (v) {
                                setModalState(() {
                                  selectedType = v!;
                                });
                              },
                            ),
                            Text('Expense'),
                          ],
                        ),
                      if (isExpenseCategory)
                        Row(
                          children: [
                            horizontalSpace(12),
                            Radio(
                              activeColor: Colors.black,
                              value: 'Income',
                              groupValue: selectedType,
                              onChanged: (v) {
                                setModalState(() {
                                  selectedType = v!;
                                });
                              },
                            ),
                            Text('Income'),
                          ],
                        ),
                      verticalSpace(16),
                      _buildButton(
                        isUpadting,
                        nameController,
                        selectedType,
                        expenseCategory: expenseCategory,
                        isExpenceCategory: isExpenseCategory,
                        todoCategory: todoCategory,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
  );
}

Widget _buildButton(
  bool isUpadting,
  TextEditingController nameController,
  String selectedType, {
  ExpenseCategory? expenseCategory,
  TodoCategory? todoCategory,
  required bool isExpenceCategory,
}) {
  return BlocBuilder<ColorSelectorCubit, Color>(
    builder: (context, selectedColor) {
      return BlocBuilder<IconSelectorCubit, IconData>(
        builder: (context, selectedIcon) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isExpenceCategory) {
                  if (isUpadting) {
                    context.read<ExpenseCategoryCubit>().updateExpenseCategory(
                      ExpenseCategory(
                        id: expenseCategory!.id,
                        name: nameController.text,
                        color: selectedColor,
                        icon: selectedIcon,
                        type: selectedType,
                      ),
                    );
                  } else {
                    context.read<ExpenseCategoryCubit>().addExpenseCategory(
                      categoryName: nameController.text,
                      color: selectedColor,
                      icon: selectedIcon,
                      type: selectedType,
                    );
                  }
                }

                if (isExpenceCategory == false) {
                  if (isUpadting) {
                    context.read<TodoCategoryCubit>().updateTodoCategory(
                      TodoCategory(
                        id: todoCategory!.id,
                        name: nameController.text,
                        color: selectedColor,
                        icon: selectedIcon,
                      ),
                    );
                  } else {
                    context.read<TodoCategoryCubit>().addTodoCategory(
                      categoryName: nameController.text,
                      color: selectedColor,
                      icon: selectedIcon,
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: Text(isUpadting ? 'Update' : 'Add'),
            ),
          );
        },
      );
    },
  );
}
