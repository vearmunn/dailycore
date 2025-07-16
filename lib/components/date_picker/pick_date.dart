import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../utils/dates_utils.dart';
import '../../utils/spaces.dart';
import 'pick_date_cubit.dart';

Future pickDate(BuildContext context, {DateTime? initialDate}) async {
  final dateCubit = context.read<DateCubit>();
  final DateTime? picked = await showDatePicker(
    context: context,

    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    dateCubit.setDate(picked);
  }
}

Future pickDateTime(BuildContext context, {DateTime? initialDate}) async {
  final dateCubit = context.read<DateCubit>();
  final DateTime? picked = await showOmniDateTimePicker(
    context: context,
    is24HourMode: true,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    dateCubit.setDate(picked);
  }
}

Widget customDatePicker(
  BuildContext context,
  DateTime initialDate, {
  bool allowNull = false,
  bool useDateAndTime = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (useDateAndTime) {
              pickDateTime(context, initialDate: initialDate);
            } else {
              pickDate(context, initialDate: initialDate);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<DateCubit, DateTime?>(
                  builder: (context, selectedDate) {
                    if (selectedDate == null && allowNull) {
                      return Text(
                        'No Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (selectedDate == null) {
                      return Text(
                        formattedDateAndTime(initialDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        formattedDateAndTime(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                horizontalSpace(30),
                Icon(Icons.calendar_month_rounded, color: Colors.black54),
              ],
            ),
          ),
        ),

        if (allowNull)
          TextButton(
            onPressed: () => context.read<DateCubit>().setDate(null),
            child: Text('Set no date'),
          ),
      ],
    ),
  );
}
