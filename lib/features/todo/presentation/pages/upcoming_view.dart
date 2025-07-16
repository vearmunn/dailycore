import 'package:dailycore/features/todo/presentation/cubit/upcoming_cubit/upcoming_cubit.dart';
import 'package:dailycore/features/todo/widgets/todo_tile.dart';
import 'package:dailycore/features/todo/widgets/upcoming_table_calendart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../../../utils/dates_utils.dart';
import '../../domain/models/todo.dart';
import '../../utils/todo_utils.dart';
import '../cubit/crud_cubit/todo_crud_cubit.dart';
import 'todo_details_view.dart';

class UpcomingView extends StatelessWidget {
  const UpcomingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                UpcomingTableCalendar(
                  todoDates:
                      state.allTodos.map((todo) => todo.dueDate).toList(),
                ),
                _buildUpcomingTodos(context, state.allTodos),
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
    );
  }

  Widget _buildUpcomingTodos(BuildContext context, List<Todo> todos) {
    // final todoCubit = context.read<TodoCrudCubit>();
    return BlocBuilder<UpcomingDateCubit, DateTime?>(
      builder: (context, upcomingDate) {
        final upcomingTodos = getUpcomingTodos(todos, upcomingDate!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                formattedDate2(upcomingDate),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: upcomingTodos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = upcomingTodos[index];
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
            ),
          ],
        );
      },
    );
  }
}
