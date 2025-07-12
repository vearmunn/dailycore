// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/expense_tracker/domain/repository/expense_repo.dart';

import '../../../domain/models/expense.dart';
import '../../../domain/models/expense_category.dart';
import '../../../domain/models/monthly_total.dart';

part 'expense_crud_state.dart';

class ExpenseCrudCubit extends Cubit<ExpenseCrudState> {
  final now = DateTime.now();

  final ExpenseRepo expenseRepo;
  ExpenseCrudCubit(this.expenseRepo) : super(ExpenseCrudLoading()) {
    loadExpenses(now.year, now.month);
  }

  Future loadExpenses(int year, int month) async {
    try {
      emit(ExpenseCrudLoading());
      var expenseList = await expenseRepo.getAllExpenses();
      MonthlyTotal monthlyTotal = getMonthlyTotal(expenseList, year, month);
      expenseList =
          expenseList
              .where(
                (expense) =>
                    expense.date.year == year && expense.date.month == month,
              )
              .toList();
      emit(ExpenseCrudLoaded(expenseList, monthlyTotal));
    } catch (e) {
      emit(ExpenseCrudError(e.toString()));
    }
  }

  Future loadSingleExpense(int id) async {
    try {
      emit(ExpenseCrudLoading());
      var expense = await expenseRepo.getSingleExpense(id);

      emit(ExpenseSingleCrudLoaded(expense));
    } catch (e) {
      emit(ExpenseCrudError(e.toString()));
    }
  }

  Future addExpense(
    String note,
    double amount,
    DateTime date,
    ExpenseCategory category,
    String type,
  ) async {
    try {
      emit(ExpenseCrudLoading());
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch,
        note: note,
        amount: amount,
        date: date,
        category: category,
        type: type,
      );
      await expenseRepo.addExpense(newExpense);
      await loadExpenses(now.year, now.month);
    } catch (e) {
      emit(ExpenseCrudError(e.toString()));
    }
  }

  Future deleteExpense(Expense expense) async {
    try {
      emit(ExpenseCrudLoading());
      await expenseRepo.deleteExpense(expense);
      await loadExpenses(now.year, now.month);
    } catch (e) {
      emit(ExpenseCrudError(e.toString()));
    }
  }

  Future updateExpense(Expense expense) async {
    try {
      emit(ExpenseCrudLoading());
      // print('UPDATED EXPENSE: ${expense.amount}');
      await expenseRepo.updateExpense(expense);
      await loadSingleExpense(expense.id);
    } catch (e) {
      emit(ExpenseCrudError(e.toString()));
    }
  }
}
