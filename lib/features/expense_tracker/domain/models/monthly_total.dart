// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../utils/expense_util.dart';

class MonthlyTotal {
  late int month;
  late int year;
  late double expenses;
  late double income;
  late double balance;
  MonthlyTotal({
    required this.month,
    required this.year,
    required this.expenses,
    required this.income,
    required this.balance,
  });

  List<String> toList() => [
    getMonthName(month),
    year.toString(),
    formatAmountRP(expenses),
    formatAmountRP(income),
    formatAmountRP(balance),
  ];

  static List<String> headers() => [
    'Month',
    'Year',
    'Expenses',
    'Income',
    'Balance',
  ];
}
