import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../utils/colors_and_icons.dart';
import '../../../../utils/dates_utils.dart';
import '../../../../utils/delete_confirmation.dart';
import '../../../../utils/spaces.dart';
import '../../utils/expense_util.dart';
import '../../widgets/expense_tile.dart';
import '../cubit/bar_graph/bar_graph_cubit.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';
import 'add_edit_expense_page.dart';
import 'detail_expense_page.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BarGraphCubit>().calculateMonthlyTotals();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finance Tracker',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: [
                verticalSpace(30),
                // _buildBarGraph(),
                _buildExpenseList(context),
              ],
            ),
            BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
              builder: (context, state) {
                if (state is ExpenseCrudLoading) {
                  return Center(child: Text('Loading...'));
                }
                if (state is ExpenseCrudError) {
                  return Center(child: Text(state.errMessage));
                }
                if (state is ExpenseCrudLoaded) {
                  return Container(
                    height: 50,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMontPicker(context, state),
                        _buildTracker(
                          'Expenses',
                          formatAmountRP(
                            state.monthlyTotal.expenses,
                            useSymbol: false,
                          ),
                        ),
                        _buildTracker(
                          'Income',
                          formatAmountRP(
                            state.monthlyTotal.income,
                            useSymbol: false,
                          ),
                        ),
                        _buildTracker(
                          'Balance',
                          formatAmountRP(
                            state.monthlyTotal.balance,
                            useSymbol: false,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditExpensePage()),
            ),
        child: Icon(Icons.add),
      ),
    );
  }

  GestureDetector _buildMontPicker(
    BuildContext context,
    ExpenseCrudLoaded state,
  ) {
    return GestureDetector(
      onTap: () {
        showMonthPicker(
          context,
          onSelected: (month, year) {
            context.read<ExpenseCrudCubit>().loadExpenses(year, month);
          },
          initialSelectedMonth: state.monthlyTotal.month,
          initialSelectedYear: state.monthlyTotal.year,
          firstYear: 2020,
          lastYear: DateTime.now().year,
          selectButtonText: 'OK',
          cancelButtonText: 'Cancel',
          highlightColor: dailyCoreBlue,
          textColor: Colors.black,
          contentBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.grey[200],
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(getMonthName(state.monthlyTotal.month)),
              Text(state.monthlyTotal.year.toString()),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    return BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
      builder: (context, state) {
        if (state is ExpenseCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ExpenseCrudError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is ExpenseCrudLoaded) {
          return GroupedListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            elements: state.expenseList,
            order: GroupedListOrder.DESC,
            groupBy:
                (expense) => DateTime(
                  expense.date.year,
                  expense.date.month,
                  expense.date.day,
                ),
            groupSeparatorBuilder: (DateTime groupDate) {
              final dailyAmount = getDailyExpensesAndIncome(
                groupDate,
                state.expenseList,
              );
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedDate2(groupDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (dailyAmount[0] != 0)
                          Text(
                            'Expenses: ${formatAmountRP(dailyAmount[0])}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        if (dailyAmount[0] != 0 || dailyAmount[1] != 0)
                          horizontalSpace(10),
                        if (dailyAmount[1] != 0)
                          Text(
                            'Income : ${formatAmountRP(dailyAmount[1])}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },

            itemBuilder: (context, expense) {
              return Dismissible(
                confirmDismiss: (direction) async {
                  return await showDeleteBox(
                    context,
                    'Delete this transaction?',
                  );
                },
                onDismissed: (direction) {
                  context.read<ExpenseCrudCubit>().deleteExpense(expense);
                  context.read<BarGraphCubit>().calculateMonthlyTotals();
                },
                key: ValueKey(expense.id),
                child: buildExpenseTile(
                  context,
                  color: expense.category.color,
                  icon: expense.category.icon,
                  title: expense.note ?? '',
                  subtitle: expense.category.name,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  trailing: Text(
                    '${isExpenseType(expense.type) ? '-' : ''} ${formatAmountRP(expense.amount)}',
                  ),
                  onTap: () async {
                    context.read<ExpenseCrudCubit>().loadSingleExpense(
                      expense.id,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailExpensePage(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildTracker(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(
          amount,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  // Widget _buildBarGraph() {
  //   return BlocBuilder<BarGraphCubit, BarGraphState>(
  //     builder: (context, state) {
  //       if (state is BarGraphLoading) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       if (state is BarGraphError) {
  //         return Center(child: Text(state.errMessage));
  //       }
  //       if (state is BarGraphLoaded) {
  //         // get dates

  //         return SizedBox(
  //           height: 250,
  //           child: ExpenseBarGraph(
  //             monthlySummary: state.monthlySummary,
  //             startMonth: state.startMonth,
  //           ),
  //         );
  //       }
  //       return SizedBox();
  //     },
  //   );
  // }
}
