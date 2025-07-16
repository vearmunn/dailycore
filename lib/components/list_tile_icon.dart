import 'package:flutter/material.dart';

import '../utils/spaces.dart';

Widget listTileIcon(
  BuildContext context, {
  required Color color,
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
  EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 16),
  Widget trailing = const SizedBox.shrink(),
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
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
                Text(title),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    ),
  );
}
