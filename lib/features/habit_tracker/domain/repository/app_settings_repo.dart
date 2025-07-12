abstract class AppSettingsRepo {
  // Save first date of app startup (for heatmap)
  Future saveFirstLaunchDate();

  // Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate();
}
