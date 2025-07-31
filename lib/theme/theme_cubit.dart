// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/consts/prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;
  ThemeCubit(this.prefs) : super(ThemeMode.light) {
    initialTheme();
  }

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void setLightMode() {
    prefs.setBool(isDarkMode, false);
    emit(ThemeMode.light);
  }

  void setDarkMode() {
    prefs.setBool(isDarkMode, true);
    emit(ThemeMode.dark);
  }

  void initialTheme() {
    final isDarkTheme = prefs.getBool(isDarkMode);
    if (isDarkTheme == null) {
      return emit(ThemeMode.light);
    } else if (isDarkTheme) {
      return emit(ThemeMode.dark);
    } else {
      return emit(ThemeMode.light);
    }
  }
}
