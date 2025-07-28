// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
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

  late FlutterLocalization _flutterLocalization;
  @override
  void initState() {
    _flutterLocalization = FlutterLocalization.instance;

    super.initState();
  }

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
      locale: _flutterLocalization.currentLocale!.languageCode,

      eventLoader: (day) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        List<DateTime> todoDates = [];
        for (var date in widget.todoDates) {
          if (date != null) {
            todoDates.add(date);
          }
        }
        todoDates =
            todoDates.map((date) {
              return DateTime(date.year, date.month, date.day);
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
                style: TextStyle(color: Colors.black),
              ),
            ),
        selectedBuilder:
            (context, day, focusedDay) => Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: dailyCoreBlue,
                shape: BoxShape.circle,
              ),
              child: Text('${day.day}', style: TextStyle(color: Colors.white)),
            ),
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color:
                    day.day == DateTime.now().day
                        ? Colors.white
                        : dailyCoreBlue,
                shape: BoxShape.circle,
              ),
            );
          }
          return null;
        },
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
