import 'package:dailycore/features/todo/utils/todo_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../../../utils/colors_and_icons.dart';
import '../../../../utils/spaces.dart';
import '../../widgets/todo_tile.dart';
import '../cubit/crud_cubit/todo_crud_cubit.dart';
import 'todo_details_view.dart';

class TodayView extends StatelessWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    // final todoCubit = context.read<TodoCrudCubit>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<TodoCrudCubit, TodoCrudState>(
        builder: (context, state) {
          if (state is TodoCrudLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TodoCrudError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is TodoCrudLoaded) {
            final now = DateTime.now();
            final todaysTodos = getTodaysTodos(state.allTodos);
            final overdueTodos = getOverdueTodos(state.allTodos);
            final upcomingTodos = state.allTodos.where(
              (todo) =>
                  todo.dueDate != null &&
                  todo.dueDate!.isAfter(
                    DateTime(now.year, now.month, now.day, 23, 59),
                  ),
            );
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                todaysTodos.isEmpty
                    ? SizedBox.shrink()
                    : Text(
                      'You have work today!',
                      style: TextStyle(color: Colors.black45, fontSize: 16),
                    ),
                verticalSpace(todaysTodos.isEmpty ? 0 : 12),
                Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTodoNumberitem(
                        title: 'All',
                        number: state.allTodos.length,
                        bgColor: Colors.grey,
                        isFirst: true,
                      ),
                      _buildTodoNumberitem(
                        title: 'Today',
                        number: todaysTodos.length,
                        bgColor: Colors.grey,
                      ),
                      _buildTodoNumberitem(
                        title: 'Upcoming',
                        number: upcomingTodos.length,
                        bgColor: Colors.grey,
                      ),
                      _buildTodoNumberitem(
                        title: 'Overdue',
                        number: overdueTodos.length,
                        bgColor: dailyCoreRed,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                verticalSpace(20),
                if (overdueTodos.isNotEmpty)
                  Text(
                    'Overdue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: dailyCoreRed,
                    ),
                  ),
                if (overdueTodos.isNotEmpty) verticalSpace(12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: overdueTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = overdueTodos[index];
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
                verticalSpace(12),
                if (todaysTodos.isNotEmpty)
                  Text(
                    'Today',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                if (todaysTodos.isNotEmpty) verticalSpace(12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: todaysTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todaysTodos[index];
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

  Widget _buildTodoNumberitem({
    required String title,
    required int number,
    required Color bgColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor.withAlpha(50),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(isFirst ? 10 : 0),
            right: Radius.circular(isLast ? 10 : 0),
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: bgColor == Colors.grey ? Colors.black54 : bgColor,
              ),
            ),
            Text(
              number.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: bgColor == Colors.grey ? Colors.black54 : bgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
