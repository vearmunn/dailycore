import 'package:dailycore/features/expense_tracker/domain/models/expense.dart';

abstract class ExpenseRepo {
  Future<List<Expense>> getAllExpenses();

  Future<Expense> getSingleExpense(int id);

  Future addExpense(Expense newExpense);

  Future updateExpense(Expense expense);

  Future deleteExpense(Expense expense);
}
