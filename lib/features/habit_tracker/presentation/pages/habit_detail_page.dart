import 'dart:async';

import 'package:dailycore/features/expense_tracker/presentation/pages/add_edit_expense_page.dart';
import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import 'package:dailycore/features/habit_tracker/presentation/pages/add_edit_habit_page.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/features/habit_tracker/widgets/custom_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/spaces.dart';
import '../../utils/habit_util.dart';

class HabitDetailPage extends StatelessWidget {
  const HabitDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: BlocBuilder<HabitCrudCubit, HabitCrudState>(
        builder: (context, state) {
          if (state is HabitCrudLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HabitCrudError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is SingleHabitCrudLoaded) {
            final habit = state.habit;
            bool isCompletedToday = isHabitCompletedToday(habit.completedDays!);
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                verticalSpace(30),
                _buildTopBar(context, habit),
                verticalSpace(16),
                _buildTitleCard(context, habit, isCompletedToday),
                verticalSpace(20),
                _buildDetails(habit),
                verticalSpace(16),
                ElevatedButton.icon(
                  onPressed: () async {
                    context.read<HabitCrudCubit>().toggleHabit(
                      habit,
                      shouldLoadAllHabits: false,
                    );
                    if (!isCompletedToday) {
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
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: fromArgb32(
                      habit.color,
                    ).withAlpha(isCompletedToday ? 255 : 50),
                    foregroundColor:
                        isCompletedToday ? Colors.white : Colors.black54,
                  ),
                  label: Text(
                    isCompletedToday ? 'Checked' : 'Check',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.check_circle),
                ),
                verticalSpace(20),
                CustomHeatmap(startDate: DateTime.now(), habit: habit),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Habit habit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            context.read<HabitCrudCubit>().loadHabits();
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios, color: fromArgb32(habit.color)),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        AddEditHabitPage(habit: habit, isUpadting: true),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.edit, color: fromArgb32(habit.color)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleCard(
    BuildContext context,
    Habit habit,
    bool isCompletedToday,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: fromArgb32(habit.color).withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              color: fromArgb32(habit.color),
              size: 60,
              IconData(
                habit.icon['code_point'],
                fontFamily: habit.icon['font_family'],
              ),
            ),
          ),
          verticalSpace(16),
          Text(
            habit.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          verticalSpace(4),
          habit.description.isEmpty
              ? SizedBox.shrink()
              : Text(
                habit.description,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
          verticalSpace(16),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: fromArgb32(habit.color).withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isCompletedToday ? 'Completed' : 'Not Completed',
              style: TextStyle(fontSize: 12, color: fromArgb32(habit.color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(Habit habit) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailItem(
            'Repeat Schedule',
            habit.repeatType == 'monthly'
                ? 'on ${getRepeatDuration(habit)}'
                : getRepeatDuration(habit),
          ),
          verticalSpace(10),
          Divider(),
          verticalSpace(10),
          _buildDetailItem(
            'Current Streak',
            getStreak(
              habit.completedDays,
              repeatType: habit.repeatType,
              selectedDaysOrDates:
                  habit.daysofWeek.isEmpty
                      ? habit.datesofMonth
                      : habit.daysofWeek,
            )[0],
          ),
          verticalSpace(10),
          Divider(),
          verticalSpace(10),
          _buildDetailItem(
            'Best Streak',
            getStreak(
              habit.completedDays,
              repeatType: habit.repeatType,
              selectedDaysOrDates:
                  habit.daysofWeek.isEmpty
                      ? habit.datesofMonth
                      : habit.daysofWeek,
            )[1],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
