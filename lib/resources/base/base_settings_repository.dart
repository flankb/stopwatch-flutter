abstract class BaseSettingsRepository {
  Future<void> loadSettings();

  bool? getBool(String key);

  void setBool({required String key, required bool value});

  String? getString(String key);

  void setString({required String key, required String value});
}
