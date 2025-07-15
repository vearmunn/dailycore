import 'package:hive_ce/hive.dart';

import '../../domain/models/goal.dart';

class GoalHive extends HiveObject {
  late int id;
  late String title;
  late String? description;
  late String imagePath;
  late double targetAmount;
  late double currentAmount;
  late DateTime? deadline;
  late List<Map<String, dynamic>>? depositHistoryList;

  Goal toDomain() {
    return Goal(
      id: id,
      title: title,
      description: description,
      imagePath: imagePath,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      deadline: deadline,
      depositHistoryList:
          depositHistoryList == null
              ? []
              : depositHistoryList!
                  .map((history) => DepositHistory.fromMap(history))
                  .toList(),
    );
  }

  static GoalHive fromDomain(Goal goal) {
    return GoalHive()
      ..id = goal.id
      ..title = goal.title
      ..description = goal.description
      ..imagePath = goal.imagePath
      ..targetAmount = goal.targetAmount
      ..currentAmount = goal.currentAmount
      ..deadline = goal.deadline
      ..depositHistoryList =
          goal.depositHistoryList == null
              ? []
              : goal.depositHistoryList!
                  .map((history) => history.toMap())
                  .toList();
  }
}
