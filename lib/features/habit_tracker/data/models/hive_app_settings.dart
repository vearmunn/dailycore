import 'package:hive_ce/hive.dart';

import '../../domain/models/app_settings.dart';

class AppSettingsHive extends HiveObject {
  late int id;
  late DateTime? firstLaunchDate;

  // convert hive object -> pure AppSettings object to use in this app.
  AppSettings toDomain() {
    return AppSettings(id: id, firstLaunchDate: firstLaunchDate);
  }

  // convert pure AppSettings object -> hive object to store in hive db.
  static AppSettingsHive fromDomain(AppSettings appSettings) {
    return AppSettingsHive()
      ..id = appSettings.id
      ..firstLaunchDate = appSettings.firstLaunchDate;
  }
}
