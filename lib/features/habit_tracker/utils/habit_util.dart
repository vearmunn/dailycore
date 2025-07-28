import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../localization/locales.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

Map<DateTime, int> prepHeatMapDataset(Habit habit) {
  Map<DateTime, int> dataset = {};
  for (var date in habit.completedDays!) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // if the date already exists in the dataset, increment its count
    if (dataset.containsKey(normalizedDate)) {
      dataset[normalizedDate] = dataset[normalizedDate]! + 1;
    } else {
      // else initialize it with a count of 1
      dataset[normalizedDate] = 1;
    }
  }
  // print(dataset);
  return dataset;
}

Map<DateTime, double> prepCalendarDataset(List<Habit> habits) {
  Map<DateTime, double> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays!) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      int totalHabitsofEachDay =
          habits
              .where((e) {
                if (e.repeatType == 'weekly') {
                  return e.daysofWeek.contains(date.weekday);
                }
                if (e.repeatType == 'monthly') {
                  return e.datesofMonth.contains(date.day);
                }
                return e.repeatType == 'daily';
              })
              .toList()
              .length;
      // if the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] =
            dataset[normalizedDate]! + 1 / totalHabitsofEachDay;
      } else {
        // else initialize it with a count of 1
        dataset[normalizedDate] = 1 / totalHabitsofEachDay;
      }
    }
  }
  // print(dataset);
  return dataset;
}

List<Habit> habitsDueToday(
  List<Habit> habits, {
  bool loadOnlyUndoneHabits = false,
}) {
  final today = DateTime.now();
  List<Habit> todaysHabits = [];
  for (var habit in habits) {
    if (habit.repeatType == 'daily' ||
        habit.repeatType == 'weekly' &&
            habit.daysofWeek.contains(today.weekday) ||
        habit.repeatType == 'monthly' &&
            habit.datesofMonth.contains(today.day)) {
      todaysHabits.add(habit);
    }
  }
  if (loadOnlyUndoneHabits) {
    todaysHabits.removeWhere(
      (habit) => isHabitCompletedToday(habit.completedDays ?? []),
    );
  }
  return todaysHabits;
}

List<int> getDailyStreaks(List<DateTime>? dates) {
  if (dates!.isEmpty) return [0, 0];

  dates.sort();
  int bestStreak = 1;
  int currentStreak = 1;

  for (var i = 1; i < dates.length; i++) {
    final diff = dates[i].difference(dates[i - 1]).inDays;

    if (diff == 1) {
      currentStreak++;
    } else if (diff > 1) {
      currentStreak = 1;
    }

    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }
  }
  return [currentStreak, bestStreak];
}

List<int> getWeeklyStreaks({
  required List<DateTime>? dates,
  required List<int> selectedDays, // [2, 4, 7]
}) {
  if (dates!.isEmpty) return [0, 0];
  final Map<DateTime, Set<int>> weekToDaysDone = {};

  for (final date in dates) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final mondayKey = DateTime(monday.year, monday.month, monday.day);

    weekToDaysDone.putIfAbsent(mondayKey, () => {});
    if (selectedDays.contains(date.weekday)) {
      weekToDaysDone[mondayKey]!.add(date.weekday);
    }
  }

  final sortedWeeks = weekToDaysDone.keys.toList()..sort();

  int currentStreak = 0;
  int bestStreak = 0;
  DateTime? previousWeek;

  for (final week in sortedWeeks) {
    final doneDays = weekToDaysDone[week]!;

    // Check if we skipped a week
    if (previousWeek != null) {
      final diff = week.difference(previousWeek).inDays;
      if (diff > 7) {
        currentStreak = 0; // skipped a week = streak broken
      }
    }

    if (doneDays.toSet().containsAll(selectedDays)) {
      currentStreak++;
      if (currentStreak > bestStreak) bestStreak = currentStreak;
    } else {
      currentStreak = 0;
    }

    previousWeek = week;
  }

  print('Best: $bestStreak');
  return [currentStreak, bestStreak];
}

