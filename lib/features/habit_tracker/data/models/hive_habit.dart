import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:hive_ce/hive.dart';

class HabitHive extends HiveObject {
  late int id;
  late String name;
  late String description;
  late String repeatType;
  late List<int> daysofWeek;
  late List<int> datesofMonth;
  late List<DateTime>? comletedDays;
  late int color;
  late bool shouldAddToExpense;
  late String iconName;

  Habit toDomain() {
    return Habit(
      id: id,
      name: name,
      repeatType: repeatType,
      description: description,
      datesofMonth: datesofMonth,
      daysofWeek: daysofWeek,
      completedDays: comletedDays,
      color: color,
      shouldAddToExpense: shouldAddToExpense,
      iconName: iconName,
    );
  }

  static HabitHive fromDomain(Habit habit) {
    return HabitHive()
      ..id = habit.id
      ..name = habit.name
      ..description = habit.description
      ..repeatType = habit.repeatType
      ..comletedDays = habit.completedDays
      ..daysofWeek = habit.daysofWeek
      ..datesofMonth = habit.datesofMonth
      ..color = habit.color
      ..shouldAddToExpense = habit.shouldAddToExpense
      ..iconName = habit.iconName;
  }
}
