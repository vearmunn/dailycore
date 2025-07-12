import 'package:dailycore/features/expense_tracker/data/models/hive_expense.dart';
import 'package:dailycore/features/expense_tracker/data/models/hive_expense_category.dart';
import 'package:dailycore/features/habit_tracker/data/models/hive_app_settings.dart';
import 'package:dailycore/features/habit_tracker/data/models/hive_habit.dart';
import 'package:dailycore/features/todo/data/models/hive_todo.dart';
import 'package:hive_ce/hive.dart';

import '../features/todo/data/models/hive_todo_category.dart';

@GenerateAdapters([
  AdapterSpec<TodoHive>(),
  AdapterSpec<TodoCategoryHive>(),
  AdapterSpec<AppSettingsHive>(),
  AdapterSpec<HabitHive>(),
  AdapterSpec<ExpenseHive>(),
  AdapterSpec<ExpenseCategoryHive>(),
])
part 'hive_adapters.g.dart';
