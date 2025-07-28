// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../localization/locales.dart';
import '../utils/expense_util.dart';

class ReportHeader extends StatelessWidget {
  final double totalExpense;
  final double totalIncome;
  final double totalBalance;
  const ReportHeader({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
    required this.totalBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTotalTracker(
            AppLocale.totalExpenses.getString(context),
            formatAmountRP(totalExpense, useSymbol: false),
          ),
          _buildTotalTracker(
            AppLocale.totalIncome.getString(context),
            formatAmountRP(totalIncome, useSymbol: false),
          ),
          _buildTotalTracker(
            AppLocale.totalBalance.getString(context),
            formatAmountRP(totalBalance, useSymbol: false),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalTracker(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
