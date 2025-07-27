// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/domain/repository/habit_repo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../utils/notification_service.dart';

part 'habit_crud_state.dart';

class HabitCrudCubit extends Cubit<HabitCrudState> {
  final HabitRepo habitRepo;
  HabitCrudCubit(this.habitRepo) : super(HabitCrudLoading()) {
    loadHabits();
  }

  Future loadHabits() async {
    try {
      emit(HabitCrudLoading());
      final habitList = await habitRepo.getHabits();
      // for (var habit in habitList) {
      //   print('HABIT: ${habit.name} - ${habit.completedDays}');
      // }
      emit(HabitCrudLoaded(habitList));
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future loadSingleHabit(int id) async {
    try {
      emit(HabitCrudLoading());
      final habit = await habitRepo.getSingleHabit(id);
      emit(SingleHabitCrudLoaded(habit));
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future addHabit({
    required String name,
    String description = '',
    required String repeatType,
    required List<int> selectedDays,
    required List<int> selectedDates,
    required Color color,
    required String iconName,
    required bool shouldAddToExpense,
    required int hourTimeReminder,
    required int minuteTimeReminder,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
    try {
      emit(HabitCrudLoading());
      var notificationIdList = await setNotification(
        repeatType: repeatType,
        habitName: name,
        hourTimeReminder: hourTimeReminder,
        minuteTimeReminder: minuteTimeReminder,
        selectedDays: selectedDays,
        selectedDates: selectedDates,
      );
      final newHabit = Habit(
        id: id,
        name: name,
        description: description,
        datesofMonth: selectedDates,
        daysofWeek: selectedDays,
        repeatType: repeatType,
        color: color.toARGB32(),
        iconName: iconName,
        shouldAddToExpense: shouldAddToExpense,
        hourTimeReminder: hourTimeReminder,
        minuteTimeReminder: minuteTimeReminder,
        completedDays: [],
        notificationIdList: notificationIdList,
      );
      await habitRepo.addHabit(newHabit);
      await loadHabits();
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future deleteHabit(Habit habit) async {
    try {
      emit(HabitCrudLoading());
      for (var notificationId in habit.notificationIdList!) {
        print(notificationId);
        NotificationService.cancelNotification(notificationId);
      }
      await habitRepo.deleteHabit(habit);
      await loadHabits();
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future toggleHabit(
    Habit habit, {
    bool shouldLoadAllHabits = true,
    DateTime? selectedDay,
  }) async {
    try {
      emit(HabitCrudLoading());
      await habitRepo.toggleHabit(habit, selectedDay: selectedDay);
      if (shouldLoadAllHabits) {
        await loadHabits();
      } else {
        await loadSingleHabit(habit.id);
      }
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future updateHabit(Habit habit, {bool shouldLoadAllHabits = true}) async {
    try {
      emit(HabitCrudLoading());
      for (var notificationId in habit.notificationIdList!) {
        await NotificationService.cancelNotification(notificationId);
      }
      var notificationIds = await setNotification(
        repeatType: habit.repeatType,
        habitName: habit.name,
        hourTimeReminder: habit.hourTimeReminder,
        minuteTimeReminder: habit.minuteTimeReminder,
        selectedDays: habit.daysofWeek,
        selectedDates: habit.datesofMonth,
      );
      print(notificationIds);
      habit.notificationIdList = notificationIds;

      await habitRepo.updateHabit(habit);

      if (shouldLoadAllHabits) {
        await loadHabits();
      } else {
        loadSingleHabit(habit.id);
      }
    } catch (e) {
      emit(HabitCrudError(e.toString()));
    }
  }

  Future<List<int>> setNotification({
    required String repeatType,
    required String habitName,
    required int hourTimeReminder,
    required int minuteTimeReminder,
    required List<int> selectedDays,
    required List<int> selectedDates,
  }) async {
    var baseId = DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
    if (repeatType == 'daily') {
      await NotificationService.scheduleNotification(
        id: baseId,
        title: 'Habit Reminder',
        body: 'You have $habitName due today!',
        scheduledTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hourTimeReminder,
          minuteTimeReminder,
        ),
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return [baseId];
    } else if (repeatType == 'weekly') {
      List<int> notificationIds = [];
      for (int i = 0; i < selectedDays.length; i++) {
        final weekday = selectedDays[i];
        final scheduledTime = nextInstanceOfWeekday(
          weekday,
          hourTimeReminder,
          minuteTimeReminder,
        );
        await NotificationService.scheduleNotification(
          id: baseId + i,
          title: 'Habit Reminder',
          body: 'You have $habitName due today!',
          scheduledTime: scheduledTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        notificationIds.add(baseId + i);
      }
      return notificationIds;
    } else if (repeatType == 'monthly') {
      List<int> notificationIds = [];
      for (int i = 0; i < selectedDates.length; i++) {
        await NotificationService.scheduleNotification(
          id: baseId + i,
          title: 'Habit Reminder',
          body: 'You have $habitName due today!',
          scheduledTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            selectedDates[i],
            hourTimeReminder,
            minuteTimeReminder,
          ),
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );
        notificationIds.add(baseId + i);
      }
      return notificationIds;
    }
    return [];
  }

  DateTime nextInstanceOfWeekday(int weekday, int hour, int minute) {
    DateTime now = DateTime.now();
    DateTime scheduled = DateTime(now.year, now.month, now.day, hour, minute);

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }

    return scheduled;
  }
}
