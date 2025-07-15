import '../models/goal.dart';

abstract class GoalRepo {
  Future<List<Goal>> getAllGoals();

  Future<Goal> getSingleGoal(int id);

  Future addGoal(Goal newGoal);

  Future addAmount(int id, double amount, String? note);

  Future updateGoal(Goal goal);

  Future deleteGoal(int id);
}
