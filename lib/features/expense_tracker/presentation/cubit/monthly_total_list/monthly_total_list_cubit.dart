// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';

import '../../../data/repository/hive_expense_repo.dart';
import '../../../domain/models/monthly_total.dart';

// STATE------------------------------------------------------------------------
class MonthlyTotalState {}

class TotalLoading extends MonthlyTotalState {}

class TotalError extends MonthlyTotalState {
  final String errMessage;

  TotalError(this.errMessage);
}

class TotalLoaded extends MonthlyTotalState {
  final List<MonthlyTotal> totalList;
  final List<int> yearsAvailable;
  final int selectedYear;

  TotalLoaded(this.totalList, this.yearsAvailable, this.selectedYear);
}

class MonthlyTotalListCubit extends Cubit<MonthlyTotalState> {
  final HiveExpenseRepo expenseRepo;
  MonthlyTotalListCubit(this.expenseRepo) : super(TotalLoading()) {
    loadTotals();
  }

  void loadTotals({int? selectedYear}) async {
    try {
      emit(TotalLoading());
      final expenseList = await expenseRepo.getAllExpenses();
      List<MonthlyTotal> totalList = [];
      List<String> monthYearList = [];
      List<int> yearsAvailable = [0];

      for (var expense in expenseList) {
        int index = monthYearList.indexWhere(
          (item) => item == '${expense.date.month}-${expense.date.year}',
        );
        int indexUniqueYear = monthYearList.indexWhere((item) {
          int year = int.parse(item.split('-')[1]);
          return year == expense.date.year;
        });
        if (indexUniqueYear == -1) {
          yearsAvailable.add(expense.date.year);
        }
        if (index == -1) {
          monthYearList.add('${expense.date.month}-${expense.date.year}');
        }
      }

      for (var monthYear in monthYearList) {
        int month = int.parse(monthYear.split('-')[0]);
        int year = int.parse(monthYear.split('-')[1]);
        if (selectedYear == null) {
          totalList.add(getMonthlyTotal(expenseList, year, month));
        } else if (selectedYear == year) {
          totalList.add(getMonthlyTotal(expenseList, selectedYear, month));
        }
      }
      // print(yearsAvailable);

      emit(TotalLoaded(totalList, yearsAvailable, selectedYear ?? 0));
    } catch (e) {
      emit(TotalError(e.toString()));
    }
  }
}
