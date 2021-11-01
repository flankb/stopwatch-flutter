import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

Future<bool> existsMeasure(
    StopwatchFakeRepository repository, StopwatchStatus status) async {
  final measures =
      await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.length > 0;
}

void main() {
  group('MeasureBloc', () {
    late MeasureBloc measureBloc;
    late StopwatchFakeRepository repository;

    setUp(() {
      repository = StopwatchFakeRepository();
      measureBloc = MeasureBloc(Ticker3(), repository);
    });

    tearDown(() {
      measureBloc.close();
    });

    test('Initial state test', () {
      expect(measureBloc.state is MeasureUpdatingState, equals(true));
    });

    blocTest<MeasureBloc, MeasureState>(
        'emit Measure Events should change state', build: () {
      return measureBloc;
    }, act: (bloc) async {
      bloc
        ..add(MeasureOpenedEvent())
        ..add(MeasureStartedEvent());

      await Future.delayed(Duration(seconds: 1));
      bloc.add(LapAddedEvent());

      await Future.delayed(Duration(seconds: 1));
      bloc
        ..add(MeasurePausedEvent())
        ..add(MeasureFinishedEvent(true));
    }, verify: (bloc) async {
      debugPrint('VERIFY');
    }, expect: () {
      // final measureViewModel =
      //     MeasureViewModel(lastRestartedOverall: DateTime.now());
      // final updatingState = MeasureUpdatingState(measureViewModel);
      // final readyState = MeasureReadyState(measureViewModel);

      //final startedState = MeasureStartedState();
      //       MeasureUpdatingState:MeasureUpdatingState(MeasureViewModel{id: null, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: null, status: StopwatchStatus.Ready}),
      //       MeasureReadyState:MeasureReadyState(MeasureViewModel{id: null, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: null, status: StopwatchStatus.Ready}),
      //       MeasureUpdatingState:MeasureUpdatingState(MeasureViewModel{id: null, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: null, status: StopwatchStatus.Ready}),
      //       MeasureStartedState:MeasureStartedState(MeasureViewModel{id: 1858, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Started}),
      //       MeasureUpdatingState:MeasureUpdatingState(MeasureViewModel{id: 1858, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Started}),
      //       MeasureStartedState:MeasureStartedState(MeasureViewModel{id: 1858, comment: null,  elapsed: 987, elapsedLap: 0, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Started}),
      //       MeasureUpdatingState:MeasureUpdatingState(MeasureViewModel{id: 1858, comment: null,  elapsed: 987, elapsedLap: 0, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Started}),
      //       MeasurePausedState:MeasurePausedState(MeasureViewModel{id: 1858, comment: null,  elapsed: 1998, elapsedLap: 1010, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Paused}),
      //       MeasureUpdatingState:MeasureUpdatingState(MeasureViewModel{id: 1858, comment: null,  elapsed: 1998, elapsedLap: 1010, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Paused}),
      //       MeasureFinishedState:MeasureFinishedState(MeasureViewModel{id: 1858, comment: null,  elapsed: 1998, elapsedLap: 1010, dateCreated: 2021-11-01 12:57:12.704755, status: StopwatchStatus.Finished}),
      //       MeasureReadyState:MeasureReadyState(MeasureViewModel{id: null, comment: null,  elapsed: 0, elapsedLap: 0, dateCreated: null, status: StopwatchStatus.Ready})

      return [
        isA<MeasureUpdatingState>(),
        isA<MeasureReadyState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureStartedState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureStartedState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasurePausedState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureFinishedState>(),
        isA<MeasureReadyState>(),
      ];
    });

    blocTest<MeasureBloc, MeasureState>('full measure bloc test',
        build: () {
          return measureBloc;
        },
        act: (bloc) async {
          bloc.add(MeasureOpenedEvent());

          measureBloc.add(MeasureOpenedEvent());
          measureBloc.add(MeasureStartedEvent());

          await Future.delayed(Duration(seconds: 1));
          measureBloc.add(LapAddedEvent());

          await Future.delayed(Duration(seconds: 1));
          measureBloc.add(MeasurePausedEvent());
          measureBloc.add(MeasureFinishedEvent(true));
        },
        expect: () => [
              isA<MeasureUpdatingState>(),
              isA<MeasureReadyState>(),
              isA<MeasureUpdatingState>(),
              isA<MeasureReadyState>(),
              isA<MeasureUpdatingState>(),
              isA<MeasureStartedState>(),
              isA<MeasureUpdatingState>(),
              isA<MeasureStartedState>(),
              isA<MeasureUpdatingState>(),
              isA<MeasurePausedState>(),
              isA<MeasureUpdatingState>(),
              isA<MeasureFinishedState>(),
              isA<MeasureReadyState>(),
            ]);

    // test("Full measure bloc test", () async {
    //   // https://stackoverflow.com/questions/42611880/difference-between-await-for-and-listen-in-dart/42613676
    //   // https://pub.dev/packages/fake_async
    //   // https://stackoverflow.com/questions/56621534/how-to-unit-test-stream-listen-in-dart

    //   // flutter test wait for stream
    //   // https://stackoverflow.com/questions/55830800/placing-two-yields-next-to-each-other-in-dart-flutter-only-the-second-get-e

    //   final _testController = StreamController<bool>();
    //   int counterStates = 0;

    //   measureBloc.listen((state) async {
    //     debugPrint("Listened: " + state.toString());
    //     final measure = state.measure;

    //     switch (counterStates) {
    //       case 4:
    //         // В базе есть измерение со статусом Started
    //         final startedExists =
    //             await existsMeasure(repository, StopwatchStatus.Started);
    //         expect(startedExists, true,
    //             reason: "В базе нет измерения со статусом Started");

    //         // В базе появилась измерительная сессия
    //         final existsSessions =
    //             (await repository.getMeasureSessions(measure.id!)).length > 0;
    //         expect(existsSessions, true,
    //             reason: "В базе не появилось измерительных сессий");
    //         break;
    //       case 6:
    //         // Есть круг
    //         final existsLaps =
    //             (await repository.getLapsByMeasureAsync(measure.id!))
    //                 .any((element) => true);
    //         expect(existsLaps, true, reason: "Нет кругов");
    //         break;
    //       case 8:
    //         // В базе есть измерение в статусе Paused
    //         final pausedExists =
    //             await existsMeasure(repository, StopwatchStatus.Paused);
    //         expect(pausedExists, true,
    //             reason: "В базе нет измерение в статусе Paused"); //TODO !!!!

    //         // elapsed > 2 секунд
    //         final measureElapsed =
    //             measure.elapsed >= 1900 && measure.elapsedLap >= 1000;
    //         expect(measureElapsed, true, reason: "Время не обновилось");
    //         break;
    //       case 10:
    //         // В базе есть финишированное измерение
    //         final finishExists =
    //             await existsMeasure(repository, StopwatchStatus.Finished);
    //         expect(finishExists, true,
    //             reason: "В базе нет финишированных измерений"); //TODO !!!!!
    //         break;
    //     }

    //     /*
    //     Listened: MeasureUpdatingState 0

    //     //MeasureOpenedEvent
    //     Listened: MeasureUpdatingState
    //     Listened: MeasureReadyState

    //     //MeasureStartedEvent
    //     Listened: MeasureUpdatingState
    //     Listened: MeasureStartedState 4

    //     //LapAddedEvent
    //     Listened: MeasureUpdatingState
    //     Listened: MeasureStartedState 6

    //     //MeasurePausedEvent
    //     Listened: MeasureUpdatingState
    //     Listened: MeasurePausedState 8

    //     //MeasureFinishedEvent
    //     Listened: MeasureUpdatingState
    //     Listened: MeasureReadyState 10
    //      */

    //     // Проверим, что есть измерение со статусом Finished
    //     final finished =
    //         await existsMeasure(repository, StopwatchStatus.Finished);
    //     if (finished && !_testController.isClosed) {
    //       _testController.add(true);
    //       _testController.close();
    //     }

    //     counterStates++;
    //   });

    //   measureBloc.add(MeasureOpenedEvent());
    //   measureBloc.add(MeasureStartedEvent());

    //   await Future.delayed(Duration(seconds: 1));
    //   measureBloc.add(LapAddedEvent());

    //   await Future.delayed(Duration(seconds: 1));
    //   measureBloc.add(MeasurePausedEvent());
    //   measureBloc.add(MeasureFinishedEvent(true));

    //   expectLater(_testController.stream, emits(true));
    // });

    blocTest<MeasureBloc, MeasureState>(
      'States flow',
      build: () => measureBloc,
      skip: 0,
      wait: Duration(seconds: 0),
      act: (bloc) async {
        bloc.add(MeasureOpenedEvent());
        bloc.add(MeasureStartedEvent());
        bloc.add(MeasurePausedEvent());
      },
      verify: (bloc) async {},
      expect: () => [
        isA<MeasureUpdatingState>(),
        isA<MeasureReadyState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureStartedState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasurePausedState>(),
      ],
    );
  });
}
