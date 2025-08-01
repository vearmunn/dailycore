import 'package:dailycore/features/expense_tracker/presentation/cubit/expense_crud/expense_crud_cubit.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/detail_pe_month_page.dart';
import 'package:dailycore/features/expense_tracker/widgets/report_header.dart';
import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../../../utils/colors_and_icons.dart';
import '../../domain/models/monthly_total.dart';
import '../../utils/expense_util.dart';
import '../../utils/exports.dart';
import '../cubit/monthly_total_list/monthly_total_list_cubit.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int? selectedYear = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dailyCorePurple,
        title: Text(
          AppLocale.financeTitle.getString(context),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ExpenseCrudCubit>().loadExpenses(
              DateTime.now().year,
              DateTime.now().month,
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          BlocBuilder<MonthlyTotalListCubit, MonthlyTotalState>(
            builder: (context, state) {
              if (state is TotalLoaded) {
                double totalExpense = getTotal(state.totalList, 'expenses');
                double totalIncome = getTotal(state.totalList, 'income');
                double totalBalance = getTotal(state.totalList, 'balance');
                return IconButton(
                  onPressed:
                      () => showExportOptions(
                        context,
                        state.totalList.map((e) => e.toList()).toList(),
                        totalExpense,
                        totalIncome,
                        totalBalance,
                        MonthlyTotal.headers(),
                        'Finance Tracker Report',
                        false,
                      ),
                  icon: Icon(Icons.file_download_outlined, color: Colors.white),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<MonthlyTotalListCubit, MonthlyTotalState>(
        builder: (context, state) {
          if (state is TotalLoaded) {
            double totalExpense = getTotal(state.totalList, 'expenses');
            double totalIncome = getTotal(state.totalList, 'income');
            double totalBalance = getTotal(state.totalList, 'balance');
            return ListView(
              children: [
                _buildYearOption(state, context),
                ReportHeader(
                  totalExpense: totalExpense,
                  totalIncome: totalIncome,
                  totalBalance: totalBalance,
                ),
                verticalSpace(20),
                _buildDataTable(state),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildYearOption(TotalLoaded state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: state.selectedYear,
              iconEnabledColor: ThemeHelper.defaultTextColor(context),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: ThemeHelper.defaultTextColor(context),
              ),
              items: List.generate(state.yearsAvailable.length, (index) {
                final year = state.yearsAvailable[index];
                return DropdownMenuItem(
                  value: year,
                  child: Text(
                    year == 0
                        ? AppLocale.all.getString(context)
                        : year.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }),
              onChanged: (v) {
                setState(() {
                  selectedYear = v!;
                  context.read<MonthlyTotalListCubit>().loadTotals(
                    selectedYear:
                        selectedYear == 0 ? selectedYear = null : selectedYear,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(TotalLoaded state) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columnSpacing:
              state.selectedYear == 0
                  ? MediaQuery.of(context).size.width * 0.1
                  : MediaQuery.of(context).size.width * 0.125,

          headingRowHeight: 30,
          columns: [
            DataColumn(
              label: Text(
                state.selectedYear == 0
                    ? AppLocale.date.getString(context)
                    : AppLocale.month.getString(context),
              ),
            ),
            DataColumn(label: Text(AppLocale.expense.getString(context))),
            DataColumn(label: Text(AppLocale.income.getString(context))),
            DataColumn(label: Text(AppLocale.balance.getString(context))),
          ],
          rows: List.generate(state.totalList.length, (index) {
            final item = state.totalList[index];
            return DataRow(
              onSelectChanged: (value) {
                context.read<ExpenseCrudCubit>().loadExpenses(
                  item.year,
                  item.month,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPeMonthPage(monthlyTotal: item),
                  ),
                );
              },
              cells: [
                DataCell(
                  Text(
                    state.selectedYear == 0
                        ? '${getMonthName(item.month)} - ${item.year}'
                        : getMonthName(item.month),
                  ),
                ),
                DataCell(Text(formatAmountRP(item.expenses, useSymbol: false))),
                DataCell(Text(formatAmountRP(item.income, useSymbol: false))),
                DataCell(Text(formatAmountRP(item.balance, useSymbol: false))),
              ],
            );
          }),
        ),
      ),
    );
  }
}
