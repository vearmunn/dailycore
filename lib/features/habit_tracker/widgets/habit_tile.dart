import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/colors_and_icons.dart';
import '../../../utils/spaces.dart';
import '../../expense_tracker/presentation/pages/add_edit_expense_page.dart';
import '../domain/models/habit.dart';
import '../presentation/crud_cubit/habit_crud_cubit.dart';
import '../presentation/pages/habit_detail_page.dart';
import '../utils/habit_util.dart';

Widget buildHabitTile({
  required BuildContext context,
  required Habit habit,
  required bool isCompletedToday,
  required HabitCrudCubit habitCubit,
}) {
  int currentStreak = 0;

  if (habit.repeatType == 'daily') {
    currentStreak = getDailyStreaks(habit.completedDays)[0];
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

  return GestureDetector(
    onTap: () {
      habitCubit.loadSingleHabit(habit.id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HabitDetailPage()),
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: fromArgb32(habit.color).withAlpha(30),
            ),
            child: Icon(
              color: fromArgb32(habit.color),
              getIconByName(habit.iconName),
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              habit.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          horizontalSpace(currentStreak == 0 ? 0 : 20),
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
          horizontalSpace(12),
          Checkbox(
            shape: CircleBorder(),
            visualDensity: VisualDensity.compact,
            value: isCompletedToday,
            activeColor: fromArgb32(habit.color),
            onChanged: (_) {
              habitCubit.toggleHabit(habit);
              if (!isCompletedToday && habit.shouldAddToExpense) {
                Timer(Duration(milliseconds: 300), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddEditExpensePage(
                            isFromTodoOrHabit: true,
                            noteFromTodoOrHabit: habit.name,
                          ),
                    ),
                  );
                });
              }
            },
            // onChanged: (v) => habitCubit.toggleHabit(habit),
          ),
        ],
      ),
    ),
  );
}
