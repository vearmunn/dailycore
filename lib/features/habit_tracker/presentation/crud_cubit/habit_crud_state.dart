part of 'habit_crud_cubit.dart';

sealed class HabitCrudState {}

final class HabitCrudLoading extends HabitCrudState {}

final class HabitCrudLoaded extends HabitCrudState {
  final List<Habit> habits;

  HabitCrudLoaded(this.habits);
}

final class SingleHabitCrudLoaded extends HabitCrudState {
  final Habit habit;

  SingleHabitCrudLoaded(this.habit);
}

final class HabitCrudError extends HabitCrudState {
  final String errMessage;

  HabitCrudError(this.errMessage);
}
