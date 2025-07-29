import 'package:dailycore/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/colors_and_icons.dart';
import 'color_icon_selector_cubit.dart';

Widget iconSelector(BuildContext context, bool showIconSelections) {
  return AnimatedOpacity(
    opacity: showIconSelections ? 1 : 0,
    duration: Duration(milliseconds: 100),
    curve: Curves.easeIn,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
      height: showIconSelections ? 200 : 0,
      decoration: BoxDecoration(
        color: ThemeHelper.containerColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        shrinkWrap: true,
        itemCount: iconMap.length,
        itemBuilder: (BuildContext context, int index) {
          final icon = getIconByIndex(index);
          return GestureDetector(
            onTap: () {
              context.read<IconSelectorCubit>().setIcon(icon);
            },
            child: Icon(icon),
          );
        },
      ),
    ),
  );
}
