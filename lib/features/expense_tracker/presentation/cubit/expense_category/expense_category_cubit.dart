import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/expense_category.dart';
import '../../../domain/repository/expense_category_repo.dart';

part 'expense_category_state.dart';

class ExpenseCategoryCubit extends Cubit<ExpenseCategoryState> {
  final ExpenseCategoryRepo expenseCategoryRepo;
  ExpenseCategoryCubit(this.expenseCategoryRepo) : super(CategoryLoading()) {
    loadExpenseCategories();
  }

  void loadExpenseCategories() async {
    try {
      emit(CategoryLoading());
      await expenseCategoryRepo.initializeCategory();
      final categoryList = await expenseCategoryRepo.loadCategories();
      emit(CategoriesLoaded(categoryList));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void addExpenseCategory({
    required String categoryName,
    required Color color,
    required IconData icon,
    required String type,
  }) async {
    try {
      emit(CategoryLoading());
      final newCategory = ExpenseCategory(
        id: DateTime.now().millisecondsSinceEpoch,
        name: categoryName,
        color: color,
        icon: icon,
        type: type,
      );

      final categoryList = await expenseCategoryRepo.loadCategories();
      if (categoryList.any((category) => category.name == categoryName)) {
        emit(CategoryError('category already exists'));
      } else {
        await expenseCategoryRepo.addCategory(newCategory);
        loadExpenseCategories();
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void updateExpenseCategory(ExpenseCategory category) async {
    try {
      emit(CategoryLoading());
      await expenseCategoryRepo.updateCategory(category);
      loadExpenseCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void deleteExpenseCategory(ExpenseCategory category) async {
    try {
      emit(CategoryLoading());
      await expenseCategoryRepo.deleteCategory(category);
      loadExpenseCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
