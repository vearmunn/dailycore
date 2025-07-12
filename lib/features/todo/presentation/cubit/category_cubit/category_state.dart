part of 'category_cubit.dart';

sealed class TodoCategoryState {}

final class CategoryLoading extends TodoCategoryState {}

final class CategoryLoaded extends TodoCategoryState {
  final List<TodoCategory> categoryList;

  CategoryLoaded(this.categoryList);
}

final class CategoryError extends TodoCategoryState {
  final String errMessage;

  CategoryError(this.errMessage);
}
