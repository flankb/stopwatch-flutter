import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/theme_data.dart';

class ThemeController extends ChangeNotifier {
  AppTheme _appTheme;
  Map<AppTheme, ThemeData> _availableThemes;

  ThemeController(AppTheme initialTheme, Map<AppTheme, ThemeData> availableThemes) {
    _availableThemes = availableThemes;
  }

  AppTheme get theme => _appTheme;
  ThemeData get themeData => _availableThemes[_appTheme];

  updateTheme(AppTheme newTheme) {
    if (_appTheme != newTheme) {
      _appTheme = newTheme;
      notifyListeners();
    }
  }
}

class InheritedThemeNotifier extends InheritedNotifier<ThemeController>{
  final ThemeController controller;

  const InheritedThemeNotifier({Key key, @required Widget child, this.controller})
      : super(key: key, child: child, notifier: controller);

  static ThemeController of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeNotifier>().controller;
  }
}