import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/util/ticker.dart';

import 'fake_repos.dart';

Future<bool> existsMeasure(
  StopwatchFakeRepository repository,
  StopwatchStatus status,
) async {
  final measures =
      await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.isNotEmpty;
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
      'emit Measure Events should change state',
      build: () => measureBloc,
      act: (bloc) async {
        bloc
          ..add(MeasureOpenedEvent())
          ..add(MeasureStartedEvent());

        await Future<void>.delayed(const Duration(seconds: 1));
        bloc.add(LapAddedEvent());

        await Future<void>.delayed(const Duration(seconds: 1));
        bloc
          ..add(MeasurePausedEvent())
          ..add(MeasureFinishedEvent(saveMeasure: true));
      },
      verify: (bloc) async {
        debugPrint('VERIFY');
      },
      expect: () => [
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
      ],
    );

    blocTest<MeasureBloc, MeasureState>(
      'full measure bloc test',
      build: () => measureBloc,
      act: (bloc) async {
        bloc.add(MeasureOpenedEvent());

        measureBloc
          ..add(MeasureOpenedEvent())
          ..add(MeasureStartedEvent());

        await Future<void>.delayed(const Duration(seconds: 1));
        measureBloc.add(LapAddedEvent());

        await Future<void>.delayed(const Duration(seconds: 1));
        measureBloc
          ..add(MeasurePausedEvent())
          ..add(MeasureFinishedEvent(saveMeasure: true));
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
      ],
    );

    blocTest<MeasureBloc, MeasureState>(
      'measure bloc started test',
      build: () => measureBloc,
      act: (bloc) async {
        bloc
          ..add(MeasureOpenedEvent())
          ..add(MeasureStartedEvent());
      },
      verify: (bloc) async {
        final measure = bloc.state.measure;

        final startedExists =
            await existsMeasure(repository, StopwatchStatus.Started);
        expect(
          startedExists,
          true,
          reason: 'В базе нет измерения со статусом Started',
        );

        // В базе появилась измерительная сессия
        final existsSessions =
            (await repository.getMeasureSessions(measure.id!)).isNotEmpty;
        expect(
          existsSessions,
          true,
          reason: 'В базе не появилось измерительных сессий',
        );

        expect(measure.status, StopwatchStatus.Started);
        expect(measure.sessions.isNotEmpty, true);
      },
      expect: () => [
        isA<MeasureUpdatingState>(),
        isA<MeasureReadyState>(),
        isA<MeasureUpdatingState>(),
        isA<MeasureStartedState>()
      ],
    );

    blocTest<MeasureBloc, MeasureState>(
      'measure bloc exists laps test',
      build: () => measureBloc,
      act: (bloc) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        bloc.add(LapAddedEvent());
      },
      seed: () => MeasureStartedState(
        MeasureViewModel(
          id: 1,
          lastRestartedOverall: DateTime.now(),
          status: StopwatchStatus.Started,
        ),
      ),
      verify: (bloc) async {
        final existsLaps = (bloc.state.measure.laps).any((element) => true);

        expect(existsLaps, true, reason: 'Нет кругов');
      },
      expect: () => [isA<MeasureUpdatingState>(), isA<MeasureStartedState>()],
    );

    blocTest<MeasureBloc, MeasureState>(
      'measure bloc paused test',
      build: () {
        repository = StopwatchFakeRepository(preBuild: true);
        return MeasureBloc(Ticker3(), repository);
      },
      act: (bloc) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        bloc.add(MeasurePausedEvent());
      },
      seed: () {
        final dateNow = DateTime.now();

        return MeasureStartedState(
          MeasureViewModel(
            id: 2,
            lastRestartedOverall: dateNow,
            dateStarted: dateNow,
            status: StopwatchStatus.Started,
            laps: [
              LapViewModel(
                measureId: 2,
                id: 1,
                order: 0,
              )
            ],
            sessions: [
              MeasureSessionViewModel(measureId: 2, id: 1, startedOffset: 0)
            ],
          ),
        );
      },
      verify: (bloc) async {
        final measure = bloc.state.measure;
        // В базе есть измерение в статусе Paused
        final pausedExists =
            await existsMeasure(repository, StopwatchStatus.Paused);
        expect(
          pausedExists,
          true,
          reason: 'В базе нет измерение в статусе Paused',
        );

        // elapsed > 2 секунд
        final measureElapsed =
            measure.elapsed >= 1900 && measure.elapsedLap >= 1000;
        expect(measureElapsed, true, reason: 'Время не обновилось');
      },
      expect: () => [isA<MeasureUpdatingState>(), isA<MeasurePausedState>()],
    );

    blocTest<MeasureBloc, MeasureState>(
      'measure bloc finish test',
      build: () {
        repository = StopwatchFakeRepository(preBuild: true);
        return MeasureBloc(Ticker3(), repository);
      },
      act: (bloc) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        bloc.add(MeasureFinishedEvent(saveMeasure: true));
      },
      seed: () => MeasureStartedState(
        MeasureViewModel(
          id: 2,
          lastRestartedOverall: DateTime.now(),
          status: StopwatchStatus.Started,
        ),
      ),
      verify: (bloc) async {
        final finishExists =
            await existsMeasure(repository, StopwatchStatus.Finished);
        expect(
          finishExists,
          true,
          reason: 'В базе нет финишированных измерений',
        );
      },
      expect: () => [
        isA<MeasureUpdatingState>(),
        isA<MeasureFinishedState>(),
        isA<MeasureReadyState>(),
      ],
    );

    blocTest<MeasureBloc, MeasureState>(
      'States flow',
      build: () => measureBloc,
      skip: 0,
      wait: Duration.zero,
      act: (bloc) async {
        bloc
          ..add(MeasureOpenedEvent())
          ..add(MeasureStartedEvent())
          ..add(MeasurePausedEvent());
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
