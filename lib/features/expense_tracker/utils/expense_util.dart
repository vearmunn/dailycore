import 'package:intl/intl.dart';
import '../domain/models/expense.dart';
import '../domain/models/monthly_total.dart';

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
