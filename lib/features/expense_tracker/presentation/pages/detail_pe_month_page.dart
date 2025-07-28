// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/monthly_total.dart';
import '../../utils/expense_util.dart';
import '../../utils/exports.dart';
import '../../widgets/report_header.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';

class DetailPeMonthPage extends StatefulWidget {
  const DetailPeMonthPage({super.key, required this.monthlyTotal});
  final MonthlyTotal monthlyTotal;

  @override
  State<DetailPeMonthPage> createState() => _DetailPeMonthPageState();
}

class _DetailPeMonthPageState extends State<DetailPeMonthPage> {
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'date desc';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '${getMonthName(widget.monthlyTotal.month)} ${widget.monthlyTotal.year}',
        ),
        actions: [
          BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
            builder: (context, state) {
              if (state is ExpenseCrudLoaded) {
                var transactions = getTransactions(
                  state.expenseList,
                  selectedFilter,
                );
                double totalExpense = widget.monthlyTotal.expenses;
                double totalIncome = widget.monthlyTotal.income;
                double totalBalance = widget.monthlyTotal.balance;
                return IconButton(
                  onPressed:
                      () => showExportOptions(
                        context,
                        transactions.map((e) => e.toList()).toList(),
                        totalExpense,
                        totalIncome,
                        totalBalance,
                        Expense.headers(),
                        'Finance Tracker Report for ${getMonthName(widget.monthlyTotal.month)} ${widget.monthlyTotal.year}',
                        true,
                      ),
                  icon: Icon(Icons.file_download_outlined),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ReportHeader(
            totalExpense: widget.monthlyTotal.expenses,
            totalIncome: widget.monthlyTotal.income,
            totalBalance: widget.monthlyTotal.balance,
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: selectedFilter,
                    iconEnabledColor: Colors.black,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    items: [
                      _dropDownItem(
                        value: 'date desc',
                        label1: AppLocale.date.getString(context),
                        label2:
                            '(${AppLocale.latest.getString(context)} ->${AppLocale.earliest.getString(context)})',
                      ),
                      _dropDownItem(
                        value: 'date asc',
                        label1: AppLocale.date.getString(context),
                        label2:
                            '(${AppLocale.earliest.getString(context)} -> ${AppLocale.latest.getString(context)})',
                      ),
                      _dropDownItem(
                        value: 'amount desc',
                        label1: AppLocale.amount.getString(context),
                        label2:
                            '(${AppLocale.biggest.getString(context)} -> ${AppLocale.lowest.getString(context)})',
                      ),
                      _dropDownItem(
                        value: 'amount asc',
                        label1: AppLocale.amount.getString(context),
                        label2:
                            '(${AppLocale.lowest.getString(context)} -> ${AppLocale.biggest.getString(context)})',
                      ),
                      _dropDownItem(
                        value: 'type desc',
                        label1: AppLocale.type.getString(context),
                        label2:
                            '(${AppLocale.income.getString(context)} -> ${AppLocale.expense.getString(context)})',
                      ),
                      _dropDownItem(
                        value: 'type asc',
                        label1: AppLocale.type.getString(context),
                        label2:
                            '(${AppLocale.expense.getString(context)} -> ${AppLocale.income.getString(context)})',
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        selectedFilter = v!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
                builder: (context, state) {
                  if (state is ExpenseCrudLoaded) {
                    var transactions = getTransactions(
                      state.expenseList,
                      selectedFilter,
                    );
                    return DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: MediaQuery.of(context).size.width * 0.08,
                      headingRowHeight: 30,
                      columns: [
                        DataColumn(
                          label: Text(AppLocale.date.getString(context)),
                        ),
                        DataColumn(
                          label: Text(AppLocale.note.getString(context)),
                        ),
                        DataColumn(
                          label: Text(AppLocale.type.getString(context)),
                        ),
                        DataColumn(
                          label: Text(AppLocale.amount.getString(context)),
                        ),
                      ],
                      rows: List.generate(transactions.length, (index) {
                        final transaction = transactions[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(transaction.date.day.toString())),
                            DataCell(Text(transaction.note ?? '')),
                            DataCell(
                              Text(
                                transaction.type == 'Income'
                                    ? AppLocale.income.getString(context)
                                    : AppLocale.expense.getString(context),
                              ),
                            ),
                            DataCell(
                              Text(
                                formatAmountRP(
                                  transaction.amount,
                                  useSymbol: false,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _dropDownItem({
    required String value,
    required String label1,
    required String label2,
  }) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Text('$label1  '),
          Text(
            label2,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Expense> getTransactions(List<Expense> expenseList, String sortBy) {
    List<Expense> transactions = [];
    transactions =
        expenseList
            .where(
              (item) =>
                  item.date.month == widget.monthlyTotal.month &&
                  item.date.year == widget.monthlyTotal.year,
            )
            .toList();
    if (sortBy == 'date desc') {
      transactions.sort((a, b) => b.date.compareTo(a.date));
    }
    if (sortBy == 'date asc') {
      transactions.sort((a, b) => a.date.compareTo(b.date));
    }
    if (sortBy == 'amount desc') {
      transactions.sort((a, b) => b.amount.compareTo(a.amount));
    }
    if (sortBy == 'amount asc') {
      transactions.sort((a, b) => a.amount.compareTo(b.amount));
    }
    if (sortBy == 'type desc') {
      transactions.sort((a, b) => b.type.compareTo(a.type));
    }
    if (sortBy == 'type asc') {
      transactions.sort((a, b) => a.type.compareTo(b.type));
    }
    return transactions;
  }
}
