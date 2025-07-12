import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';

abstract class HabitRepo {
  Future<List<Habit>> getHabits();

  Future<Habit> getSingleHabit(int id);

  Future addHabit(Habit newHabit);

  Future updateHabit(Habit habit);

  Future toggleHabit(Habit habit, {DateTime? selectedDay});

  Future deleteHabit(Habit habit);
}
