import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
  MagentaLight,
  MagentaDark
}

const GreenLight = 'AppTheme.GreenLight';
const GreenDark = 'AppTheme.GreenDark';
const BlueLight = 'AppTheme.BlueLight';
const BlueDark = 'AppTheme.BlueDark';
const MagentaLight = 'AppTheme.MagentaLight';
const MagentaDark = 'AppTheme.MagentaDark';

class ExtendedTheme {
  final ThemeData materialTheme;
  final Color shadowColor;
  final buttonPauseColor;
  final subtitleColor;

  ExtendedTheme(this.materialTheme,
      {this.shadowColor = const Color(0xff3F3C3C),
      this.buttonPauseColor = Colors.black,
      this.subtitleColor = const Color(0xffE6E6E6)});
}

ThemeData baseTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme),

  // GoogleFonts.getFont('Lato')
);

ThemeData baseThemeDark = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
);

final appThemeData = {
  AppTheme.MagentaLight: ExtendedTheme(
      baseTheme.copyWith(
        primaryColor: const Color(0xffcc0066),
        toggleableActiveColor: const Color(0xffcc0066),
        focusColor: const Color(0xffcc0066),
        accentColor: const Color(0xffcc0066),
      ),
      subtitleColor: const Color(0xff8e8e8e)),

  AppTheme.MagentaDark: ExtendedTheme(
      baseThemeDark.copyWith(
        primaryColor: const Color(0xffcc0066),
        toggleableActiveColor: const Color(0xffcc0066),
        focusColor: const Color(0xffcc0066),
        accentColor: const Color(0xffcc0066),
      ),
      subtitleColor: const Color(0xffA5A5A5)),

  AppTheme.GreenLight: ExtendedTheme(
      baseTheme.copyWith(
        primaryColor: Colors.green,
        toggleableActiveColor: Colors.green,
        focusColor: Colors.green,
        accentColor: Colors.green,
      ),
      subtitleColor: const Color(0xff8e8e8e)),

  AppTheme.GreenDark: ExtendedTheme(
      baseThemeDark.copyWith(
        primaryColor: Colors.green[700],
        accentColor: Colors.green[700],
        toggleableActiveColor: Colors.green[700],
        focusColor: Colors.green[700],
      ),
      subtitleColor: const Color(0xffA5A5A5)),

  AppTheme.BlueLight: ExtendedTheme(
    baseTheme.copyWith(
      primaryColor: Colors.blue,
      toggleableActiveColor: Colors.blue,
      accentColor: Colors.blue,
    ),
    subtitleColor: const Color(0xff8e8e8e),
  ),

  AppTheme.BlueDark: ExtendedTheme(
      baseThemeDark.copyWith(
        primaryColor: Colors.blue[700],
        toggleableActiveColor: Colors.blue[700],
        accentColor: Colors.blue[700],
      ),
      subtitleColor: const Color(0xffA5A5A5)) //
};
