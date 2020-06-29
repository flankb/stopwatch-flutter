import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/theme_data.dart';

class ThemeController extends ChangeNotifier {
  AppTheme _appTheme;
  Map<AppTheme, ExtendedTheme> _availableThemes;

  ThemeController(AppTheme initialTheme, Map<AppTheme, ExtendedTheme> availableThemes) {
    _appTheme = initialTheme;
    _availableThemes = availableThemes;
  }

  AppTheme get theme => _appTheme;
  ExtendedTheme get themeData => _availableThemes[_appTheme];

  updateTheme(AppTheme newTheme) {
    if (_appTheme != newTheme) {
      _appTheme = newTheme;

      debugPrint("Updated theme: " + newTheme.toString());

      notifyListeners();
    }
  }
}

class InheritedThemeNotifier extends InheritedNotifier<ThemeController>{
  final ThemeController controller;

  const InheritedThemeNotifier({Key key, @required Widget child, @required this.controller})
      : super(key: key, child: child, notifier: controller);

  static ThemeController of(BuildContext context) {
    // Здесь каким-то образом подменить текстовую тему? (Известен контекст)

    return context.dependOnInheritedWidgetOfExactType<InheritedThemeNotifier>().controller;
  }
}