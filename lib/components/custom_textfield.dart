import 'package:dailycore/theme/theme_helper.dart';
import 'package:flutter/material.dart';

import '../utils/colors_and_icons.dart';

Widget customTextfield(
  BuildContext context,
  String hint,
  TextEditingController controller, {
  TextInputType keyboardType = TextInputType.text,
  Color borderColor = dailyCoreBlue,
}) {
  return TextField(
    controller: controller,
    maxLines: null,
    minLines: 1,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      labelText: hint,
      labelStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: ThemeHelper.containerColor(context),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
