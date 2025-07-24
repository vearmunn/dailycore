// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/expense_tracker/presentation/cubit/expense_category/expense_category_cubit.dart';
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:dailycore/features/expense_tracker/widgets/category_grid.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/date_picker/pick_date.dart';
import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../../../components/numpad/numpad.dart';
import '../../../../components/numpad/numpad_cubit.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/expense_category.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';

class AddEditExpensePage extends StatefulWidget {
  const AddEditExpensePage({
    super.key,
    this.isUpdating = false,
    this.expense,
    this.isFromTodoOrHabit = false,
    this.noteFromTodoOrHabit = '',
  });
  final bool isUpdating;
  final Expense? expense;
  final bool isFromTodoOrHabit;
  final String noteFromTodoOrHabit;

  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController noteController;
  late ExpandableController _expandableController;
  ExpenseCategory? selectedCategory;

  @override
  void dispose() {
    noteController.dispose();
    _expandableController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    noteController = TextEditingController();
    _expandableController = ExpandableController(
      initialExpanded: widget.isUpdating,
    );
    if (widget.isUpdating) {
      context.read<DateCubit>().setDate(widget.expense!.date);
      selectedCategory = widget.expense!.category;
      context.read<NumpadCubit>().input(
        widget.expense!.amount.toInt().toString(),
      );
      noteController.text = widget.expense!.note ?? '';
    }
    if (widget.isFromTodoOrHabit) {
      context.read<DateCubit>().setDate(DateTime.now());
      noteController.text = widget.noteFromTodoOrHabit;
    }
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          widget.expense == null || isExpenseType(widget.expense!.category.type)
              ? 0
              : 1,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final expenseCubit = context.read<ExpenseCrudCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<NumpadCubit>().clear();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.isUpdating ? 'Update Expense' : 'Add Expense'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            tabs: [Tab(text: 'Expense'), Tab(text: 'Income')],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCategoryTab(true), _buildCategoryTab(false)],
      ),
      bottomSheet: ExpandableNotifier(
        controller: _expandableController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _expandableController.toggle();
                });
              },
              label: Text(
                _expandableController.expanded == true ? 'Hide' : 'Show',
              ),
              icon: Icon(
                _expandableController.expanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
              ),
            ),
            Expandable(
              collapsed: Container(
                color: Colors.grey.shade200,
                width: double.infinity,
                height: 10,
              ),
              expanded: _buildRecordBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordBox() {
    final expenseCubit = context.read<ExpenseCrudCubit>();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom * 0.1,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: BlocBuilder<NumpadCubit, String>(
            builder: (context, input) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      input.isEmpty ? '0' : formatAmountRP(double.parse(input)),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  verticalSpace(20),
                  TextField(
                    controller: noteController,

                    decoration: InputDecoration(
                      hintText: 'Note',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: dailyCoreBlue),
                      ),
                    ),
                  ),
                  verticalSpace(20),
                  Text('Select Date'),
                  verticalSpace(8),
                  customDatePicker(
                    context,
                    widget.isUpdating ? widget.expense!.date : DateTime.now(),
                  ),
                  verticalSpace(12),
                  NumberPad(),
                  verticalSpace(20),
                  BlocBuilder<DateCubit, DateTime?>(
                    builder: (context, selectedDate) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCategory == null) {
                              errorToast(context, 'Please select category!');
                            } else if (input.isEmpty) {
                              errorToast(context, 'Please enter amount!');
                            } else if (noteController.text.isEmpty) {
                              errorToast(context, 'Please enter note!');
                            } else {
                              if (widget.isUpdating) {
                                expenseCubit.updateExpense(
                                  Expense(
                                    id: widget.expense!.id,
                                    note: noteController.text,
                                    amount: double.parse(input),
                                    date: selectedDate ?? DateTime.now(),
                                    type: selectedCategory!.type,
                                    category: selectedCategory!,
                                  ),
                                );
                                successToast(
                                  context,
                                  selectedCategory!.type == 'Expense'
                                      ? 'Expense updated!'
                                      : 'Income updated!',
                                );
                              } else {
                                expenseCubit.addExpense(
                                  noteController.text,
                                  double.parse(input),
                                  selectedDate ?? DateTime.now(),
                                  selectedCategory!,
                                  selectedCategory!.type,
                                );
                                successToast(
                                  context,
                                  selectedCategory!.type == 'Expense'
                                      ? 'Expense added!'
                                      : 'Income added!',
                                );
                              }

                              context.read<DateCubit>().clearDate();
                              context.read<NumpadCubit>().clear();

                              Navigator.pop(context);
                            }
                          },
                          child: Text(widget.isUpdating ? 'Update' : 'Add'),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(bool isExpense) {
    return BlocBuilder<ExpenseCategoryCubit, ExpenseCategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          final categories =
              state.categoryList.where((category) {
                if (isExpense) {
                  return category.type == 'Expense' && category.id != 0;
                } else {
                  return category.type == 'Income' && category.id != 0;
                }
              }).toList();
          return CategoryGrid(
            categoryList: categories,
            onTap: (category) {
              setState(() {
                selectedCategory = category;
                _expandableController.expanded = true;
              });
            },
            selectedCategories:
                selectedCategory == null ? [] : [selectedCategory!],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
