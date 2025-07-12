// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/spaces.dart';
import '../../domain/models/piechart_category_data.dart';
import '../../utils/expense_util.dart';
import '../../widgets/transaction_item.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';

class CategoryDetailTransactionPage extends StatelessWidget {
  final CategoryData category;
  final String type;
  final int month;
  final int year;
  const CategoryDetailTransactionPage({
    super.key,
    required this.category,
    required this.type,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
            verticalSpace(20),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: category.color.withAlpha(30),
                  ),
                  child: Icon(color: category.color, size: 35, category.icon),
                ),
                horizontalSpace(24),
                Text(
                  category.categoryName,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
            verticalSpace(34),
            _buildItem(context, 'Type', type),
            _buildItem(context, 'Amount', formatAmountRP(category.amount)),
            _buildItem(context, 'Date', '${getMonthName(month)} $year'),
            Divider(),
            verticalSpace(30),
            BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
              builder: (context, state) {
                if (state is ExpenseCrudLoaded) {
                  final transactions =
                      state.expenseList
                          .where(
                            (item) =>
                                item.category.id == category.id &&
                                item.date.month == month &&
                                item.date.year == year,
                          )
                          .toList();
                  transactions.sort((a, b) => b.amount.compareTo(a.amount));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final transaction = transactions[index];
                      return TransactionItem(
                        label: transaction.note ?? '',
                        color: category.color,
                        icon: category.icon,
                        itemAmount: transaction.amount,
                        totalAmount: category.amount,
                        date: transaction.date,
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
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
