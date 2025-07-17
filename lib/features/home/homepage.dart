import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/date_picker/pick_date_cubit.dart';
import '../../utils/colors_and_icons.dart';
import '../../utils/custom_button.dart';
import '../../utils/spaces.dart';
import '../expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import '../expense_tracker/presentation/pages/dashboard.dart';
// import '../habit_tracker/presentation/pages/dashboard.dart';
import '../expense_tracker/utils/expense_util.dart';
import '../habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import '../habit_tracker/presentation/pages/habit_page.dart';
import '../habit_tracker/utils/habit_util.dart';
import '../habit_tracker/widgets/habit_tile.dart';
import '../todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import '../todo/presentation/pages/todo_dashboard_page.dart';
import '../todo/presentation/pages/todo_details_view.dart';
import '../todo/utils/todo_utils.dart';
import '../todo/widgets/todo_tile.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DailyCore',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: dailyCoreBlue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildTodaysTodosLVB(),
          verticalSpace(30),
          _buildHabitList(context),
          verticalSpace(30),
          _buildThisMonthsSummary(),
          verticalSpace(30),
        ],
      ),
    );
  }

  Widget _buildThisMonthsSummary() {
    return BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
      builder: (context, state) {
        if (state is ExpenseCrudLoaded) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "This Month's Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    DailyCoreButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseDashboard(),
                          ),
                        );
                      },
                      child: Text('View details'),
                    ),
                  ],
                ),
                verticalSpace(4),
                Divider(),
                verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTracker(
                      'Total Expenses',
                      state.monthlyTotal!.expenses,
                    ),
                    _buildTracker('Total Income', state.monthlyTotal!.income),
                    _buildTracker('Total Balance', state.monthlyTotal!.balance),
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildTracker(String title, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black54, fontSize: 12)),
        verticalSpace(4),
        Text(
          formatAmountRP(amount),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTodaysTodosLVB() {
    return BlocBuilder<TodoCrudCubit, TodoCrudState>(
      builder: (context, state) {
        if (state is TodoCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is TodoCrudError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is TodoCrudLoaded) {
          final todaysTodos = getTodaysTodos(
            state.allTodos,
            loadThreeTodos: true,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(
                title: "Today's Todos",
                subtitle1: 'You have ',
                subtitle2: getTodaysTodos(state.allTodos).length.toString(),
                subtitle3:
                    '${todaysTodos.length == 1 ? ' work' : ' works'} today',
                buttonTitle: 'View all todos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDashboardPage(),
                    ),
                  );
                },
              ),
              verticalSpace(16),
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
    );
  }

  Widget _buildHabitList(BuildContext context) {
    final habitCubit = context.read<HabitCrudCubit>();
    return BlocBuilder<HabitCrudCubit, HabitCrudState>(
      builder: (context, state) {
        if (state is HabitCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is HabitCrudError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is HabitCrudLoaded) {
          final todaysHabits = habitsDueToday(
            state.habits,
            loadThreehabits: true,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildTitle(
                title: "Today's Habits",
                subtitle1: 'You have ',
                subtitle2: todaysHabits.length.toString(),
                subtitle3:
                    '${todaysHabits.length == 1 ? ' work' : ' works'} today',
                buttonTitle: 'View all Habits',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabitPage()),
                  );
                },
              ),
              verticalSpace(16),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: todaysHabits.length,
                itemBuilder: (BuildContext context, int index) {
                  final habit = todaysHabits[index];

                  bool isCompletedToday = isHabitCompletedToday(
                    habit.completedDays!,
                  );
                  return buildHabitTile(
                    context: context,
                    habit: habit,
                    habitCubit: habitCubit,
                    isCompletedToday: isCompletedToday,
                  );
                },
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildTitle({
    required String title,
    required String subtitle1,
    required String subtitle2,
    required String subtitle3,
    required String buttonTitle,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            verticalSpace(4),
            RichText(
              text: TextSpan(
                text: subtitle1,
                style: TextStyle(color: Colors.black54, fontSize: 12),
                children: [
                  TextSpan(
                    text: subtitle2,
                    style: TextStyle(
                      color: dailyCoreBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: subtitle3),
                ],
              ),
            ),
          ],
        ),
        DailyCoreButton(onTap: onTap, child: Text(buttonTitle)),
      ],
    );
  }
}
