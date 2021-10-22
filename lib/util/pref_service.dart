import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static PrefService? _instance;
  late SharedPreferences _prefs;

  PrefService._();

  static PrefService get instance {
    if (_instance == null) {
      _instance = PrefService._();
    }

    return _instance!;
  }

  SharedPreferences get sharedPrefs => _prefs;

  Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}