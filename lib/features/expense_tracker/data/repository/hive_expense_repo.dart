import 'package:dailycore/features/expense_tracker/data/models/hive_expense.dart';
import 'package:dailycore/features/expense_tracker/data/models/hive_expense_category.dart';
import 'package:dailycore/features/expense_tracker/domain/models/expense.dart';
import 'package:dailycore/features/expense_tracker/domain/repository/expense_repo.dart';
import 'package:dailycore/consts/boxes.dart';
import 'package:hive_ce/hive.dart';

class HiveExpenseRepo implements ExpenseRepo {
  final box = Hive.box<ExpenseHive>(expenseBox);
  @override
  Future<List<Expense>> getAllExpenses() async {
    final expenseList = box.values;
    return expenseList.map((expense) => expense.toDomain()).toList();
  }

  @override
  Future<Expense> getSingleExpense(int id) async {
    ExpenseHive expense = box.values.firstWhere(
      (expenseFromBox) => expenseFromBox.id == id,
    );
    return expense.toDomain();
  }

  @override
  Future addExpense(Expense newExpense) {
    final expenseHive = ExpenseHive.fromDomain(newExpense);
    return box.add(expenseHive);
  }

  @override
  Future deleteExpense(Expense expense) async {
    ExpenseHive soonToBeDeletedExpense = box.values.firstWhere(
      (expenseFromBox) => expenseFromBox.id == expense.id,
    );

    await soonToBeDeletedExpense.delete();
  }

  @override
  Future updateExpense(Expense expense) async {
    ExpenseHive updatingExpense = box.values.firstWhere(
      (expenseFromBox) => expenseFromBox.id == expense.id,
    );
    updatingExpense.note = expense.note;
    updatingExpense.type = expense.type;
    updatingExpense.image = expense.image;
    updatingExpense.amount = expense.amount;
    updatingExpense.date = expense.date;
    updatingExpense.category = ExpenseCategoryHive.fromDomain(expense.category);
    updatingExpense.save();
  }
}
