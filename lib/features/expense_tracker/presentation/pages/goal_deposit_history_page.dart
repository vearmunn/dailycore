// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:dailycore/utils/dates_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../domain/models/goal.dart';

class GoalDepositHistoryPage extends StatelessWidget {
  final List<DepositHistory> depositHistoryList;
  const GoalDepositHistoryPage({super.key, required this.depositHistoryList});

  @override
  Widget build(BuildContext context) {
    depositHistoryList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.depositHistory.getString(context))),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: depositHistoryList.length,
        itemBuilder: (BuildContext context, int index) {
          final history = depositHistoryList[index];
          return ListTile(
            title: Text(
              formatAmountRP(history.amount),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle:
                history.note != null
                    ? Text(history.note!, style: TextStyle(color: Colors.grey))
                    : null,
            trailing: Text(formattedDate(history.dateTime)),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
