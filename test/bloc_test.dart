
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

void main() {
  group('MeasureBloc', () {
    MeasureBloc measureBloc;



    setUp(() {
      measureBloc = MeasureBloc(Ticker3(), StopwatchFakeRepository());



    });

    test('StopwatchFakeRepository test', () async {
      final fakeRep = StopwatchFakeRepository();

      expect((await fakeRep.getMeasuresByStatusAsync("")), equals(null));
    });

  });
}