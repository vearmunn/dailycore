import '../../../../utils/dates_utils.dart';
import '../../utils/expense_util.dart';
import 'expense_category.dart';

class Expense {
  final int id;
  final String? note;
  final double amount;
  final DateTime date;
  final String type;
  final String? image;
  final ExpenseCategory category;

  Expense({
    required this.id,
    this.note,
    required this.amount,
    required this.date,
    this.type = 'expense',
    this.image,
    required this.category,
  });
  List<String> toList() => [
    formattedDate(date),
    note ?? '',
    type,
    formatAmountRP(amount),
  ];

  static List<String> headers() => ['Date', 'Note', 'Type', 'Amount'];
}
