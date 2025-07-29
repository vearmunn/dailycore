import 'package:dailycore/features/expense_tracker/presentation/cubit/pie_chart/pie_chart_cubit.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/category_detail_transaction_page.dart';
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:dailycore/features/expense_tracker/widgets/transaction_item.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../../../utils/colors_and_icons.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String selectedType = 'Expense';
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: BlocBuilder<PieChartCubit, DefaultChartState>(
        builder: (context, state) {
          if (state is ChartError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is ChartLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PieChartState) {
            if (state.total == 0) {
              return Stack(
                children: [
                  _buildChartFilter(state),
                  Center(child: Text('No Data')),
                ],
              );
            }
            return Stack(
              children: [_buildChartDetails(state), _buildChartFilter(state)],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildChartFilter(PieChartState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
      color: dailyCorePurple,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: state.selectedType,
                  iconEnabledColor: Colors.white,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  dropdownColor: dailyCorePurple,
                  items: [
                    DropdownMenuItem(
                      value: 'Expense',
                      child: Text(AppLocale.expense.getString(context)),
                    ),
                    DropdownMenuItem(
                      value: 'Income',
                      child: Text(AppLocale.income.getString(context)),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      selectedType = v!;
                      context.read<PieChartCubit>().updateData(
                        type: selectedType,
                        month: state.month,
                        year: state.year,
                      );
                    });
                  },
                ),
              ),
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                showMonthPicker(
                  context,
                  onSelected: (month, year) {
                    context.read<PieChartCubit>().updateData(
                      month: month,
                      year: year,
                    );
                  },
                  initialSelectedMonth: state.month,
                  initialSelectedYear: state.year,
                  firstYear: 2020,
                  lastYear: DateTime.now().year,
                  selectButtonText: 'OK',
                  cancelButtonText: AppLocale.cancel.getString(context),
                  highlightColor: dailyCorePurple,
                  textColor: Colors.black,
                  contentBackgroundColor: Colors.white,
                  dialogBackgroundColor: Colors.grey[200],
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 12, 8, 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getMonthName(state.month)} ${state.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartDetails(PieChartState state) {
    return ListView(
      children: [
        verticalSpace(60),
        // PIE CHART------------------------------------------------------------
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          padding: EdgeInsets.fromLTRB(8, 0, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PieChart(
                      curve: Curves.fastEaseInToSlowEaseOut,
                      duration: Duration(milliseconds: 500),
                      PieChartData(
                        sections: state.sections,
                        centerSpaceRadius: 50,
                        sectionsSpace: 3,
                      ),
                    ),
                    Center(
                      child: Text(
                        formatAmountRP(state.total, useSymbol: false),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(state.topCategories.length, (index) {
                    final category = state.topCategories[index];
                    if (category.amount != 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: category.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            horizontalSpace(8),
                            Text(
                              category.categoryName,
                              style: TextStyle(fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              '${getPercentage(category.amount, state.total).toStringAsFixed(1)}%',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
        // DETAILS--------------------------------------------------------------
        ListView.builder(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.categoryDatalist.length,
          itemBuilder: (BuildContext context, int index) {
            final category = state.categoryDatalist[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CategoryDetailTransactionPage(
                          category: category,
                          type: selectedType,
                          month: state.month,
                          year: state.year,
                        ),
                  ),
                );
              },
              child: TransactionItem(
                label: category.categoryName,
                totalAmount: state.total,
                itemAmount: category.amount,
                icon: getIconByName(category.iconName),
                color: category.color,
              ),
            );
          },
        ),
      ],
    );
  }
}
