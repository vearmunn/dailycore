// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dailycore/features/todo/presentation/cubit/upcoming_cubit/upcoming_cubit.dart';

class UpcomingTableCalendar extends StatefulWidget {
  final List<DateTime?> todoDates;
  const UpcomingTableCalendar({super.key, required this.todoDates});

  @override
  State<UpcomingTableCalendar> createState() => _UpcomingTableCalendarState();
}

class _UpcomingTableCalendarState extends State<UpcomingTableCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(widget.todoDates);
    context.read<UpcomingDateCubit>().setUpcomingDate(_selectedDay!);
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime(2050),
      focusedDay: _focusedDay,
      formatAnimationCurve: Curves.fastOutSlowIn,
      formatAnimationDuration: Duration(milliseconds: 300),
      calendarFormat: _calendarFormat,
      eventLoader: (day) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        List<DateTime?> todoDates =
            widget.todoDates.map((date) {
              return DateTime(date!.year, date.month, date.day);
            }).toList();
        final hasMarker = todoDates.contains(normalizedDay);

        return hasMarker ? ['marker'] : [];
      },

      calendarBuilders: CalendarBuilders(
        todayBuilder:
            (context, day, focusedDay) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                day.day.toString(),
                style: TextStyle(color: Colors.blue),
              ),
            ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            context.read<UpcomingDateCubit>().setUpcomingDate(_selectedDay!);
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
