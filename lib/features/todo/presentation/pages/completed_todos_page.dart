import 'package:dailycore/features/todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../widgets/todo_tile.dart';
import 'todo_details_view.dart';

class CompletedTodosPage extends StatelessWidget {
  const CompletedTodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Todos')),
      body: BlocBuilder<TodoCrudCubit, TodoCrudState>(
        builder: (context, state) {
          if (state is TodoCrudLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.completedTodos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = state.completedTodos[index];
                return TodoTile(
                  todo: todo,
                  onTap: () {
                    context.read<TodoCrudCubit>().loadSingleTodo(todo.id);
                    context.read<DateCubit>().setDate(todo.dueDate);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailsView(id: todo.id),
                      ),
                    );
                  },
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
