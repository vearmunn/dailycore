import 'package:hive_ce/hive.dart';

import '../features/expense_tracker/data/models/hive_expense.dart';
import '../features/expense_tracker/data/models/hive_expense_category.dart';
import '../features/expense_tracker/data/models/hive_goal.dart';
import '../features/habit_tracker/data/models/hive_habit.dart';
import '../features/habit_tracker/data/models/hive_routine.dart';
import '../features/todo/data/models/hive_todo.dart';
import '../features/todo/data/models/hive_todo_category.dart';

@GenerateAdapters([
  AdapterSpec<TodoHive>(),
  AdapterSpec<TodoCategoryHive>(),
  AdapterSpec<HabitHive>(),
  AdapterSpec<RoutineHive>(),
  AdapterSpec<ExpenseHive>(),
  AdapterSpec<ExpenseCategoryHive>(),
  AdapterSpec<GoalHive>(),
])
part 'hive_adapters.g.dart';
