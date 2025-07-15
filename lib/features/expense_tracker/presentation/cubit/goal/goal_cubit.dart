// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/hive_goal_repo.dart';
import '../../../domain/models/goal.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  final HiveGoalRepo hiveGoalRepo;
  GoalCubit(this.hiveGoalRepo) : super(GoalInitial()) {
    loadGoals();
  }

  Future loadGoals() async {
    try {
      emit(GoalLoading());
      final goalList = await hiveGoalRepo.getAllGoals();
      emit(GoalsLoaded(goalList));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future loadSingleGoal(int id) async {
    try {
      emit(GoalLoading());
      final goal = await hiveGoalRepo.getSingleGoal(id);
      emit(SingleGoalLoaded(goal));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future addNewGoal({
    required String title,
    String? description,
    required double targetAmount,
    required String imagePath,
    DateTime? deadline,
  }) async {
    try {
      emit(GoalLoading());
      Goal newGoal = Goal(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        imagePath: imagePath,
        targetAmount: targetAmount,
        currentAmount: 0,
        deadline: deadline,
        description: description,
        depositHistoryList: [],
      );
      await hiveGoalRepo.addGoal(newGoal);
      await loadGoals();
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future addAmount({
    required int id,
    required double amount,
    String? note,
  }) async {
    try {
      emit(GoalLoading());
      await hiveGoalRepo.addAmount(id, amount, note);
      await loadSingleGoal(id);
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future updateGoal(Goal goal) async {
    try {
      emit(GoalLoading());
      await hiveGoalRepo.updateGoal(goal);
      await loadSingleGoal(goal.id);
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future deleteGoal(int id) async {
    try {
      emit(GoalLoading());
      await hiveGoalRepo.deleteGoal(id);
      await loadGoals();
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
