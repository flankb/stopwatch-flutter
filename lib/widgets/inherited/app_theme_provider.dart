
import 'package:flutter/widgets.dart';
import 'package:stopwatch/theme_data.dart';

class AppThemeProvider extends InheritedWidget {
  final AppTheme appTheme;

  AppThemeProvider(this.appTheme, {@required Widget child, Key key}) : super(child : child, key : key);

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) {
    return oldWidget.appTheme != appTheme;
  }

  static AppThemeProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
  }
}