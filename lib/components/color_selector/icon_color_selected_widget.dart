import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/spaces.dart';
import 'color_icon_selector_cubit.dart';

Widget colorOrIconSelected(bool isColor, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    isColor
                        ? BlocBuilder<ColorSelectorCubit, Color>(
                          builder: (context, selectedColor) {
                            return Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedColor,
                              ),
                            );
                          },
                        )
                        : BlocBuilder<IconSelectorCubit, IconData>(
                          builder: (context, selectedIcon) {
                            return Icon(selectedIcon);
                          },
                        ),
                    horizontalSpace(12),
                    Text(isColor ? 'Color' : 'Icon'),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    ),
  );
}
