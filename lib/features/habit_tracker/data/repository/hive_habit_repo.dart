import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/domain/repository/habit_repo.dart';
import 'package:dailycore/hive_boxes/boxes.dart';
import 'package:hive_ce/hive.dart';

import '../models/hive_habit.dart';

class HiveHabitRepo implements HabitRepo {
  final box = Hive.box<HabitHive>(habitBox);

  @override
  Future<List<Habit>> getHabits() async {
    final habitList = box.values;
    return habitList.map((habit) => habit.toDomain()).toList();
  }

  @override
  Future<Habit> getSingleHabit(int id) async {
    final habit = box.values.firstWhere(
      (habitFromBox) => habitFromBox.id == id,
    );
    return habit.toDomain();
  }

  @override
  Future addHabit(Habit newHabit) async {
    final habitHive = HabitHive.fromDomain(newHabit);
    return box.add(habitHive);
  }

  @override
  Future deleteHabit(Habit habit) async {
    HabitHive soonToBeDeletedHabit = box.values.firstWhere(
      (habitFromBox) => habitFromBox.id == habit.id,
    );

    await soonToBeDeletedHabit.delete();
  }

  @override
  Future toggleHabit(Habit habit, {DateTime? selectedDay}) async {
    HabitHive togglingHabit = box.values.firstWhere(
      (habitFromBox) => habitFromBox.id == habit.id,
    );
    selectedDay = selectedDay ?? DateTime.now();
    if (!togglingHabit.comletedDays!.contains(
      DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
    )) {
      // add the current date if it's not already in the list
      togglingHabit.comletedDays!.add(
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
      );
    } else {
      // remove the current date if the habit is marked as not completed
      togglingHabit.comletedDays!.removeWhere(
        (date) =>
            date.year == selectedDay!.year &&
            date.month == selectedDay.month &&
            date.day == selectedDay.day,
      );
    }
    // print('DATES: ${togglingHabit.comletedDays}');
    togglingHabit.save();
  }

  @override
  Future updateHabit(Habit habit) async {
    HabitHive updatingHabit = box.values.firstWhere(
      (habitFromBox) => habitFromBox.id == habit.id,
    );

    updatingHabit.name = habit.name;
    updatingHabit.repeatType = habit.repeatType;
    updatingHabit.description = habit.description;
    updatingHabit.daysofWeek = habit.daysofWeek;
    updatingHabit.datesofMonth = habit.datesofMonth;
    updatingHabit.color = habit.color;
    updatingHabit.icon = habit.icon;
    updatingHabit.shouldAddToExpense = habit.shouldAddToExpense;
    updatingHabit.save();
  }
}
