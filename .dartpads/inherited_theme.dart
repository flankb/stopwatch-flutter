// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';


enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
}

final appThemeData = { 
  AppTheme.GreenLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
  ),
  AppTheme.GreenDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[700],
  ),
  AppTheme.BlueLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
  ),
  AppTheme.BlueDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
  ),
};


class ThemeController extends ChangeNotifier {
  AppTheme _appTheme;
  Map<AppTheme, ThemeData> _availableThemes;
  String _title;

  ThemeController(AppTheme initialTheme, Map<AppTheme, ThemeData> availableThemes) {
    _appTheme = initialTheme;
    _availableThemes = availableThemes;
  }

  AppTheme get theme => _appTheme;
  ThemeData get themeData => _availableThemes[_appTheme];
  String get title => _title;

  updateTheme(AppTheme newTheme) {
    if (_appTheme != newTheme) {
      _appTheme = newTheme;

      debugPrint("Updated theme: " + newTheme.toString());

      notifyListeners();
    }
  }
  
  updateTitle(int cnt){
    _title = "PP " + cnt.toString(); 
    notifyListeners(); 
  }
}

class InheritedThemeNotifier extends InheritedNotifier<ThemeController>{
  final ThemeController controller;

  const InheritedThemeNotifier({Key key, @required Widget child, @required this.controller})
      : super(key: key, child: child, notifier: controller);

  static ThemeController of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<InheritedThemeNotifier>();
    debugPrint("ThemeController of: " + p.toString());

    return p == null ? null : context.dependOnInheritedWidgetOfExactType<InheritedThemeNotifier>().controller;
  }

}


void main() {
  final controller  = ThemeController(AppTheme.BlueDark, appThemeData);
  
  runApp(MyApp(themeController : controller));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  
   const MyApp({Key key, this.themeController}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
   return  InheritedThemeNotifier(
      controller: themeController,
    
    child : MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:  InheritedThemeNotifier.of(context) == null ? themeController.themeData : InheritedThemeNotifier.of(context).themeData,/*ThemeData(
        primarySwatch: Colors.blue,
      ),*/
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    ),
  );
}
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = InheritedThemeNotifier.of(context) == null ? "null" : InheritedThemeNotifier.of(context).title;
    final currentTheme = InheritedThemeNotifier.of(context) == null ? "null" : InheritedThemeNotifier.of(context).theme.toString();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              //'$_counter',
              "$currentTheme",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          //_incrementCounter(); 
          InheritedThemeNotifier.of(context).updateTheme(AppTheme.BlueLight);
          InheritedThemeNotifier.of(context).updateTitle(34);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
