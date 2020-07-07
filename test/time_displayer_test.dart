

import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/util/time_displayer.dart';

void main(){
  group("Time displayer test", (){

    test('Time displayer tests', () {
      final d1 = Duration(milliseconds: 23456);
      final d2 = Duration(milliseconds: 1004596);

      final d3 = Duration(milliseconds: 10046);

      final d4 = Duration(milliseconds: 100);

      final d5 = Duration(milliseconds: 12000456);

      final t1 = TimeDisplayer.formatBase(d1);

    });

  });
}