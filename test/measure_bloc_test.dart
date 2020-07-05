import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

Future<bool> existsMeasure(StopwatchFakeRepository repository, StopwatchStatus status) async {
  final measures = await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.length > 0;
}

void main() {
  group('MeasureBloc', () {
    MeasureBloc measureBloc;
    StopwatchFakeRepository repository;

    setUp(() {
      repository = StopwatchFakeRepository();
      measureBloc = MeasureBloc(Ticker3(), repository);
    });

    tearDown(() {
      measureBloc?.close();
    });

    test('Initial state test', () {
      final initialState = MeasureUpdatingState(MeasureViewModel());
      expect(measureBloc.initialState.props[0].toString(), initialState.props[0].toString());
    });

    //expectLater(actual, matcher) // TODO Асинхронный expect

    test("Full measure bloc test", () async {
      // https://stackoverflow.com/questions/42611880/difference-between-await-for-and-listen-in-dart/42613676
      // https://pub.dev/packages/fake_async
      // https://stackoverflow.com/questions/56621534/how-to-unit-test-stream-listen-in-dart

      // flutter test wait for stream
      // https://stackoverflow.com/questions/55830800/placing-two-yields-next-to-each-other-in-dart-flutter-only-the-second-get-e

      final _testController = StreamController<bool>();
      int counterStates = 0;

      measureBloc.listen((state) async {
        debugPrint("Listened: " + state.toString());
        final measure = state.measure;

        switch(counterStates){
          case 3:
            // В базе есть измерение со статусом Started
            final startedExists = await existsMeasure(repository, StopwatchStatus.Started);
            expect(startedExists, true, reason: "В базе нет измерения со статусом Started");

            // В базе появилась измерительная сессия
            final existsSessions = (await repository.getMeasureSessions(measure.id)).length > 0;
            expect(existsSessions, true, reason: "В базе не появилось измерительных сессий");
            break;
          case 5:
            // Есть круг
            final existsLaps = (await repository.getLapsByMeasureAsync(measure.id)).any((element) => true);
            expect(existsLaps, true, reason : "Нет кругов");
            break;
          case 7:
            // В базе есть измерение в статусе Paused
            final pausedExists = await existsMeasure(repository, StopwatchStatus.Paused);
            expect(pausedExists, true, reason : "В базе нет измерение в статусе Paused"); //TODO !!!!

            // elapsed > 2 секунд
            final measureElapsed = measure.elapsed >= 1990 && measure.elapsedLap >= 1000;
            expect(measureElapsed, true, reason: "Время не обновилось");
            break;
          case 8:
            // В базе есть финишированное измерение
            final finishExists = await existsMeasure(repository, StopwatchStatus.Finished);
            expect(finishExists, true, reason: "В базе нет финишированных измерений"); //TODO !!!!!
            break;
        }

        /*
        Listened: MeasureUpdatingState
        Listened: MeasureReadyState

        //MeasureStartedEvent
        Listened: MeasureUpdatingState
        Listened: MeasureStartedState

        //Lap Added
        Listened: MeasureUpdatingState
        Listened: MeasureStartedState

        //MeasurePausedEvent
        Listened: MeasureUpdatingState
        Listened: MeasurePausedState

        //MeasureFinishedEvent
        Listened: MeasureUpdatingState
        Listened: MeasureReadyState
         */

        // Проверим, что есть измерение со статусом Finished
        final finished = await existsMeasure(repository, StopwatchStatus.Finished);
        if (finished && !_testController.isClosed) {
          _testController.add(true);
          _testController.close();
        }

        counterStates++;
      });

      measureBloc.add(MeasureOpenedEvent());
      measureBloc.add(MeasureStartedEvent());

      await Future.delayed(Duration(seconds: 1));
      measureBloc.add(LapAddedEvent());

      await Future.delayed(Duration(seconds: 1));
      measureBloc.add(MeasurePausedEvent());
      measureBloc.add(MeasureFinishedEvent(true));

      expectLater(_testController.stream, emits(true));
    });

    blocTest(
      'States flow',
      build: () async => measureBloc,
      wait: Duration(seconds: 0),
      act: (bloc) async {
        bloc.add(MeasureOpenedEvent());
        bloc.add(MeasureStartedEvent());
        bloc.add(MeasurePausedEvent());
        /*bloc.add(MeasureOpenedEvent());
        bloc.add(MeasureStartedEvent());
        bloc.add(MeasurePausedEvent());*/
      },
      verify: (bloc) async {
        //debugPrint("Test state ${(bloc as MeasureBloc).state}"); // Последне состояние
        //expect((bloc as MeasureBloc).state is MeasureReadyState , equals(true));
      },
      expect: [
        isA<MeasureReadyState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureStartedState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasurePausedState>(),
      ],
    );
  });
}
