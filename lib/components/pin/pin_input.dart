// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/colors_and_icons.dart';

class MyPinInput extends StatelessWidget {
  final void Function(String) onSubmitted;
  const MyPinInput({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 24,
        // color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: ThemeHelper.containerColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Pinput(
      obscureText: true,

      validator: (value) {
        if (value == null) {
          errorToast(context, 'PIN must not be empty!');
        } else if (value.length < 4) {
          errorToast(context, 'PIN must be 4 digits length!');
        }
        return null;
      },
      closeKeyboardWhenCompleted: false,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: dailyCoreBlue),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
