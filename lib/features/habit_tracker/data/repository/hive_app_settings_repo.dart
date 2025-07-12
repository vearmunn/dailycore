import 'package:dailycore/features/habit_tracker/data/models/hive_app_settings.dart';
import 'package:dailycore/hive_boxes/boxes.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/repository/app_settings_repo.dart';

class HiveAppSettingsRepo implements AppSettingsRepo {
  final box = Hive.box<AppSettingsHive>(appSettingBox);

  @override
  Future saveFirstLaunchDate() async {
    final existingSettings = box.values.firstOrNull;

    if (existingSettings == null) {
      final settings =
          AppSettingsHive()
            ..id = DateTime.now().millisecondsSinceEpoch
            ..firstLaunchDate = DateTime.now();
      box.add(settings);
    }
  }

  @override
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = box.values.firstOrNull;
    // print('LAUNCH DATE: ${settings?.firstLaunchDate}');
    return settings?.firstLaunchDate;
  }
}
