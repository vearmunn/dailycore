// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../utils/dates_utils.dart';
import '../../../utils/delete_confirmation.dart';
import '../../../utils/spaces.dart';
import '../domain/models/expense.dart';
import '../presentation/cubit/expense_crud/expense_crud_cubit.dart';
import '../presentation/pages/detail_expense_page.dart';
import '../utils/expense_util.dart';
import '../../../components/list_tile_icon.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenseList;

  const ExpenseList({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      elements: expenseList,
      order: GroupedListOrder.DESC,
      groupBy:
          (expense) =>
              DateTime(expense.date.year, expense.date.month, expense.date.day),
      groupSeparatorBuilder: (DateTime groupDate) {
        final dailyAmount = getDailyExpensesAndIncome(groupDate, expenseList);
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
            return await showDeleteBox(context, 'Delete this transaction?');
          },
          onDismissed: (direction) {
            context.read<ExpenseCrudCubit>().deleteExpense(expense);
          },
          key: ValueKey(expense.id),
          child: listTileIcon(
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
              context.read<ExpenseCrudCubit>().loadSingleExpense(expense.id);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailExpensePage()),
              );
            },
          ),
        );
      },
    );
  }
}
