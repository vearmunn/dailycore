import 'package:dailycore/components/scheduled_notifs_list/scheduled_notifs_list_page.dart';
import 'package:dailycore/features/habit_tracker/utils/habit_util.dart';
import 'package:dailycore/features/home/settings_page.dart';
import 'package:dailycore/features/todo/presentation/pages/todo_dashboard_page.dart';
import 'package:dailycore/features/todo/utils/todo_utils.dart';
import 'package:dailycore/utils/dates_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../localization/locales.dart';
import '../../utils/colors_and_icons.dart';
import '../../utils/spaces.dart';
import '../expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import '../expense_tracker/presentation/pages/dashboard.dart';
// import '../habit_tracker/presentation/pages/dashboard.dart';
import '../expense_tracker/utils/expense_util.dart';
import '../habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import '../habit_tracker/presentation/pages/habit_page.dart';
import '../todo/presentation/cubit/crud_cubit/todo_crud_cubit.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // verticalSpace(20),
              // _buildTodaysTodos(),
              // verticalSpace(30),
              // _buildTodaysHabits(context),
              // verticalSpace(30),
              // _buildThisMonthsSummary(),
              // verticalSpace(30),
              _buildInfoContainer(),
              verticalSpace(30),
              Row(
                children: [
                  BlocBuilder<TodoCrudCubit, TodoCrudState>(
                    builder: (context, state) {
                      if (state is TodoCrudError) {
                        return Center(child: Text(state.errMessage));
                      }
                      if (state is TodoCrudLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is TodoCrudLoaded) {
                        return _buildCustomContainer(
                          label: AppLocale.todoTitle.getString(context),
                          icon: Icons.task_outlined,
                          number: state.allTodos.length,
                          unit: AppLocale.todoUnits.getString(context),
                          backgroundColor: dailyCorePurple,
                          backgroundIconColor: dailyCorePurpleAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoDashboardPage(),
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  horizontalSpace(12),
                  BlocBuilder<HabitCrudCubit, HabitCrudState>(
                    builder: (context, state) {
                      if (state is HabitCrudLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is HabitCrudError) {
                        return Center(child: Text(state.errMessage));
                      }
                      if (state is HabitCrudLoaded) {
                        return _buildCustomContainer(
                          label: AppLocale.habitTitle.getString(context),
                          icon: Icons.sports_basketball_outlined,
                          number: state.habits.length,
                          unit: AppLocale.habitUnits.getString(context),
                          backgroundColor: dailyCorePink,
                          backgroundIconColor: dailyCorePinkAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitPage(),
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
              verticalSpace(16),
              _buildFinanceContainer(),
              Spacer(),
              _buildSettingsContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Color(0xFF333333),
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white10,
              ),
              child: Icon(Icons.settings, color: Colors.white),
            ),
            horizontalSpace(16),
            Text(
              AppLocale.settings.getString(context),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceContainer() {
    final PageController controller = PageController();
    return BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
      builder: (context, state) {
        if (state is ExpenseCrudLoaded) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseDashboard()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: dailyCoreCyan,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocale.financeTitle.getString(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.3,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: dailyCoreCyanAccent,
                          ),
                          child: Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(25),
                  SizedBox(
                    // color: Colors.red,
                    height: 85,
                    child: PageView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFinanceTracker(
                          AppLocale.totalBalance.getString(context),
                          state.monthlyTotal!.balance,
                        ),
                        _buildFinanceTracker(
                          AppLocale.totalExpenses.getString(context),
                          state.monthlyTotal!.expenses,
                        ),
                        _buildFinanceTracker(
                          AppLocale.totalIncome.getString(context),
                          state.monthlyTotal!.income,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller, // PageController
                      count: 3,
                      effect: WormEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.black12,
                        dotHeight: 8,
                      ), // your preferred effect
                      onDotClicked: (index) {},
                    ),
                  ),
                  verticalSpace(16),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildFinanceTracker(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          RichText(
            text: TextSpan(
              text: "Rp ",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: formatAmountRP(amount, useSymbol: false),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer() {
    return BlocBuilder<HabitCrudCubit, HabitCrudState>(
      builder: (context, habitState) {
        if (habitState is HabitCrudLoaded) {
          return BlocBuilder<TodoCrudCubit, TodoCrudState>(
            builder: (context, todoState) {
              if (todoState is TodoCrudLoaded) {
                final todaysTodoLength =
                    getTodaysTodos(todoState.allTodos).length;
                final todaysHabitLength =
                    habitsDueToday(
                      habitState.habits,
                      loadOnlyUndoneHabits: true,
                    ).length;
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.shade400,
                        ),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate3(DateTime.now()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            todaysHabitLength == 0 && todaysTodoLength == 0
                                ? Text(
                                  AppLocale.noTodosAndHabitsFound.getString(
                                    context,
                                  ),
                                )
                                : RichText(
                                  text: TextSpan(
                                    text: AppLocale.youHave.getString(context),
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text:
                                            "$todaysTodoLength ${AppLocale.tasks.getString(context)} ${AppLocale.and.getString(context)} $todaysHabitLength ${AppLocale.habits.getString(context)}",
                                        style: TextStyle(
                                          color: dailyCoreBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: AppLocale.toWorkOn.getString(
                                          context,
                                        ),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildCustomContainer({
    required String label,
    required IconData icon,
    required int number,
    required String unit,
    required Color backgroundColor,
    required Color backgroundIconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: backgroundIconColor,
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                ],
              ),
              verticalSpace(30),
              RichText(
                text: TextSpan(
                  text: number.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: unit,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
