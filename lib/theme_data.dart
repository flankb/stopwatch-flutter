import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
  //PinkLight
}

class ExtendedTheme {
  final ThemeData materialTheme;
  final Color shadowColor;
  final buttonPauseColor;
  final subtitleColor;


  ExtendedTheme(this.materialTheme, { this.shadowColor = const Color(0xff3F3C3C), this.buttonPauseColor = Colors.black, this.subtitleColor = const Color(0xffE6E6E6) });
}

ThemeData baseTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.latoTextTheme()
);



final appThemeData = { //TODO создавать этот словарь в контексте??

  AppTheme.GreenLight : ExtendedTheme(baseTheme.copyWith(
    primaryColor: Colors.green,
    toggleableActiveColor : Colors.green,
    focusColor: Colors.green
  ),
      subtitleColor : const Color(0xff4A4747)
  ),

  /*AppTheme.GreenLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    toggleableActiveColor : Colors.green,


  ),*/
  AppTheme.GreenDark: ExtendedTheme(ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[700],
    toggleableActiveColor : Colors.green[700],
    focusColor: Colors.green[700],
  ),
      subtitleColor : const Color(0xffA5A5A5)
  ),

  AppTheme.BlueLight: ExtendedTheme(ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    toggleableActiveColor : Colors.blue
  ),
      subtitleColor : const Color(0xff4A4747)
  ),

  AppTheme.BlueDark : ExtendedTheme(ThemeData.dark().copyWith(
    primaryColor: Colors.blue[700],
    toggleableActiveColor : Colors.blue[700]
  ),
      subtitleColor : const Color(0xffA5A5A5)) //
};

/*
ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            //brightness: Brightness.dark, // Тёмная тема
            //primarySwatch: Colors.deepOrange,
            primaryColor: Colors.blue,

            textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context).textTheme,
            ),
        )
 */