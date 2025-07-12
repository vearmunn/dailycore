import 'package:dailycore/features/expense_tracker/data/models/hive_expense_category.dart';
import 'package:dailycore/features/expense_tracker/domain/models/expense.dart';
import 'package:hive_ce/hive.dart';

class ExpenseHive extends HiveObject {
  late int id;
  String? note;
  late double amount;
  late DateTime date;
  late String type;
  String? image;
  late ExpenseCategoryHive category;

  Expense toDomain() {
    return Expense(
      id: id,
      note: note,
      amount: amount,
      date: date,
      type: type,
      image: image,
      category: category.toDomain(),
    );
  }

  static ExpenseHive fromDomain(Expense expense) {
    return ExpenseHive()
      ..id = expense.id
      ..note = expense.note
      ..amount = expense.amount
      ..date = expense.date
      ..type = expense.type
      ..image = expense.image
      ..category = ExpenseCategoryHive.fromDomain(expense.category);
  }
}
