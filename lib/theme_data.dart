import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const greenLight = 'AppTheme.GreenLight';
const greenDark = 'AppTheme.GreenDark';
const blueLight = 'AppTheme.BlueLight';
const blueDark = 'AppTheme.BlueDark';
const magentaLight = 'AppTheme.MagentaLight';
const magentaDark = 'AppTheme.MagentaDark';

const colorMagenta = Color(0xffcc0066);

class AppTheme extends ExtendedTheme {
  final Color shadowColor;
  final Color buttonPauseColor;
  final Color subtitleColor;

  AppTheme(ThemeData materialTheme,
      {this.shadowColor = const Color(0xff3F3C3C),
      this.buttonPauseColor = Colors.black,
      this.subtitleColor = const Color(0xffE6E6E6),})
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
  magentaLight: AppTheme(
    baseTheme.copyWith(
      primaryColor: colorMagenta,
      toggleableActiveColor: colorMagenta,
      focusColor: colorMagenta,
      colorScheme: baseTheme.colorScheme.copyWith(secondary: colorMagenta),
    ),
    subtitleColor: const Color(0xff8e8e8e),
  ),

  magentaDark: AppTheme(
    baseThemeDark.copyWith(
      primaryColor: colorMagenta,
      toggleableActiveColor: colorMagenta,
      focusColor: colorMagenta,
      colorScheme: baseTheme.colorScheme.copyWith(secondary: colorMagenta),
    ),
    subtitleColor: const Color(0xffA5A5A5),
  ),

  greenLight: AppTheme(
    baseTheme.copyWith(
      primaryColor: Colors.green,
      toggleableActiveColor: Colors.green,
      focusColor: Colors.green,
      colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.green),
    ),
    subtitleColor: const Color(0xff8e8e8e),
  ),

  greenDark: AppTheme(
    baseThemeDark.copyWith(
      primaryColor: Colors.green[700],
      colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.green[700]),
      toggleableActiveColor: Colors.green[700],
      focusColor: Colors.green[700],
    ),
    subtitleColor: const Color(0xffA5A5A5),
  ),

  blueLight: AppTheme(
    baseTheme.copyWith(
      primaryColor: Colors.blue,
      toggleableActiveColor: Colors.blue,
      colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.blue),
    ),
    subtitleColor: const Color(0xff8e8e8e),
  ),

  blueDark: AppTheme(
    baseThemeDark.copyWith(
      primaryColor: Colors.blue[700],
      toggleableActiveColor: Colors.blue[700],
      colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.blue[700]),
    ),
    subtitleColor: const Color(0xffA5A5A5),
  ) //
};
