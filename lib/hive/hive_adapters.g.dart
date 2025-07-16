// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TodoHiveAdapter extends TypeAdapter<TodoHive> {
  @override
  final typeId = 0;

  @override
  TodoHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoHive()
      ..id = (fields[0] as num).toInt()
      ..text = fields[1] as String
      ..isCompleted = fields[2] as bool
      ..dueDate = fields[3] as DateTime?
      ..category = fields[4] as TodoCategoryHive
      ..priority = fields[5] as String
      ..subTodos =
          (fields[6] as List)
              .map((e) => (e as Map).cast<String, dynamic>())
              .toList()
      ..repeatDate = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, TodoHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.subTodos)
      ..writeByte(7)
      ..write(obj.repeatDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSettingsHiveAdapter extends TypeAdapter<AppSettingsHive> {
  @override
  final typeId = 1;

  @override
  AppSettingsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsHive()
      ..id = (fields[0] as num).toInt()
      ..firstLaunchDate = fields[1] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, AppSettingsHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstLaunchDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitHiveAdapter extends TypeAdapter<HabitHive> {
  @override
  final typeId = 2;

  @override
  HabitHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitHive()
      ..id = (fields[0] as num).toInt()
      ..name = fields[1] as String
      ..comletedDays = (fields[2] as List?)?.cast<DateTime>()
      ..description = fields[3] as String
      ..repeatType = fields[4] as String
      ..daysofWeek = (fields[5] as List).cast<int>()
      ..datesofMonth = (fields[6] as List).cast<int>()
      ..color = (fields[7] as num).toInt()
      ..icon = (fields[8] as Map).cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, HabitHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.comletedDays)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.repeatType)
      ..writeByte(5)
      ..write(obj.daysofWeek)
      ..writeByte(6)
      ..write(obj.datesofMonth)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseHiveAdapter extends TypeAdapter<ExpenseHive> {
  @override
  final typeId = 3;

  @override
  ExpenseHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseHive()
      ..id = (fields[0] as num).toInt()
      ..amount = (fields[2] as num).toDouble()
      ..date = fields[3] as DateTime
      ..category = fields[4] as ExpenseCategoryHive
      ..note = fields[5] as String?
      ..type = fields[6] as String
      ..image = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, ExpenseHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoCategoryHiveAdapter extends TypeAdapter<TodoCategoryHive> {
  @override
  final typeId = 4;

  @override
  TodoCategoryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoCategoryHive()
      ..id = (fields[0] as num).toInt()
      ..name = fields[1] as String
      ..color = (fields[2] as num).toInt()
      ..icon = (fields[3] as Map).cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, TodoCategoryHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoCategoryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseCategoryHiveAdapter extends TypeAdapter<ExpenseCategoryHive> {
  @override
  final typeId = 5;

  @override
  ExpenseCategoryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseCategoryHive()
      ..name = fields[0] as String
      ..color = (fields[1] as num).toInt()
      ..icon = (fields[2] as Map).cast<String, dynamic>()
      ..id = (fields[3] as num).toInt()
      ..type = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, ExpenseCategoryHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalHiveAdapter extends TypeAdapter<GoalHive> {
  @override
  final typeId = 6;

  @override
  GoalHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalHive()
      ..id = (fields[0] as num).toInt()
      ..title = fields[1] as String
      ..description = fields[2] as String?
      ..targetAmount = (fields[3] as num).toDouble()
      ..currentAmount = (fields[4] as num).toDouble()
      ..deadline = fields[5] as DateTime?
      ..depositHistoryList =
          (fields[6] as List?)
              ?.map((e) => (e as Map).cast<String, dynamic>())
              .toList()
      ..imagePath = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, GoalHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.targetAmount)
      ..writeByte(4)
      ..write(obj.currentAmount)
      ..writeByte(5)
      ..write(obj.deadline)
      ..writeByte(6)
      ..write(obj.depositHistoryList)
      ..writeByte(7)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
