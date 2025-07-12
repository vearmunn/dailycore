class ExpenseCategory {
  final int id;
  final String name;
  final int color;
  final Map<String, dynamic> icon;
  final String type;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.type,
    this.color = 0xFF000000,
    this.icon = const {'code_point': '', 'font_family': ''},
  });
}
