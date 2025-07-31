import 'package:hive_ce/hive.dart';

import '../../../../consts/boxes.dart';
import '../../domain/models/goal.dart';
import '../../domain/repository/goal_repo.dart';
import '../models/hive_goal.dart';

class HiveGoalRepo implements GoalRepo {
  final box = Hive.box<GoalHive>(goalBox);
  @override
  Future<List<Goal>> getAllGoals() async {
    final goalList = box.values;
    return goalList.map((goal) => goal.toDomain()).toList();
  }

  @override
  Future<Goal> getSingleGoal(int id) async {
    GoalHive goal = box.values.firstWhere((goal) => goal.id == id);
    return goal.toDomain();
  }

  @override
  Future addGoal(Goal newGoal) async {
    final goalHive = GoalHive.fromDomain(newGoal);
    box.add(goalHive);
  }

  @override
  Future addAmount(int id, double amount, String? note) async {
    GoalHive goal = box.values.firstWhere((goal) => goal.id == id);
    goal.currentAmount += amount;

    DepositHistory newDepositHistory = DepositHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      amount: amount,
      dateTime: DateTime.now(),
      note: note,
    );
    goal.depositHistoryList!.add(newDepositHistory.toMap());
    goal.save();
  }

  @override
  Future deleteGoal(int id) async {
    GoalHive soonTobeDeletedGoal = box.values.firstWhere(
      (goalFromBox) => goalFromBox.id == id,
    );
    soonTobeDeletedGoal.delete();
  }

  @override
  Future updateGoal(Goal goal) async {
    GoalHive updatingGoal = box.values.firstWhere(
      (goalFromBox) => goalFromBox.id == goal.id,
    );
    updatingGoal.title = goal.title;
    updatingGoal.imagePath = goal.imagePath;
    updatingGoal.targetAmount = goal.targetAmount;
    updatingGoal.description = goal.description;
    updatingGoal.deadline = goal.deadline;
  }
}
