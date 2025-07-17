import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/routine.dart';

class RoutineHive extends HiveObject {
  late int id;
  late String name;
  late String description;
  late String repeatType;
  late List<int> daysofWeek;
  late List<int> datesofMonth;
  late List<DateTime>? comletedDays;
  late int color;
  late Map<String, dynamic> icon;
  late List<Map<String, dynamic>> subHabits;

  Routine toDomain() {
    return Routine(
      id: id,
      name: name,
      repeatType: repeatType,
      description: description,
      datesofMonth: datesofMonth,
      daysofWeek: daysofWeek,
      completedDays: comletedDays,
      color: fromArgb32(color),
      icon: IconData(icon['code_point'], fontFamily: icon['font_family']),
      subHabits:
          subHabits.map((subHabit) => SubHabit.fromMap(subHabit)).toList(),
    );
  }

  static RoutineHive fromDomain(Routine routine) {
    return RoutineHive()
      ..id = routine.id
      ..name = routine.name
      ..description = routine.description
      ..repeatType = routine.repeatType
      ..comletedDays = routine.completedDays
      ..daysofWeek = routine.daysofWeek
      ..datesofMonth = routine.datesofMonth
      ..color = routine.color.toARGB32()
      ..icon = {
        'code_point': routine.icon.codePoint,
        'font_family': routine.icon.fontFamily,
      }
      ..subHabits =
          routine.subHabits.map((subHabit) => subHabit.toMap()).toList();
  }
}
