// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/todo/domain/models/todo_category.dart';
import 'package:dailycore/features/todo/domain/repository/todo_category_repo.dart';

part 'category_state.dart';

class TodoCategoryCubit extends Cubit<TodoCategoryState> {
  final TodoCategoryRepo todoCategoryRepo;
  TodoCategoryCubit(this.todoCategoryRepo) : super(CategoryLoading()) {
    loadTodoCategories();
  }

  void loadTodoCategories() async {
    try {
      emit(CategoryLoading());
      await todoCategoryRepo.initializeCategory();
      final categoryList = await todoCategoryRepo.loadCategories();
      emit(CategoryLoaded(categoryList));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void addTodoCategory({
    required String categoryName,
    required Color color,
    required IconData icon,
  }) async {
    try {
      emit(CategoryLoading());
      final newCategory = TodoCategory(
        id: DateTime.now().millisecondsSinceEpoch,
        name: categoryName,
        color: color,
        icon: icon,
      );

      final categoryList = await todoCategoryRepo.loadCategories();
      if (categoryList.any((category) => category.name == categoryName)) {
        emit(CategoryError('category already exists'));
      } else {
        await todoCategoryRepo.addCategory(newCategory);
        loadTodoCategories();
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void updateTodoCategory(TodoCategory category) async {
    try {
      emit(CategoryLoading());
      await todoCategoryRepo.updateCategory(category);
      loadTodoCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void deleteTodoCategory(int id) async {
    try {
      emit(CategoryLoading());
      await todoCategoryRepo.deleteCategory(id);
      loadTodoCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