List<int> getMonthlyStreak({
  required List<DateTime>? dates,
  required List<int> selectedDates, // e.g. [2, 4, 7]
}) {
  if (dates!.isEmpty) return [0, 0];

  // Normalize completedDates: just year, month, day
  final Map<String, Set<int>> monthToCompletedDates = {};

  for (final date in dates) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';

    monthToCompletedDates.putIfAbsent(key, () => {});
    if (selectedDates.contains(date.day)) {
      monthToCompletedDates[key]!.add(date.day);
    }
  }

  final sortedMonths = monthToCompletedDates.keys.toList()..sort();

  int currentStreak = 0;
  int bestStreak = 0;
  String? prevMonthKey;

  for (final month in sortedMonths) {
    final completed = monthToCompletedDates[month]!;

    // Detect skipped month
    if (prevMonthKey != null) {
      final prevParts = prevMonthKey.split('-').map(int.parse).toList();
      final currParts = month.split('-').map(int.parse).toList();
      final prevDate = DateTime(prevParts[0], prevParts[1]);
      final currDate = DateTime(currParts[0], currParts[1]);

      final diff =
          (currDate.year - prevDate.year) * 12 +
          (currDate.month - prevDate.month);
      if (diff > 1) currentStreak = 0;
    }

    if (completed.containsAll(selectedDates)) {
      currentStreak++;
      if (currentStreak > bestStreak) bestStreak = currentStreak;
    } else {
      currentStreak = 0;
    }

    prevMonthKey = month;
  }

  print('Best Streak: $bestStreak');

  return [currentStreak, bestStreak];
}

List<String> getStreak(
  context,
  List<DateTime>? dates, {
  required String repeatType,
  required List<int> selectedDaysOrDates,
  required String locale,
}) {
  if (selectedDaysOrDates.isEmpty) {
    return [
      '${getDailyStreaks(dates)[0]} ${getRepeatFrequency(getDailyStreaks(dates)[0], repeatType, locale, context)}',
      '${getDailyStreaks(dates)[1]} ${getRepeatFrequency(getDailyStreaks(dates)[1], repeatType, locale, context)}',
    ];
  } else {
    if (repeatType == 'weekly') {
      return [
        '${getWeeklyStreaks(dates: dates, selectedDays: selectedDaysOrDates)[0]} ${getRepeatFrequency(getWeeklyStreaks(dates: dates, selectedDays: selectedDaysOrDates)[0], repeatType, locale, context)}',
        '${getWeeklyStreaks(dates: dates, selectedDays: selectedDaysOrDates)[1]} ${getRepeatFrequency(getWeeklyStreaks(dates: dates, selectedDays: selectedDaysOrDates)[1], repeatType, locale, context)}',
      ];
    } else {
      return [
        '${getMonthlyStreak(dates: dates, selectedDates: selectedDaysOrDates)[0]} ${getRepeatFrequency(getMonthlyStreak(dates: dates, selectedDates: selectedDaysOrDates)[0], repeatType, locale, context)}',
        '${getMonthlyStreak(dates: dates, selectedDates: selectedDaysOrDates)[1]} ${getRepeatFrequency(getMonthlyStreak(dates: dates, selectedDates: selectedDaysOrDates)[1], repeatType, locale, context)}',
      ];
    }
  }
}

String getRepeatFrequency(int num, String repeatType, String locale, context) {
  if (repeatType == 'daily') {
    if (num != 1 && locale == 'en') {
      return 'days';
    } else {
      return AppLocale.day.getString(context);
    }
  }
  if (repeatType == 'weekly') {
    if (num != 1 && locale == 'en') {
      return 'weeks';
    } else {
      return AppLocale.week.getString(context);
    }
  }
  if (repeatType == 'monthly') {
    if (num != 1 && locale == 'en') {
      return 'months';
    } else {
      return AppLocale.month.getString(context);
    }
  }
  return '';
}

String getRepeatDuration(Habit habit) {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  var text = '';
  if (habit.repeatType == 'daily') {
    text = 'Everyday';
  } else if (habit.repeatType == 'weekly') {
    habit.daysofWeek.sort();
    text = '${habit.daysofWeek.map((day) => days[day - 1])}'
        .replaceAll('(', '')
        .replaceAll(')', '');
  } else if (habit.repeatType == 'monthly') {
    habit.datesofMonth.sort();
    text = '${habit.datesofMonth}'.replaceAll('[', '').replaceAll(']', '');
  }

  return text;
}
