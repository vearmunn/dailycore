import 'package:dailycore/features/expense_tracker/presentation/cubit/expense_category/expense_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/delete_confirmation.dart';
import '../../domain/models/expense_category.dart';
import '../../utils/expense_util.dart';
import '../../widgets/expense_tile.dart';

class ExpenseCategoryPage extends StatelessWidget {
  const ExpenseCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Expense Category'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(tabs: [Tab(text: 'Expense'), Tab(text: 'Income')]),
          ),
        ),
        body: TabBarView(
          children: [_buidTabCategory(true), _buidTabCategory(false)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddEditCategoryModalBottomSheet(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  BlocBuilder<ExpenseCategoryCubit, ExpenseCategoryState> _buidTabCategory(
    bool isExpense,
  ) {
    return BlocBuilder<ExpenseCategoryCubit, ExpenseCategoryState>(
      builder: (context, state) {
        if (state is CategoryError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is CategoryLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CategoriesLoaded) {
          final allCategories =
              state.categoryList.where((category) {
                if (isExpense) {
                  return category.type == 'Expense' && category.id != 0;
                } else {
                  return category.type == 'Income' && category.id != 0;
                }
              }).toList();
          return ListView.builder(
            padding: EdgeInsets.only(top: 20),
            itemCount: allCategories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = allCategories[index];
              return Dismissible(
                key: ValueKey(category.id),
                confirmDismiss: (direction) async {
                  return await showDeleteBox(context, 'Delete this category?');
                },
                onDismissed: (direction) {
                  context.read<ExpenseCategoryCubit>().deleteExpenseCategory(
                    category,
                  );
                },
                child: buildExpenseTile(
                  context,
                  color: category.color,
                  icon: category.icon,
                  title: category.name,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    showAddEditCategoryModalBottomSheet(
                      context,
                      isUpadting: true,
                      category: ExpenseCategory(
                        id: category.id,
                        name: category.name,
                        color: category.color,
                        icon: category.icon,
                        type: category.type,
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
