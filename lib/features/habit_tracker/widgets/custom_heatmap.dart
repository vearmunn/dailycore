// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/features/habit_tracker/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../domain/models/habit.dart';

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
      // startDate: DateTime(2025, 5, 1),
      // endDate: DateTime(2025, 8, 1),
      // datasets: {
      //   DateTime(2025, 6, 15): 5,
      //   DateTime(2025, 6, 16): 7,
      //   DateTime(2025, 6, 17): 3,
      //   DateTime(2025, 6, 18): 10,
      //   DateTime(2025, 7, 1): 10,
      // },
      datasets: datasets,
      colorMode: ColorMode.opacity,
      showColorTip: false,
      defaultColor: Colors.grey.shade100,
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
      textColor: Colors.black,
      colorsets: {
        1: fromArgb32(habit.color),
        // 2: Colors.orange.shade300,
        // 3: Colors.red.shade400,
        // 4: Colors.pink.shade500,
        // 5: Colors.black,
      },
    );
  }
}
