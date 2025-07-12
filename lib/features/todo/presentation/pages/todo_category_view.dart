import 'package:dailycore/features/todo/presentation/cubit/category_cubit/category_cubit.dart';
import 'package:dailycore/features/todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/models/todo_category.dart';
import '../../utils/todo_utils.dart';

class TodoCategoryView extends StatelessWidget {
  const TodoCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Category List'),
        actions: [
          IconButton(
            onPressed: () => showAddTodoCategoryBox(context),
            icon: Icon(Icons.post_add_rounded),
          ),
        ],
      ),
      body: BlocBuilder<TodoCategoryCubit, TodoCategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CategoryError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is CategoryLoaded) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                int reversedIndex = state.categoryList.length - 1 - index;
                final category = state.categoryList[reversedIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed:
                              (context) =>
                                  showEditTodoCategoryBox(context, category),
                          label: 'Edit',
                          icon: Icons.edit,
                          backgroundColor: Colors.blue,
                        ),
                        SlidableAction(
                          onPressed:
                              (context) =>
                                  _showDeleteCategoryBox(context, category),
                          label: 'Delete',
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(category.name),
                      visualDensity: VisualDensity.compact,
                      tileColor: Colors.white,
                      // trailing: Icon(
                      //   Icons.swipe_left,
                      //   color: Colors.black12,
                      //   size: 20,
                      // ),
                    ),
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  void _showDeleteCategoryBox(BuildContext context, TodoCategory category) {
    final categoryCubit = context.read<TodoCategoryCubit>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('All tasks in this category will be deleted.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  categoryCubit.deleteTodoCategory(category);
                  context.read<TodoCrudCubit>().loadTodos();
                  Navigator.pop(context);
                },
                child: Text('Confirm'),
              ),
            ],
          ),
    );
  }
}
