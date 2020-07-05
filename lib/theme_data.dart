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

  ExtendedTheme(this.materialTheme,
      {this.shadowColor = const Color(0xff3F3C3C), this.buttonPauseColor = Colors.black, this.subtitleColor = const Color(0xffE6E6E6)});
}

ThemeData baseTheme = ThemeData(
  //brightness: Brightness.light,
  textTheme: GoogleFonts.latoTextTheme(),

  // https://stackoverflow.com/questions/50020523/how-to-disable-default-widget-splash-effect-in-flutter
  //splashColor: Colors.transparent, // TODO Убираются Material-эффекты
  //highlightColor: Colors.transparent,
);

final appThemeData = {
  //TODO создавать этот словарь в контексте??
  AppTheme.GreenLight: ExtendedTheme(
      ThemeData(brightness: Brightness.light,
          primaryColor: Colors.green,
          toggleableActiveColor: Colors.green,
          focusColor: Colors.green,
          accentColor: Colors.green,

          textTheme: GoogleFonts.latoTextTheme(
              ThemeData.light().textTheme
          )

        ),
      subtitleColor: const Color(0xff8e8e8e)),
  AppTheme.GreenDark: ExtendedTheme(
      ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green[700],
        accentColor: Colors.green[700],
        toggleableActiveColor: Colors.green[700],
        focusColor: Colors.green[700],
        textTheme: GoogleFonts.latoTextTheme(
            ThemeData.dark().textTheme
        ),
      ),
      subtitleColor: const Color(0xffA5A5A5)),

  AppTheme.BlueLight: ExtendedTheme(ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      toggleableActiveColor: Colors.blue,
      accentColor: Colors.blue,
      textTheme: GoogleFonts.latoTextTheme(
          ThemeData.light().textTheme
      ),),
      subtitleColor: const Color(0xff8e8e8e),
      ),

  AppTheme.BlueDark: ExtendedTheme(ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue[700],
      toggleableActiveColor: Colors.blue[700],
      accentColor: Colors.blue[700],
      textTheme: GoogleFonts.latoTextTheme(
          ThemeData.dark().textTheme
      ),),
      subtitleColor: const Color(0xffA5A5A5)) //
};