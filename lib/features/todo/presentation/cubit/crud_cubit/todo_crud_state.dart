part of 'todo_crud_cubit.dart';

sealed class TodoCrudState {}

final class TodoCrudLoading extends TodoCrudState {}

final class TodoCrudLoaded extends TodoCrudState {
  final List<Todo> allTodos;
  final List<Todo> filteredTodos;
  final List<Todo> completedTodos;
  final String searchText;
  final TodoCategory? selectedCategory;
  final String? selectedPriority;

  TodoCrudLoaded({
    required this.allTodos,
    required this.filteredTodos,
    required this.completedTodos,
    required this.searchText,
    this.selectedCategory,
    this.selectedPriority,
  });

  TodoCrudLoaded copyWith({
    List<Todo>? allTodos,
    List<Todo>? filteredTodos,
    List<Todo>? completedTodos,
    String? searchText,
    TodoCategory? selectedCategory,
    String? selectedPriority,
  }) {
    return TodoCrudLoaded(
      allTodos: allTodos ?? this.allTodos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      completedTodos: completedTodos ?? this.completedTodos,
      searchText: searchText ?? this.searchText,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPriority: selectedPriority ?? this.selectedPriority,
    );
  }
}

final class SingleTodoLoaded extends TodoCrudState {
  final Todo todo;

  SingleTodoLoaded(this.todo);
}

final class TodoCrudError extends TodoCrudState {
  final String errMessage;

  TodoCrudError(this.errMessage);
}
