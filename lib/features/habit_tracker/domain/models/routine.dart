// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class Routine {
  final int id;
  final String name;
  final String description;
  final String repeatType;
  final List<int> daysofWeek;
  final List<int> datesofMonth;
  final List<DateTime>? completedDays;
  final Color color;
  final IconData icon;
  final List<SubHabit> subHabits;

  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.repeatType,
    required this.daysofWeek,
    required this.datesofMonth,
    required this.completedDays,
    required this.color,
    required this.icon,
    required this.subHabits,
  });
}

class SubHabit {
  final int id;
  final String habit;
  final bool isCompleted;

  SubHabit({required this.id, required this.habit, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'habit': habit,
      'isCompleted': isCompleted,
    };
  }

  factory SubHabit.fromMap(Map<String, dynamic> map) {
    return SubHabit(
      id: map['id'] as int,
      habit: map['habit'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}
