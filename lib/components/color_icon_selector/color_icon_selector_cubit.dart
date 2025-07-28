import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/colors_and_icons.dart';

Color defaultColor = colorSelections[randomIndex(colorSelections.length)];
IconData defaultIcon = getRandomIcon();

class ColorSelectorCubit extends Cubit<Color> {
  ColorSelectorCubit() : super(defaultColor);

  void setColor(Color color) => emit(color);
}

class IconSelectorCubit extends Cubit<IconData> {
  IconSelectorCubit() : super(defaultIcon);

  void setIcon(IconData icon) => emit(icon);
}
