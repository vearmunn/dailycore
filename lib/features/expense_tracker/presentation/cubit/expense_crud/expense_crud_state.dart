part of 'expense_crud_cubit.dart';

sealed class ExpenseCrudState {}

final class ExpenseCrudLoading extends ExpenseCrudState {}

final class ExpenseCrudLoaded extends ExpenseCrudState {
  final List<Expense> expenseList;
  final MonthlyTotal? monthlyTotal;

  ExpenseCrudLoaded(this.expenseList, this.monthlyTotal);
}

final class ExpensesSearchSuccess extends ExpenseCrudState {
  final List<Expense> expenseList;

  ExpensesSearchSuccess(this.expenseList);
}

final class ExpenseSingleCrudLoaded extends ExpenseCrudState {
  final Expense expense;

  ExpenseSingleCrudLoaded(this.expense);
}

final class ExpenseCrudError extends ExpenseCrudState {
  final String errMessage;

  ExpenseCrudError(this.errMessage);
}
