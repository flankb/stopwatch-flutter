import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/util/time_displayer.dart';

void main(){
  group("Time displayer test group", (){
    test('Time displayer tests', () {
      final d1 = Duration(milliseconds: 23456);
      final d2 = Duration(milliseconds: 1004596);
      final d3 = Duration(milliseconds: 10046);
      final d4 = Duration(milliseconds: 100);
      final d5 = Duration(milliseconds: 12000456);

      final t1 = TimeDisplayer.formatBase(d1);
      final t2 = TimeDisplayer.formatAllBeautiful(d2);
      final t3 = TimeDisplayer.formatMills(d3);
      final t4 = TimeDisplayer.formatAllBeautifulFromMills(234080980);
      final t5 = TimeDisplayer.formatAllBeautiful(d4);
      final t6 = TimeDisplayer.formatAllBeautiful(d5);

      final list = [t1, t2, t3, t4, t5, t6];
      final texts = ["00:23", "16:44,59", "04", "2.17:01:20,98", "00:00,10", "03:20:00,45"];

      list.asMap().forEach((index, value) {
        expect(value, equals(texts[index]), reason: "Неверное представление $value");
      });
    });

  });
}