// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/todo/domain/models/todo_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/todo.dart';
import '../../../domain/repository/todo_repo.dart';

part 'todo_crud_state.dart';

class TodoCrudCubit extends Cubit<TodoCrudState> {
  final TodoRepo todoRepo;
  TodoCrudCubit(this.todoRepo) : super(TodoCrudLoading()) {
    loadTodos();
  }

  Future loadTodos() async {
    try {
      emit(TodoCrudLoading());
      final todoList = await todoRepo.getTodos();

      emit(
        TodoCrudLoaded(
          allTodos: todoList,
          filteredTodos: todoList,
          searchText: '',
        ),
      );
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  void searchTodos({
    String query = '',
    TodoCategory? selectedCategory,
    String? selectedPriority,
  }) {
    final currentState = state;
    if (currentState is TodoCrudLoaded) {
      try {
        emit(TodoCrudLoading());
        final filtered =
            currentState.allTodos.where((todo) {
              final matchesText = todo.text.toLowerCase().contains(
                query.toLowerCase(),
              );

              final matchesCategory =
                  selectedCategory == null ||
                  selectedCategory.name.isEmpty ||
                  todo.category.id == selectedCategory.id;

              final matchesPriority =
                  selectedPriority == null ||
                  selectedPriority.isEmpty ||
                  todo.priority == selectedPriority;

              return matchesText && matchesCategory && matchesPriority;
            }).toList();

        emit(
          currentState.copyWith(
            searchText: query,
            filteredTodos: filtered,
            selectedCategory: selectedCategory,
            selectedPriority: selectedPriority,
          ),
        );
      } catch (e) {
        emit(TodoCrudError(e.toString()));
      }
    }
  }

  void clearFilters() {
    if (state is TodoCrudLoaded) {
      final currentState = state as TodoCrudLoaded;
      emit(
        currentState.copyWith(
          searchText: '',
          selectedCategory: null,
          filteredTodos: currentState.allTodos,
          selectedPriority: '',
        ),
      );
    }
  }

  Future loadSingleTodo(int id) async {
    try {
      emit(TodoCrudLoading());
      final todo = await todoRepo.getSingleTodo(id);
      emit(SingleTodoLoaded(todo));
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future addTodo(
    String text,
    DateTime? dueDate,
    TodoCategory category,
    String priority,
  ) async {
    try {
      emit(TodoCrudLoading());
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        text: text,
        dueDate: dueDate,
        category: category,
        priority: priority,
      );
      await todoRepo.addTodo(newTodo);
      await loadTodos();
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future deleteTodo(Todo todo) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.deleteTodo(todo);
      await loadTodos();
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future updateTodo(Todo todo) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.updateTodo(todo);
      await loadTodos();
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future toggleCompletion(Todo todo) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.toggleTodo(todo);
      await loadTodos();
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future addNewSubTodo(int id, String text) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.addSubTodo(
        id,
        SubTodo(id: DateTime.now().millisecondsSinceEpoch, text: text),
      );
      await loadSingleTodo(id);
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future toggleSubTodoCompletion(
    int id,
    SubTodo subTodo, {
    bool shouldLoadAllTodos = false,
  }) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.toggleSubTodo(id, subTodo);
      if (shouldLoadAllTodos) {
        await loadTodos();
      } else {
        await loadSingleTodo(id);
      }
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future deleteSubtodo(
    int id,
    SubTodo subTodo, {
    bool shouldLoadAllTodos = false,
  }) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.deleteSubTodo(id, subTodo);
      if (shouldLoadAllTodos) {
        await loadTodos();
      } else {
        await loadSingleTodo(id);
      }
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future updateSubTodo(
    int id,
    SubTodo subTodo, {
    bool shouldLoadAllTodos = false,
  }) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.updateSubTodo(id, subTodo);
      if (shouldLoadAllTodos) {
        await loadTodos();
      } else {
        await loadSingleTodo(id);
      }
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }

  Future reorderSubTodo({
    required int id,
    required int newIndex,
    required int oldIndex,
    bool shouldLoadAllTodos = false,
  }) async {
    try {
      emit(TodoCrudLoading());
      await todoRepo.reorderSubTodo(
        id: id,
        newIndex: newIndex,
        oldIndex: oldIndex,
      );
      if (shouldLoadAllTodos) {
        await loadTodos();
      } else {
        await loadSingleTodo(id);
      }
    } catch (e) {
      emit(TodoCrudError(e.toString()));
    }
  }
}
