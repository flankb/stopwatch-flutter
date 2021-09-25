import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const GreenLight = 'AppTheme.GreenLight';
const GreenDark = 'AppTheme.GreenDark';
const BlueLight = 'AppTheme.BlueLight';
const BlueDark = 'AppTheme.BlueDark';
const MagentaLight = 'AppTheme.MagentaLight';
const MagentaDark = 'AppTheme.MagentaDark';

const ColorMagenta = const Color(0xffcc0066);

class AppTheme extends ExtendedTheme {
  final Color shadowColor;
  final buttonPauseColor;
  final subtitleColor;

  AppTheme(ThemeData materialTheme,
      {this.shadowColor = const Color(0xff3F3C3C),
      this.buttonPauseColor = Colors.black,
      this.subtitleColor = const Color(0xffE6E6E6)})
      : super(material: materialTheme);
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
  MagentaLight: AppTheme(
      baseTheme.copyWith(
        primaryColor: ColorMagenta,
        toggleableActiveColor: ColorMagenta,
        focusColor: ColorMagenta,
        accentColor: ColorMagenta,
      ),
      subtitleColor: const Color(0xff8e8e8e)),

  MagentaDark: AppTheme(
      baseThemeDark.copyWith(
        primaryColor: ColorMagenta,
        toggleableActiveColor: ColorMagenta,
        focusColor: ColorMagenta,
        accentColor: ColorMagenta,
      ),
      subtitleColor: const Color(0xffA5A5A5)),

  GreenLight: AppTheme(
      baseTheme.copyWith(
        primaryColor: Colors.green,
        toggleableActiveColor: Colors.green,
        focusColor: Colors.green,
        accentColor: Colors.green,
      ),
      subtitleColor: const Color(0xff8e8e8e)),

  GreenDark: AppTheme(
      baseThemeDark.copyWith(
        primaryColor: Colors.green[700],
        accentColor: Colors.green[700],
        toggleableActiveColor: Colors.green[700],
        focusColor: Colors.green[700],
      ),
      subtitleColor: const Color(0xffA5A5A5)),

  BlueLight: AppTheme(
    baseTheme.copyWith(
      primaryColor: Colors.blue,
      toggleableActiveColor: Colors.blue,
      accentColor: Colors.blue,
    ),
    subtitleColor: const Color(0xff8e8e8e),
  ),

  BlueDark: AppTheme(
      baseThemeDark.copyWith(
        primaryColor: Colors.blue[700],
        toggleableActiveColor: Colors.blue[700],
        accentColor: Colors.blue[700],
      ),
      subtitleColor: const Color(0xffA5A5A5)) //
};
