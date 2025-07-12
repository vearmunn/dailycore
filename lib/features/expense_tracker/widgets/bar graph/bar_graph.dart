// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:dailycore/features/expense_tracker/widgets/bar%20graph/individual_bar.dart';

class ExpenseBarGraph extends StatefulWidget {
  final List<double> monthlySummary; // [500.000, 860.000, 1.000.000]
  final int startMonth; // 0 Jan, 1 Feb, 2 Mar
  const ExpenseBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<ExpenseBarGraph> createState() => _ExpenseBarGraphState();
}

class _ExpenseBarGraphState extends State<ExpenseBarGraph> {
  // this list will hold the data for each bar
  List<IndividualBar> barData = [];

  // initialize bar data - use our monthly summary to create a list of bars
  void initializeBarData() {
    // widget.monthlyTotals.
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: index + widget.startMonth,
        y: widget.monthlySummary[index],
      ),
    );
    // print('BAR DATA: ${barData.map((e) => e.y)}');
  }

  double calculateMax() {
    // initially, set it at 500k, but adjust if spending is past this amount
    double max = 500000;

    // get the month with the highest amount
    widget.monthlySummary.sort();

    max = widget.monthlySummary.last;

    if (max < 500000) {
      return 500000;
    } else {
      return max;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    double barWidth = 20;
    double spaceBetweenBars = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width:
            barWidth * barData.length + spaceBetweenBars * (barData.length - 1),
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: calculateMax(),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getBottomTitles,
                  reservedSize: 24,
                ),
              ),
            ),
            barGroups:
                barData
                    .map(
                      (data) => BarChartGroupData(
                        x: data.x,
                        barRods: [
                          BarChartRodData(
                            toY: data.y,
                            width: 20,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: calculateMax(),
                              color: Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String text;
  switch (value.toInt()) {
    case 1:
      text = 'Jan';
      break;
    case 2:
      text = 'Feb';
      break;
    case 3:
      text = 'Mar';
      break;
    case 4:
      text = 'Apr';
      break;
    case 5:
      text = 'May';
      break;
    case 6:
      text = 'Jun';
      break;
    case 7:
      text = 'Jul';
      break;
    case 8:
      text = 'Aug';
      break;
    case 9:
      text = 'Sep';
      break;
    case 10:
      text = 'Oct';
      break;
    case 11:
      text = 'Nov';
      break;
    case 12:
      text = 'Dec';
      break;

    default:
      text = '';
      break;
  }
  return SideTitleWidget(meta: meta, child: Text(text, style: textStyle));
}
