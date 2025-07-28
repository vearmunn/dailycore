import 'package:dailycore/components/scheduled_notifs_list/scheduled_notifs_list_page.dart';
import 'package:dailycore/features/home/settings_page.dart';
import 'package:dailycore/features/todo/presentation/pages/todo_dashboard_page.dart';
import 'package:dailycore/utils/dates_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../localization/locales.dart';
import '../../utils/colors_and_icons.dart';
import '../../utils/spaces.dart';
import '../expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import '../expense_tracker/presentation/pages/dashboard.dart';
// import '../habit_tracker/presentation/pages/dashboard.dart';
import '../expense_tracker/utils/expense_util.dart';
import '../habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import '../habit_tracker/presentation/pages/habit_page.dart';
import '../habit_tracker/utils/habit_util.dart';
import '../todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';
import '../todo/utils/todo_utils.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduledNotifsListPage(),
                ),
              ),
          child: Text(
            'DailyCore',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            verticalSpace(20),
            _buildTodaysTodos(),
            verticalSpace(30),
            _buildTodaysHabits(context),
            verticalSpace(30),
            _buildThisMonthsSummary(),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysTodos() {
    return BlocBuilder<TodoCrudCubit, TodoCrudState>(
      builder: (context, state) {
        if (state is TodoCrudError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is TodoCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is TodoCrudLoaded) {
          final todaysTodos = getTodaysTodos(state.allTodos);
          return _buildFeatureCard(
            title: AppLocale.todaysTodos.getString(context),
            buttonTitle: AppLocale.viewAllTodos.getString(context),
            color: dailyCoreBlue,
            icon: Icons.photo_album,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoDashboardPage()),
              );
            },
            subtitle: context.formatString(AppLocale.todaysTodosSubtitle, [
              '${getTodaysTodos(state.allTodos).length}',
            ]),
            body:
                todaysTodos.isEmpty
                    ? _buildEmptyBody(AppLocale.noTodosFound.getString(context))
                    : ListView.separated(
                      padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todaysTodos.length,
                      separatorBuilder: (context, index) => verticalSpace(20),
                      itemBuilder: (BuildContext context, int index) {
                        final todo = todaysTodos[index];
                        Color getPriorityColor() {
                          switch (todo.priority) {
                            case 'Low':
                              return dailyCoreGreen;
                            case 'Medium':
                              return dailyCoreOrange;
                            case 'High':
                              return dailyCoreRed;

                            default:
                              return Colors.transparent;
                          }
                        }

                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpace(6),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(
                                      todo.priority,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: getPriorityColor(),
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Text(
                                      todo.category.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    VerticalDivider(),
                                    if (todo.dueDate != null)
                                      Text(
                                        formatTime(todo.dueDate!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildFeatureCard({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget body,
    required VoidCallback onTap,
    required String buttonTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(5, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  horizontalSpace(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(subtitle, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(8),
            body,
            verticalSpace(8),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              // width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    buttonTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  horizontalSpace(4),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThisMonthsSummary() {
    return BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
      builder: (context, state) {
        if (state is ExpenseCrudLoaded) {
          return _buildFeatureCard(
            color: dailyCoreOrange,
            title: AppLocale.thisMonthsSummary.getString(context),
            subtitle: formatMonthYear(DateTime.now()),
            icon: Icons.analytics,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseDashboard()),
              );
            },
            buttonTitle: AppLocale.viewFinanceTrackerDetails.getString(context),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTracker(
                    AppLocale.totalExpenses.getString(context),
                    state.monthlyTotal!.expenses,
                  ),
                  _buildTracker(
                    AppLocale.totalIncome.getString(context),
                    state.monthlyTotal!.income,
                  ),
                  _buildTracker(
                    AppLocale.totalBalance.getString(context),
                    state.monthlyTotal!.balance,
                  ),
                ],
              ),
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

  Widget _buildTodaysHabits(BuildContext context) {
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
            loadOnlyUndoneHabits: true,
          );

          return _buildFeatureCard(
            color: dailyCoreGreen,
            title: AppLocale.todaysHabits.getString(context),
            subtitle: context.formatString(AppLocale.todaysHabitsSubtitle, [
              '${todaysHabits.length}',
            ]),
            icon: Icons.replay_circle_filled_rounded,
            buttonTitle: AppLocale.viewAllHabits.getString(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HabitPage()),
              );
            },
            body:
                todaysHabits.isEmpty
                    ? _buildEmptyBody(
                      AppLocale.noHabitsFound.getString(context),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.all(16),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todaysHabits.length,
                      separatorBuilder: (context, index) => verticalSpace(20),
                      itemBuilder: (BuildContext context, int index) {
                        final habit = todaysHabits[index];
                        int currentStreak = 0;

                        if (habit.repeatType == 'daily') {
                          currentStreak =
                              getDailyStreaks(habit.completedDays)[0];
                        } else if (habit.repeatType == 'weekly') {
                          currentStreak =
                              getWeeklyStreaks(
                                dates: habit.completedDays,
                                selectedDays: habit.daysofWeek,
                              )[0];
                        } else {
                          currentStreak =
                              getMonthlyStreak(
                                dates: habit.completedDays,
                                selectedDates: habit.datesofMonth,
                              )[0];
                        }

                        return Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: fromArgb32(habit.color).withAlpha(50),
                              ),
                              child: Icon(
                                getIconByName(habit.iconName),
                                color: fromArgb32(habit.color),
                              ),
                            ),
                            horizontalSpace(12),
                            Text(
                              habit.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            currentStreak == 0
                                ? SizedBox.shrink()
                                : Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Image.asset(
                                        'assets/images/danger.png',
                                        width: 28,
                                        color: Colors.orange,
                                      ),
                                      Text(
                                        currentStreak.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        );
                      },
                    ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Center _buildEmptyBody(String title) {
    return Center(
      child: Column(
        children: [
          verticalSpace(20),
          Opacity(
            opacity: 0.5,
            child: Image.asset('assets/images/empty-inbox.png', width: 100),
          ),
          verticalSpace(8),
          Text(title, style: TextStyle(color: Colors.grey)),
          verticalSpace(30),
        ],
      ),
    );
  }
}
