class Habit {
  final int id;
  final String name;
  final String description;
  final String repeatType;
  final List<int> daysofWeek;
  final List<int> datesofMonth;
  final List<DateTime>? completedDays;
  final int color;
  final bool shouldAddToExpense;
  final String iconName;

  Habit({
    required this.id,
    required this.name,
    this.repeatType = 'daily',
    this.completedDays,
    this.description = '',
    this.datesofMonth = const [],
    this.daysofWeek = const [],
    this.color = 0xFF000000,
    this.shouldAddToExpense = false,
    this.iconName = 'task',
  });
}
