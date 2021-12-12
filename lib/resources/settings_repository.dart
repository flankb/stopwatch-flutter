import 'package:stopwatch/util/pref_service.dart';

import 'base/base_settings_repository.dart';

class SettingsRepository implements BaseSettingsRepository {
  final PrefService _provider = PrefService.getInstance();

  @override
  Future<void> loadSettings() async {
    await _provider.init();
  }

  @override
  bool? getBool(String key) => _provider.sharedPrefs.getBool(key);

  @override
  void setBool({required String key, required bool value}) =>
      _provider.sharedPrefs.setBool(key, value);

  @override
  String? getString(String key) => _provider.sharedPrefs.getString(key);

  @override
  void setString({required String key, required String value}) =>
      _provider.sharedPrefs.setString(key, value);
}
