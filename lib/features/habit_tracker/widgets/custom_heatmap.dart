// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../../../theme/theme_helper.dart';
import '../../../utils/colors_and_icons.dart';
import '../domain/models/habit.dart';
import '../presentation/crud_cubit/habit_crud_cubit.dart';
import '../utils/habit_util.dart';

class CustomHeatmap extends StatelessWidget {
  final DateTime startDate;
  final Habit habit;
  const CustomHeatmap({
    super.key,
    required this.startDate,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final datasets = prepHeatMapDataset(habit);
    return HeatMapCalendar(
      datasets: datasets,
      colorMode: ColorMode.opacity,
      showColorTip: false,
      defaultColor:
          ThemeHelper.isDark(context)
              ? Colors.grey.shade900
              : Colors.grey.shade100,
      onClick: (date) {
        if (date.isBefore(DateTime.now())) {
          context.read<HabitCrudCubit>().toggleHabit(
            habit,
            selectedDay: date,
            shouldLoadAllHabits: false,
          );
        }
      },
      monthFontSize: 16,
      initDate: startDate,
      textColor: ThemeHelper.isDark(context) ? Colors.white70 : Colors.black,
      colorsets: {1: fromArgb32(habit.color)},
    );
  }
}
