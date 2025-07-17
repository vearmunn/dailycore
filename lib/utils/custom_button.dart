// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'colors_and_icons.dart';

class DailyCoreButton extends StatelessWidget {
  const DailyCoreButton({
    super.key,
    required this.child,
    required this.onTap,
    this.bgColor = dailyCoreBlue,
    this.fgColor = Colors.white,
  });
  final Widget child;
  final VoidCallback onTap;
  final Color bgColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
      ),
      child: child,
    );
  }
}
