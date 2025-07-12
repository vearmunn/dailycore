// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/expense_tracker/domain/repository/expense_repo.dart';

import '../../../domain/models/expense.dart';
import '../../../utils/expense_util.dart';

part 'bar_graph_state.dart';

class BarGraphCubit extends Cubit<BarGraphState> {
  final ExpenseRepo expenseRepo;
  BarGraphCubit(this.expenseRepo) : super(BarGraphLoading()) {
    // calculateMonthlyTotals();
  }

  // calculate total expenses for each month
  void calculateMonthlyTotals() async {
    try {
      final allExpenses = await expenseRepo.getAllExpenses();

      // create a map to keep track of total expenses per month,year
      Map<String, double> monthlyTotals = {};

      // iterate over all expenses
      for (var expense in allExpenses) {
        // extract year and month from the date of the expense
        String yearMonth = '${expense.date.year}-${expense.date.month}';

        // if the year-month is not yet in the map, initialize to 0
        if (!monthlyTotals.containsKey(yearMonth)) {
          monthlyTotals[yearMonth] = 0;
        }

        // add the expense amount to the total for the month
        monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
      }

      int startMonth = getStartMonth(allExpenses);
      int startYear = getStartYear(allExpenses);
      int endMonth = getEndMonth(allExpenses);
      int endYear = getEndYear(allExpenses);
      List<double> monthlySummary = getMonthlySummary(
        startMonth: startMonth,
        startYear: startYear,
        endMonth: endMonth,
        endYear: endYear,
        monthlyTotals: monthlyTotals,
      );
      // print('MONTHLY TOTALS: $monthlyTotals');
      emit(
        BarGraphLoaded(
          monthlyTotals: monthlyTotals,
          startMonth: startMonth,
          monthlySummary: monthlySummary,
        ),
      );
    } catch (e) {
      emit(BarGraphError(e.toString()));
    }
  }

  List<double> getMonthlySummary({
    required int startMonth,
    required int startYear,
    required int endMonth,
    required int endYear,
    required Map<String, double> monthlyTotals,
  }) {
    // calculate the number of months since the first month
    int monthCount = calculateMonthCount(
      startYear,
      startMonth,
      endYear,
      endMonth,
    );

    List<double> monthlySummary = List.generate(monthCount, (index) {
      // calculate year-month considering startMonth & index
      int year = startYear + (startMonth + index - 1) ~/ 12;
      int month = (startMonth + index - 1) % 12 + 1;

      // create the key in the format 'year-month'
      String yearMonthKey = '$year-$month';

      // return the total for year-mongth or 0.0 if non-existent
      return monthlyTotals[yearMonthKey] ?? 0;
    });

    // print('MONTHLY SUMMARY: $monthlySummary');
    // print('START MONTH: $startMonth');

    return monthlySummary;
  }

  int getStartMonth(List<Expense> allExpenses) {
    if (allExpenses.isEmpty) {
      return DateTime.now()
          .month; // default to current month if no expenses are recorded
    }

    // sort expenses by date to find the earliest
    allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return allExpenses.first.date.month;
  }

  int getStartYear(List<Expense> allExpenses) {
    if (allExpenses.isEmpty) {
      return DateTime.now()
          .year; // default to current year if no expenses are recorded
    }

    // sort expenses by date to find the earliest
    allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return allExpenses.first.date.year;
  }

  int getEndMonth(List<Expense> allExpenses) {
    if (allExpenses.isEmpty) {
      return DateTime.now()
          .month; // default to current month if no expenses are recorded
    }

    // sort expenses by date to find the earliest
    allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return allExpenses.last.date.month;
  }

  int getEndYear(List<Expense> allExpenses) {
    if (allExpenses.isEmpty) {
      return DateTime.now()
          .year; // default to current year if no expenses are recorded
    }

    // sort expenses by date to find the earliest
    allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return allExpenses.last.date.year;
  }
}
