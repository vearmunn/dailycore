// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/add_edit_expense_page.dart';
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:dailycore/utils/dates_utils.dart';
import 'package:dailycore/utils/delete_confirmation.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/colors_and_icons.dart';

class DetailExpensePage extends StatelessWidget {
  const DetailExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseCubit = context.read<ExpenseCrudCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<ExpenseCrudCubit>().loadExpenses(
              DateTime.now().year,
              DateTime.now().month,
            );
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
        builder: (context, state) {
          if (state is ExpenseCrudLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ExpenseCrudError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is ExpenseSingleCrudLoaded) {
            final expense = state.expense;
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: fromArgb32(expense.category.color).withAlpha(30),
                      ),
                      child: Icon(
                        color: fromArgb32(expense.category.color),
                        size: 35,
                        IconData(
                          expense.category.icon['code_point'],
                          fontFamily: expense.category.icon['font_family'],
                        ),
                      ),
                    ),
                    horizontalSpace(24),
                    Text(
                      expense.category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                verticalSpace(34),
                _buildItem(context, 'Note', expense.note ?? ''),
                _buildItem(context, 'Type', expense.type),
                _buildItem(context, 'Amount', formatAmountRP(expense.amount)),
                _buildItem(context, 'Date', formattedDate(expense.date)),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: dailyCoreBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddEditExpensePage(
                                    isUpdating: true,
                                    expense: expense,
                                  ),
                            ),
                          );
                        },
                        label: Text('Edit'),
                        icon: Icon(Icons.edit),
                      ),
                    ),
                    horizontalSpace(20),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: dailyCoreRed,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final result = await showDeleteBox(
                            context,
                            'Delete this transaction ?',
                          );
                          if (result == true) {
                            expenseCubit.deleteExpense(expense);
                            expenseCubit.loadExpenses(
                              DateTime.now().year,
                              DateTime.now().month,
                            );
                            Navigator.pop(context);
                          }
                        },
                        label: Text('Delete'),
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          horizontalSpace(12),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
