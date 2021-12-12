import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static PrefService? _instance;
  late SharedPreferences _prefs;

  PrefService._();

  factory PrefService.getInstance() {
    _instance ??= PrefService._();

    return _instance!;
  }

  SharedPreferences get sharedPrefs => _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
