import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/util/time_displayer.dart';

void main() {
  group('Time displayer test group', () {
    test('Time displayer tests', () {
      const d1 = Duration(milliseconds: 23456);
      const d2 = Duration(milliseconds: 1004596);
      const d3 = Duration(milliseconds: 10046);
      const d4 = Duration(milliseconds: 100);
      const d5 = Duration(milliseconds: 12000456);

      final t1 = formatBase(d1);
      final t2 = formatAllBeautiful(d2);
      final t3 = formatMills(d3);
      final t4 = formatAllBeautifulFromMills(234080980);
      final t5 = formatAllBeautiful(d4);
      final t6 = formatAllBeautiful(d5);

      final list = [t1, t2, t3, t4, t5, t6];
      final texts = [
        '00:23',
        '16:44,59',
        '04',
        '2.17:01:20,98',
        '00:00,10',
        '03:20:00,45'
      ];

      list.asMap().forEach((index, value) {
        expect(
          value,
          equals(texts[index]),
          reason: 'Неверное представление $value',
        );
      });
    });
  });
}
