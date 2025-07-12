// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../widgets/todo_details.dart';

class TodoDetailsView extends StatelessWidget {
  final int id;
  const TodoDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // final todoCubit = context.read<TodoCrudCubit>();
    // final todoController = TextEditingController();
    // TodoCategory selectedCategory = TodoCategory(id: 0, name: 'none');
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<TodoCrudCubit>().loadTodos();
        context.read<DateCubit>().clearDate();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<TodoCrudCubit, TodoCrudState>(
          builder: (context, state) {
            if (state is TodoCrudLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is TodoCrudError) {
              return Center(child: Text(state.errMessage));
            }
            if (state is SingleTodoLoaded) {
              return TodoDetails(todo: state.todo);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
