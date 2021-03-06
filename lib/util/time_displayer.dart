import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stopwatch/generated/l10n.dart';

String formatDate(DateTime date, {required BuildContext context}) {
  final myLocale = Localizations.localeOf(context);
  return DateFormat.yMMMMd(myLocale.languageCode).add_Hm().format(date);
}

// Сотые секунды
String formatMills(Duration d) => d.toString().split('.')[1].substring(0, 2);

String formatAllBeautiful(Duration d) => '${formatBase(d)},${formatMills(d)}';

String formatAllBeautifulFromMills(int mills) {
  final d = Duration(milliseconds: mills);
  return formatAllBeautiful(d);
}

String formatBase(Duration d) {
  if (d.inMinutes < 60) {
    final base = d.toString().split('.').first.padLeft(8, '0');
    return base.substring(3, 8);
  } else if (d.inHours < 24) {
    final base = d.toString().split('.').first.padLeft(8, '0');
    return base;
  } else {
    final base = d.toString().split('.').first;
    final end = base.substring(base.length - 5, base.length);

    final days = d.inHours ~/ 24;
    final hours = d.inHours - days * 24;

    return "$days.${hours.toString().padLeft(2, '0')}:$end";
  }
}

String humanFormat(Duration d) {
  var time = formatBase(d);
  // "00:02,05"
  // После чего разворошить строку регэкспами и вставить текст в нужные места

  //var time = "12.20:03:01,34";
  //var time = "03:01,34";
  //var timeDays = "12.20:03:01,34";
  final stringBuffer = StringBuffer();

  if (time.contains('.')) {
    final splittingDays = time.split('.');
    final days = splittingDays[0];

    stringBuffer.write('$days ${S.current.days} ');

    time = splittingDays[1];
  }

  final array = time.split(',')[0].split(':');

  final tokens = <String>[];

  array.reversed.toList().asMap().forEach((index, value) {
    switch (index) {
      case 0:
        tokens.add('$value ${S.current.seconds}');
        break;
      case 1:
        tokens.add('$value ${S.current.minutes}');
        break;
      case 2:
        tokens.add('$value ${S.current.hours}');
        break;
    }
  });

  for (final t in tokens.reversed) {
    stringBuffer.write('$t ');
  }

  return stringBuffer.toString();
}
