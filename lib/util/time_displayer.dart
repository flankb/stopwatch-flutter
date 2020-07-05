import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TimeDisplayer {
  static int _dayMills = 24 * 3600 * 1000;

  static String formatDate(DateTime date, {BuildContext context}){
    if (context != null) {
      Locale myLocale = Localizations.localeOf(context);
      return DateFormat.yMMMMd(myLocale.languageCode).add_Hm().format(date);
    }

    return DateFormat("dd-MM-yyyy").format(date);
  }

  // Сотые секунды
  static formatMills(Duration d) => d.toString().split('.')[1].substring(0,2);

  static formatAllBeautiful(Duration d) => "${formatBase(d)},${formatMills(d)}";

  static formatAllBeautifulFromMills(int mills) {
    final d = Duration(milliseconds: mills);
    return formatAllBeautiful(d);
  }



  static String formatBase(Duration d){
    if (d.inMinutes < 60) {
      final base = d.toString().split('.').first.padLeft(8, "0");
      return base.substring(3,8);
    } else if (d.inHours < 24) {
      final base = d.toString().split('.').first.padLeft(8, "0");
      return base;
    } else {
      var base = d.toString().split('.').first;
      final end  = base.substring(base.length - 5, base.length);

      final days = d.inHours ~/ 24;
      final hours = d.inHours - days * 24;

      // final minutes = d.inMinutes - hours * 60; // TODO По-хорошему переделать на такой вариант
      // final seconds = d.inSeconds - minutes * 60;

      return "$days.${hours.toString().padLeft(2,'0')}:$end";
    }
  }
}