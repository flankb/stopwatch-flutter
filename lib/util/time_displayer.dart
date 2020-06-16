class TimeDisplayer {
  static int dayMills = 24 * 3600 * 1000;

  // Часы
  //static format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  // Сотые секунды
  static formatMills(Duration d) => d.toString().split('.')[1].substring(0,2);

  // Сотые секунды
  //static formatMills(Duration d) => ((d.inSeconds % 1000) / 1000).toStringAsFixed(2).substring(1,4); // final f = (d % 1000) / 1000;

  //static formatAll(Duration d) => d.toString();

  static formatAllBeautiful(Duration d) => "${format2(d)},${formatMills(d)}";

  //static format2(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  static String format2(Duration d){
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


  static String toHumanString(int milliseconds) {
    /*if (milliseconds < dayMills) {

    }
    else {

    }*/

    // Duration to string:
    // 48:00:00.000000

    //https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
  }

  // int get inSeconds => _duration ~/ Duration.microsecondsPerSecond;
  // https://api.flutter.dev/flutter/dart-core/num/operator_modulo.html
  // Trancate:
  // https://api.flutter.dev/flutter/dart-core/double/operator_truncate_divide.html
  // https://api.flutter.dev/flutter/intl/NumberFormat-class.html
  // https://pub.dev/packages/sprintf
  // https://flutterigniter.com/how-to-format-duration/

  /*
  #region Отображение времени
        void DisplayWithHoursTime()
        {
            var elapsedTime = _api.MeasureState.ElapsedTime;

            tbTime.Text = string.Format("{0:D2}:{1:D2}:{2:D2}", elapsedTime.Hours, elapsedTime.Minutes, elapsedTime.Seconds);
            tbMillisecondsTime.Text = string.Format("{0}{1:D2}", _decimalSeparator, elapsedTime.Milliseconds / 10);

            DisplayLap();
        }

        void DisplayWithDaysTime()
        {
            var elapsedTime = _api.MeasureState.ElapsedTime;

            tbTime.Text = $"{elapsedTime.Days:D2}.{elapsedTime.Hours:D2}:{elapsedTime.Minutes:D2}:{elapsedTime.Seconds:D2}";
            tbMillisecondsTime.Text = string.Format("{0}{1:D2}", _decimalSeparator, elapsedTime.Milliseconds / 10);

            DisplayLap();
        }

        void DisplayTime()
        {
            var elapsedTime = _api.MeasureState.ElapsedTime;

            tbTime.Text = string.Format("{0:D2}:{1:D2}", elapsedTime.Minutes, elapsedTime.Seconds);
            tbMillisecondsTime.Text = string.Format("{0}{1:D2}", _decimalSeparator, elapsedTime.Milliseconds / 10);

            DisplayLap();
        }
        #endregion
   */
}