import 'package:dailycore/features/expense_tracker/presentation/pages/search_page.dart';
import 'package:dailycore/features/expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../../../utils/colors_and_icons.dart';
import '../../utils/expense_util.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';
import 'add_edit_expense_page.dart';
import 'expense_category_page.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dailyCoreOrange,
        title: Text(
          AppLocale.financeTitle.getString(context),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchExpensePage()),
              );
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseCategoryPage()),
              );
            },
            icon: Icon(Icons.category_outlined, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
            builder: (context, state) {
              if (state is ExpenseCrudLoaded) {
                return Container(
                  height: 50,
                  color: dailyCoreOrange,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMontPicker(context, state),
                      _buildTracker(
                        AppLocale.expense.getString(context),
                        formatAmountRP(
                          state.monthlyTotal!.expenses,
                          useSymbol: false,
                        ),
                      ),
                      _buildTracker(
                        AppLocale.income.getString(context),
                        formatAmountRP(
                          state.monthlyTotal!.income,
                          useSymbol: false,
                        ),
                      ),
                      _buildTracker(
                        AppLocale.balance.getString(context),
                        formatAmountRP(
                          state.monthlyTotal!.balance,
                          useSymbol: false,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
          builder: (context, state) {
            if (state is ExpenseCrudLoading) {
              return Center(child: Text('Loading...'));
            }
            if (state is ExpenseCrudError) {
              return Center(child: Text(state.errMessage));
            }
            if (state is ExpenseCrudLoaded) {
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 20),
                children: [ExpenseList(expenseList: state.expenseList)],
              );
            }
            return SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: dailyCoreOrange,
        foregroundColor: Colors.white,
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditExpensePage()),
            ),
        child: Icon(Icons.add),
      ),
    );
  }

  GestureDetector _buildMontPicker(
    BuildContext context,
    ExpenseCrudLoaded state,
  ) {
    return GestureDetector(
      onTap: () {
        showMonthPicker(
          context,
          onSelected: (month, year) {
            context.read<ExpenseCrudCubit>().loadExpenses(year, month);
          },
          initialSelectedMonth: state.monthlyTotal!.month,
          initialSelectedYear: state.monthlyTotal!.year,
          firstYear: 2020,
          lastYear: DateTime.now().year,
          selectButtonText: 'OK',
          cancelButtonText: 'Cancel',
          highlightColor: dailyCoreOrange,
          textColor: Colors.black,
          contentBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.grey[200],
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                getMonthName(state.monthlyTotal!.month),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                state.monthlyTotal!.year.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTracker(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
