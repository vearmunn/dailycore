part of 'expense_category_cubit.dart';

sealed class ExpenseCategoryState {}

final class CategoryLoading extends ExpenseCategoryState {}

final class CategoriesLoaded extends ExpenseCategoryState {
  final List<ExpenseCategory> categoryList;

  CategoriesLoaded(this.categoryList);
}

final class CategoryError extends ExpenseCategoryState {
  final String errMessage;

  CategoryError(this.errMessage);
}
