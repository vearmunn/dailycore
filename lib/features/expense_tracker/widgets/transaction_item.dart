import 'package:flutter/material.dart';

import '../../../utils/colors_and_icons.dart';
import '../../../utils/dates_utils.dart';
import '../../../utils/spaces.dart';
import '../utils/expense_util.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.label,
    required this.totalAmount,
    required this.itemAmount,
    required this.icon,
    required this.color,
    this.date,
  });

  final String label;
  final double totalAmount;
  final double itemAmount;
  final IconData icon;
  final Color color;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withAlpha(30),
            ),
            child: Icon(color: color, icon),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
                    horizontalSpace(10),
                    Text(
                      '${getPercentage(itemAmount, totalAmount).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Spacer(),
                    Text(formatAmountRP(itemAmount, useSymbol: false)),
                  ],
                ),
                verticalSpace(6),
                LinearProgressIndicator(
                  color: dailyCoreBlue,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(20),
                  value: getPercentage(itemAmount, totalAmount) / 100,
                ),
                verticalSpace(6),
                if (date != null)
                  Text(
                    formattedDate(date!),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
