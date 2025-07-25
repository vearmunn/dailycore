import 'package:flutter/material.dart';

import '../utils/colors_and_icons.dart';

Widget customTextfield(
  String hint,
  TextEditingController controller, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    maxLines: null,
    minLines: 1,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      label: Text(hint),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: dailyCoreBlue),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
