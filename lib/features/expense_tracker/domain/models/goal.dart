class Goal {
  final int id;
  final String title;
  final String? description;
  final String imagePath;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final List<DepositHistory>? depositHistoryList;

  Goal({
    required this.id,
    required this.title,
    this.description,
    required this.imagePath,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    this.depositHistoryList,
  });
}

class DepositHistory {
  final int id;
  final double amount;
  final DateTime dateTime;
  final String? note;

  DepositHistory({
    required this.id,
    required this.amount,
    required this.dateTime,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'amount': amount, 'dateTime': dateTime, 'note': note};
  }

  static DepositHistory fromMap(Map<String, dynamic> history) {
    return DepositHistory(
      id: history['id'],
      amount: history['amount'],
      dateTime: history['dateTime'],
      note: history['note'],
    );
  }
}
