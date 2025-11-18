// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/colors_and_icons.dart';

// import 'package:dailycore/features/todo/presentation/cubit/upcoming_cubit/upcoming_cubit.dart';

class HabitTableCalendar extends StatefulWidget {
  final Map<DateTime, double> dailyProgress;
  const HabitTableCalendar({super.key, required this.dailyProgress});

  @override
  State<HabitTableCalendar> createState() => _HabitTableCalendarState();
}

class _HabitTableCalendarState extends State<HabitTableCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  late FlutterLocalization _flutterLocalization;
  @override
  void initState() {
    _flutterLocalization = FlutterLocalization.instance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<UpcomingDateCubit>().setUpcomingDate(_selectedDay!);
    return Container(
      color: ThemeHelper.containerColor(context),
      padding: EdgeInsets.only(bottom: 20),
      child: TableCalendar(
        locale: _flutterLocalization.currentLocale!.languageCode,
        firstDay: DateTime(2025, 1, 1),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        formatAnimationCurve: Curves.fastOutSlowIn,
        formatAnimationDuration: Duration(milliseconds: 300),
        calendarFormat: CalendarFormat.week,
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          formatButtonVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final progress =
                widget.dailyProgress[DateTime(day.year, day.month, day.day)] ??
                0;
            return _buildPercentBorder(progress: progress, day: day.day);
          },
          todayBuilder: (context, day, focusedDay) {
            final progress =
                widget.dailyProgress[DateTime(day.year, day.month, day.day)] ??
                0;
            return _buildPercentBorder(
              progress: progress,
              day: day.day,
              isSelected: false,
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            final progress =
                widget.dailyProgress[DateTime(day.year, day.month, day.day)] ??
                0;
            return _buildPercentBorder(
              progress: progress,
              day: day.day,
              isSelected: false,
            );
          },
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }

  Widget _buildPercentBorder({
    required double progress,
    required int day,
    bool isSelected = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isSelected ? dailyCorePink.withAlpha(50) : Colors.transparent,
      ),
      child: CircularPercentIndicator(
        radius: 20,
        lineWidth: 4,
        animation: true,
        animationDuration: 600,
        curve: Curves.fastEaseInToSlowEaseOut,
        animateFromLastPercent: true,
        percent: progress > 1 ? 1 : progress,
        progressColor: dailyCorePink,
        backgroundColor:
            ThemeHelper.isDark(context)
                ? Colors.grey.shade800
                : Colors.grey.shade300,
        center: Text(
          day.toString(),
          style: TextStyle(
            fontSize: isSelected ? 14 : 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? dailyCorePink
                    : ThemeHelper.defaultTextColor(context),
          ),
        ),
      ),
    );
  }
}
