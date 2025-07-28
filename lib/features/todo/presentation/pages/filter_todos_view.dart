import 'package:dailycore/features/todo/domain/models/todo_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../../../localization/locales.dart';
import '../../../../utils/spaces.dart';
import '../../utils/todo_utils.dart';
import '../../widgets/todo_tile.dart';
import '../cubit/category_cubit/category_cubit.dart';
import '../cubit/crud_cubit/todo_crud_cubit.dart';
import 'todo_details_view.dart';

class FilterTodosView extends StatefulWidget {
  const FilterTodosView({super.key});

  @override
  State<FilterTodosView> createState() => _FilterTodosViewState();
}

class _FilterTodosViewState extends State<FilterTodosView> {
  final searchController = TextEditingController();
  final categoryController = TextEditingController();
  final priorityController = TextEditingController();
  TodoCategory? selectedCategory;
  String? selectedPriority;

  void applySearch() {
    context.read<TodoCrudCubit>().searchTodos(
      query: searchController.text,
      selectedCategory: selectedCategory,
      selectedPriority: selectedPriority,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    categoryController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Future.delayed(
          Duration(seconds: 1),
          context.read<TodoCrudCubit>().clearFilters,
        );
        // Future.delayed(
        //   Duration(seconds: 1),
        //   context.read<TodoCrudCubit>().loadTodos,
        // );
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text(AppLocale.searchTodos.getString(context))),
          body: BlocBuilder<TodoCrudCubit, TodoCrudState>(
            builder: (context, state) {
              if (state is TodoCrudLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is TodoCrudError) {
                return Center(child: Text(state.errMessage));
              }
              if (state is TodoCrudLoaded) {
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: AppLocale.search.getString(context),
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onChanged: (value) => applySearch(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.filter_alt),
                            onPressed: () {
                              _showFilterModalSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(8),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      itemCount: state.filteredTodos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final todo = state.filteredTodos[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TodoTile(
                            todo: todo,
                            onTap: () {
                              context.read<TodoCrudCubit>().loadSingleTodo(
                                todo.id,
                              );
                              context.read<DateCubit>().setDate(todo.dueDate);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TodoDetailsView(id: todo.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddTodoBox(context),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  _showFilterModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                DropdownMenu(
                  width: double.infinity,
                  inputDecorationTheme: InputDecorationTheme(
                    border: UnderlineInputBorder(),
                  ),
                  label: Text(AppLocale.selectPriority.getString(context)),
                  controller: priorityController,
                  onSelected: (value) {
                    selectedPriority = value;
                    applySearch();
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      label: AppLocale.low.getString(context),
                      value: 'Low',
                    ),
                    DropdownMenuEntry(
                      label: AppLocale.medium.getString(context),
                      value: 'Medium',
                    ),
                    DropdownMenuEntry(
                      label: AppLocale.high.getString(context),
                      value: 'High',
                    ),
                    DropdownMenuEntry(
                      label: AppLocale.all.getString(context),
                      value: '',
                    ),
                  ],
                ),
                verticalSpace(12),
                BlocBuilder<TodoCategoryCubit, TodoCategoryState>(
                  builder: (context, categoryState) {
                    if (categoryState is CategoryLoaded) {
                      return DropdownMenu(
                        controller: categoryController,
                        inputDecorationTheme: InputDecorationTheme(
                          border: UnderlineInputBorder(),
                        ),
                        width: double.infinity,
                        label: Text(
                          AppLocale.selectCategory.getString(context),
                        ),
                        onSelected: (value) {
                          selectedCategory = value;
                          applySearch();
                        },
                        dropdownMenuEntries: List.generate(
                          categoryState.categoryList.length,
                          (index) => DropdownMenuEntry(
                            value: categoryState.categoryList[index],
                            label: categoryState.categoryList[index].name,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
                verticalSpace(12),
                TextButton(
                  onPressed: () {
                    context.read<TodoCrudCubit>().clearFilters();
                    categoryController.clear();
                    searchController.clear();
                    priorityController.clear();
                  },
                  child: Text(AppLocale.clearFilters.getString(context)),
                ),
              ],
            ),
          ),
    );
  }
}
