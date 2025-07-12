import '../models/expense_category.dart';

abstract class ExpenseCategoryRepo {
  Future initializeCategory();

  Future<List<ExpenseCategory>> loadCategories();

  Future addCategory(ExpenseCategory newCategory);

  Future updateCategory(ExpenseCategory category);

  Future deleteCategory(ExpenseCategory category);
}
