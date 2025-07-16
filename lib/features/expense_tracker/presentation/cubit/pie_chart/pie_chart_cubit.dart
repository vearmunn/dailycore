// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';

import '../../../domain/models/expense.dart';
import '../../../domain/models/piechart_category_data.dart';
import '../../../domain/repository/expense_repo.dart';

// STATE------------------------------------------------------------------------
class DefaultChartState {}

class ChartLoading extends DefaultChartState {}

class ChartError extends DefaultChartState {
  final String errMessage;

  ChartError(this.errMessage);
}

class PieChartState extends DefaultChartState {
  final String selectedType;
  final List<PieChartSectionData> sections;
  final double total;
  final List<CategoryData> categoryDatalist;
  final List<CategoryData> topCategories;
  final int month;
  final int year;
  PieChartState(
    this.selectedType,
    this.sections,
    this.total,
    this.categoryDatalist,
    this.topCategories,
    this.month,
    this.year,
  );
}

// CUBIT------------------------------------------------------------------------
class PieChartCubit extends Cubit<DefaultChartState> {
  final ExpenseRepo expenseRepo;
  PieChartCubit(this.expenseRepo) : super(ChartLoading()) {
    updateData(month: DateTime.now().month, year: DateTime.now().year);
  }

  void updateData({
    String type = 'Expense',
    required int month,
    required int year,
  }) async {
    try {
      emit(ChartLoading());
      var expenseList = await expenseRepo.getAllExpenses();
      List<PieChartSectionData> sections = [];
      List<CategoryData> categoryListData = [];
      double total = 0;

      // Determine which type of fund and when should be calculated
      expenseList = filterExpenseList(expenseList, type, month, year);

      // Category doesnt exist? Add to the list, if it exists, add the amount
      categoryListData = calculateCategories(expenseList, categoryListData);

      // Calculate total
      for (var category in categoryListData) {
        total += category.amount;
      }

      // Sort categories
      final topCategories = getTopCategories(categoryListData);

      // Create section data for every category
      for (var category in topCategories) {
        sections.add(
          PieChartSectionData(
            value: category.amount,
            color: category.color,
            title: category.categoryName,
            radius: 30,
            showTitle: false,
            titleStyle: TextStyle(color: Colors.black),
          ),
        );
      }
      emit(
        PieChartState(
          type,
          sections,
          total,
          categoryListData,
          topCategories,
          month,
          year,
        ),
      );
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }
}

List<CategoryData> calculateCategories(
  List<Expense> expenseList,
  List<CategoryData> categoryListData,
) {
  for (var expense in expenseList) {
    int index = categoryListData.indexWhere(
      (category) => category.id == expense.category.id,
    );
    if (index != -1) {
      categoryListData[index].amount += expense.amount;
    } else {
      categoryListData.add(
        CategoryData(
          id: expense.category.id,
          categoryName: expense.category.name,
          amount: expense.amount,
          color: expense.category.color,
          icon: expense.category.icon,
        ),
      );
    }
  }
  return categoryListData;
}

List<Expense> filterExpenseList(
  List<Expense> expenseList,
  String type,
  int month,
  int year,
) {
  if (type == 'Expense') {
    return expenseList
        .where(
          (expense) =>
              isExpenseType(expense.type) &&
              expense.date.month == month &&
              expense.date.year == year,
        )
        .toList();
  } else {
    return expenseList
        .where(
          (expense) =>
              isIncomeType(expense.type) &&
              expense.date.month == month &&
              expense.date.year == year,
        )
        .toList();
  }
}

List<CategoryData> getTopCategories(List<CategoryData> categories) {
  List<CategoryData> topCategories = [];
  CategoryData others = CategoryData(
    id: 000,
    categoryName: 'Other',
    amount: 0,
    color: Colors.grey,
    icon: Icons.cancel_presentation_sharp,
  );
  categories.sort((a, b) => b.amount.compareTo(a.amount));
  for (int i = 0; i < categories.length; i++) {
    if (i < 4 || i == 4 && categories.length == 5) {
      topCategories.add(categories[i]);
    } else {
      others.amount += categories[i].amount;
    }
  }

  topCategories.add(others);
  return topCategories;
}
