import 'package:dailycore/features/expense_tracker/data/models/hive_expense.dart';
import 'package:dailycore/features/expense_tracker/data/models/hive_expense_category.dart';
import 'package:dailycore/features/expense_tracker/domain/models/expense_category.dart';
import 'package:dailycore/hive_boxes/boxes.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/repository/expense_category_repo.dart';
import '../../utils/initial_expense_categories.dart';

class HiveExpenseCategoryRepo implements ExpenseCategoryRepo {
  final box = Hive.box<ExpenseCategoryHive>(expenseCategoryBox);
  final expensesBox = Hive.box<ExpenseHive>(expenseBox);

  @override
  Future<List<ExpenseCategory>> loadCategories() async {
    final categoryList = box.values;

    return categoryList.map((category) => category.toDomain()).toList();
  }

  @override
  Future addCategory(ExpenseCategory newCategory) async {
    final categoryHive = ExpenseCategoryHive.fromDomain(newCategory);
    return box.add(categoryHive);
  }

  @override
  Future deleteCategory(ExpenseCategory category) async {
    ExpenseCategoryHive soonToBeDeletedCategory = box.values.firstWhere(
      (categoryFromBox) => categoryFromBox.id == category.id,
    );

    final expenses = expensesBox.values.map((expense) => expense).toList();
    for (var expense in expenses) {
      if (expense.category.id == category.id) {
        await expense.delete();
      }
    }

    await soonToBeDeletedCategory.delete();
  }

  @override
  Future updateCategory(ExpenseCategory category) async {
    ExpenseCategoryHive updatingCategory = box.values.firstWhere(
      (categoryFromBox) => categoryFromBox.id == category.id,
    );

    final expenses = expensesBox.values.map((expense) => expense).toList();
    for (var expense in expenses) {
      if (expense.category.id == category.id) {
        expense.category.name = category.name;
        expense.category.iconName = category.iconName;
        expense.category.type = category.type;
        expense.category.color = category.color.toARGB32();
        await expense.save();
      }
    }

    updatingCategory.name = category.name;
    updatingCategory.color = category.color.toARGB32();
    updatingCategory.iconName = category.iconName;
    updatingCategory.type = category.type;
    updatingCategory.save();
  }

  @override
  Future initializeCategory() async {
    final uncategorized = box.values.any((category) => category.id == 1);
    if (!uncategorized) {
      for (var category in initialExpenseCategories) {
        box.add(ExpenseCategoryHive.fromDomain(category));
      }
    }
  }
}
