part of 'goal_cubit.dart';

sealed class GoalState {}

final class GoalInitial extends GoalState {}

final class GoalLoading extends GoalState {}

final class GoalError extends GoalState {
  final String errMessage;

  GoalError(this.errMessage);
}

final class GoalsLoaded extends GoalState {
  final List<Goal> goalList;

  GoalsLoaded(this.goalList);
}

final class SingleGoalLoaded extends GoalState {
  final Goal goal;

  SingleGoalLoaded(this.goal);
}
