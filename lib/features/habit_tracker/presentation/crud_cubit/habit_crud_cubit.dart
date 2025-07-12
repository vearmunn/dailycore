// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/domain/repository/habit_repo.dart';

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
    required IconData icon,
  }) async {
    try {
      emit(HabitCrudLoading());
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        description: description,
        datesofMonth: selectedDates,
        daysofWeek: selectedDays,
        repeatType: repeatType,
        color: color.toARGB32(),
        icon: {'code_point': icon.codePoint, 'font_family': icon.fontFamily},
        completedDays: [],
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
}
