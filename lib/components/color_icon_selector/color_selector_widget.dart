// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors_and_icons.dart';
import 'color_icon_selector_cubit.dart';

Widget colorSelector(BuildContext context, bool showColorSelections) {
  return AnimatedOpacity(
    duration: Duration(milliseconds: 100),
    opacity: showColorSelections ? 1 : 0,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
      height: showColorSelections ? 60 : 0,

      decoration: BoxDecoration(
        color: ThemeHelper.containerColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: colorSelections.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              context.read<ColorSelectorCubit>().setColor(
                colorSelections[index],
              );
            },
            child: Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSelections[index],
              ),
            ),
          );
        },
      ),
    ),
  );
}
