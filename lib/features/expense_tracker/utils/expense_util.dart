import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../components/color_selector/color_icon_selector_cubit.dart';
import '../../../components/color_selector/color_selector_widget.dart';
import '../../../components/color_selector/icon_color_selected_widget.dart';
import '../../../components/color_selector/icon_selector_widget.dart';
import '../../../utils/colors_and_icons.dart';
import '../../../utils/spaces.dart';
import '../domain/models/expense.dart';
import '../domain/models/expense_category.dart';
import '../domain/models/monthly_total.dart';
import '../presentation/cubit/expense_category/expense_category_cubit.dart';
import '../presentation/cubit/expense_crud/expense_crud_cubit.dart';

String formatAmountRP(double amount, {bool useSymbol = true}) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: useSymbol ? 'Rp' : '',
    decimalDigits: 0,
  );
  return format.format(amount);
}

// calculate the number of months since the first start month
int calculateMonthCount(int startYear, startMonth, endYear, endMonth) {
  int monthCount = (endYear - startYear) * 12 + endMonth - startMonth + 1;
  return monthCount;
}

String getMonthName(int month) {
  String monthName = '';
  switch (month) {
    case 1:
      monthName = 'Jan';
      break;
    case 2:
      monthName = 'Feb';
      break;
    case 3:
      monthName = 'Mar';
      break;
    case 4:
      monthName = 'Apr';
      break;
    case 5:
      monthName = 'May';
      break;
    case 6:
      monthName = 'Jun';
      break;
    case 7:
      monthName = 'Jul';
      break;
    case 8:
      monthName = 'Aug';
      break;
    case 9:
      monthName = 'Sep';
      break;
    case 10:
      monthName = 'Oct';
      break;
    case 11:
      monthName = 'Nov';
      break;
    case 12:
      monthName = 'Dec';
      break;

    default:
      monthName = '';
      break;
  }
  return monthName;
}

bool isExpenseType(String type) {
  return type == 'Expense' || type == 'expense';
}

bool isIncomeType(String type) {
  return type == 'Income' || type == 'income';
}

double getPercentage(double part, double total) {
  return (part / total) * 100;
}

MonthlyTotal getMonthlyTotal(List<Expense> expenseList, int year, int month) {
  double totalExpenses = 0;
  double totalIncome = 0;
  for (var expense in expenseList) {
    if (expense.date.year == year &&
        expense.date.month == month &&
        isExpenseType(expense.type)) {
      totalExpenses += expense.amount;
    }
    if (expense.date.year == year &&
        expense.date.month == month &&
        isIncomeType(expense.type)) {
      totalIncome += expense.amount;
    }
  }
  return MonthlyTotal(
    month: month,
    year: year,
    expenses: totalExpenses,
    income: totalIncome,
    balance: totalIncome - totalExpenses,
  );
}

List<double> getDailyExpensesAndIncome(
  DateTime date,
  List<Expense> expenseList,
) {
  double expenses = 0;
  double income = 0;
  for (var expense in expenseList) {
    if (date.day == expense.date.day &&
        date.month == expense.date.month &&
        date.year == expense.date.year &&
        isExpenseType(expense.type)) {
      expenses += expense.amount;
    }
    if (date.day == expense.date.day &&
        date.month == expense.date.month &&
        date.year == expense.date.year &&
        isIncomeType(expense.type)) {
      income += expense.amount;
    }
  }
  return [expenses, income];
}

double getTotal(List<MonthlyTotal> data, String tracker) {
  return data.fold(0.0, (sum, r) {
    if (tracker == 'balance') {
      return sum + r.balance;
    }
    if (tracker == 'expenses') {
      return sum + r.expenses;
    }
    if (tracker == 'income') {
      return sum + r.income;
    }
    return 0;
  });
}

void showAddEditCategoryModalBottomSheet(
  BuildContext context, {
  bool isUpadting = false,
  ExpenseCategory? category,
}) {
  final nameController = TextEditingController();
  bool showIconSelections = false;
  bool showColorSelections = false;
  String selectedType;

  if (isUpadting) {
    nameController.text = category!.name;
    context.read<ColorSelectorCubit>().setColor(fromArgb32(category.color));
    context.read<IconSelectorCubit>().setIcon(
      IconData(
        category.icon['code_point'],
        fontFamily: category.icon['font_family'],
      ),
    );
    selectedType = category.type;
  } else {
    selectedType = 'Expense';
  }

  showModalBottomSheet(
    isScrollControlled: true, // Important for dynamic height
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUpadting ? 'Edit Category' : 'Add Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      verticalSpace(16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      verticalSpace(20),
                      Row(
                        children: [
                          colorOrIconSelected(true, () {
                            setModalState(() {
                              showColorSelections = !showColorSelections;
                              showIconSelections = false;
                            });
                          }),
                          horizontalSpace(12),
                          colorOrIconSelected(false, () {
                            setModalState(() {
                              showIconSelections = !showIconSelections;
                              showColorSelections = false;
                            });
                          }),
                        ],
                      ),
                      verticalSpace(16),
                      colorSelector(showColorSelections),
                      iconSelector(showIconSelections),
                      if (showColorSelections || showIconSelections)
                        verticalSpace(16),
                      Row(
                        children: [
                          horizontalSpace(12),
                          Radio(
                            activeColor: Colors.black,
                            value: 'Expense',
                            groupValue: selectedType,
                            onChanged: (v) {
                              setModalState(() {
                                selectedType = v!;
                              });
                            },
                          ),
                          Text('Expense'),
                        ],
                      ),
                      Row(
                        children: [
                          horizontalSpace(12),
                          Radio(
                            activeColor: Colors.black,
                            value: 'Income',
                            groupValue: selectedType,
                            onChanged: (v) {
                              setModalState(() {
                                selectedType = v!;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      verticalSpace(16),
                      BlocBuilder<ColorSelectorCubit, Color>(
                        builder: (context, selectedColor) {
                          return BlocBuilder<IconSelectorCubit, IconData>(
                            builder: (context, selectedIcon) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (isUpadting) {
                                      context
                                          .read<ExpenseCategoryCubit>()
                                          .updateExpenseCategory(
                                            ExpenseCategory(
                                              id: category!.id,
                                              name: nameController.text,
                                              color: selectedColor.toARGB32(),
                                              icon: {
                                                'code_point':
                                                    selectedIcon.codePoint,
                                                'font_family':
                                                    selectedIcon.fontFamily,
                                              },
                                              type: selectedType,
                                            ),
                                          );
                                      context
                                          .read<ExpenseCrudCubit>()
                                          .loadExpenses(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                          );
                                    } else {
                                      context
                                          .read<ExpenseCategoryCubit>()
                                          .addExpenseCategory(
                                            categoryName: nameController.text,
                                            color: selectedColor,
                                            icon: selectedIcon,
                                            type: selectedType,
                                          );
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(isUpadting ? 'Update' : 'Add'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
  );
}
