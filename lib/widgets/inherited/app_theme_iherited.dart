
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/theme_data.dart';

// TODO Скопировать данный код в базу знаний
// TODO Вместе со статьёй https://ericwindmill.com/articles/inherited_widget/
class AppThemeProvider extends InheritedWidget {
  final AppTheme appTheme;
  final AppThemeContainerState data;

  AppThemeProvider(this.appTheme, this.data, {@required Widget child, Key key}) : super(child : child, key : key);

  ThemeData getTheme(Map<AppTheme, ThemeData> themes) {
    return themes[appTheme];
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) {
    return oldWidget.appTheme != appTheme;
  }

  static AppThemeProvider of(BuildContext context){
    //context.findAncestorWidgetOfExactType()

    return context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
  }
}

class AppThemeContainer extends StatefulWidget {
  final Widget child;
  final AppTheme appTheme;

  const AppThemeContainer({Key key, @required this.child, @required this.appTheme}) : super(key: key);

  @override
  AppThemeContainerState createState() => AppThemeContainerState();

  static AppThemeContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeProvider>().data;
  }
}

class AppThemeContainerState extends State<AppThemeContainer> {
  AppTheme theme;

  @override
  initState(){
    super.initState();
    theme = widget.appTheme;
  }

  updateTheme(AppTheme newTheme){
    setState(() {
      theme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(theme, this, child: widget.child,);
  }
}