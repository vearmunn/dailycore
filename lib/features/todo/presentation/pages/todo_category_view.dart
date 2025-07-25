import 'package:dailycore/features/todo/presentation/cubit/category_cubit/category_cubit.dart';
import 'package:dailycore/utils/add_edit_category.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/list_tile_icon.dart';
import '../../../../utils/delete_confirmation.dart';
import '../../domain/models/todo_category.dart';

class TodoCategoryView extends StatelessWidget {
  const TodoCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Category List'),
        actions: [
          IconButton(
            onPressed:
                () => showAddEditCategoryModalBottomSheet(
                  context,
                  isExpenseCategory: false,
                ),
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
            final categoryList =
                state.categoryList
                    .where((category) => category.id != 00)
                    .toList();
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                // int reversedIndex = state.categoryList.length - 1 - index;
                final category = categoryList[index];
                return Dismissible(
                  key: ValueKey(category.id),
                  confirmDismiss: (direction) async {
                    return await showDeleteBox(
                      context,
                      'Delete this category ?',
                    );
                  },
                  onDismissed: (direction) {
                    context.read<TodoCategoryCubit>().deleteTodoCategory(
                      category.id,
                    );
                  },
                  child: listTileIcon(
                    context,
                    color: category.color,
                    icon: getIconByName(category.iconName),
                    title: category.name,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showAddEditCategoryModalBottomSheet(
                        context,
                        isUpadting: true,
                        isExpenseCategory: false,
                        todoCategory: TodoCategory(
                          id: category.id,
                          name: category.name,
                          color: category.color,
                          iconName: category.iconName,
                        ),
                      );
                    },
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
}
