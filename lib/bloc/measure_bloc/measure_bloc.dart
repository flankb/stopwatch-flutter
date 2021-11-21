import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/util/ticker.dart';

import 'measure_event.dart';
import 'measure_state.dart';

class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final Ticker3 _ticker;
  final StopwatchRepository
      _stopwatchRepository; // TODO Заменить на интерфейс репозитория (либо на DI)

  StreamSubscription<int>? _tickerSubscription;
  Stream<int> get tickStream => controller.stream;

  StreamController<int> controller = StreamController<int>();
  MeasureBloc(this._ticker, this._stopwatchRepository)
      : super(MeasureUpdatingState(
            MeasureViewModel(id: null, lastRestartedOverall: DateTime.now())));

  @override
  Stream<MeasureState> mapEventToState(
    MeasureEvent event,
  ) async* {
    debugPrint(
      'Current state ${state.toString()} Bloc event: ${event.toString()}',
    );

    if (event is TickEvent) {
      yield* _mapTickToState(event);
    } else if (event is MeasureOpenedEvent) {
      yield* _mapOpenedToState(event);
    } else if (event is MeasureStartedEvent) {
      yield* _mapStartedToState(event, resume: event.resume);
    } else if (event is MeasurePausedEvent) {
      yield* _mapPausedToState(event);
    } else if (event is MeasureFinishedEvent) {
      yield* _mapFinishedToState(event);
    } else if (event is LapAddedEvent) {
      yield* _mapLapAddedToState(event);
    }
  }

  Stream<MeasureState> _mapOpenedToState(MeasureOpenedEvent event) async* {
    yield MeasureUpdatingState(state.measure);
    // Прочитать измерение с БД со всеми кругами и сессиями
    final measuresStarted = await _stopwatchRepository
        .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Started));
    final measuredPaused = await _stopwatchRepository
        .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Paused));
    final measuredReady = await _stopwatchRepository
        .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));

    final combine = <Measure>[
      ...measuresStarted,
      ...measuredPaused,
      ...measuredReady
    ];

    if (combine.isEmpty) {
      yield MeasureReadyState(
        MeasureViewModel(
          id: null,
          lastRestartedOverall: DateTime.now(),
        ),
      ); // Если в БД ничего нет, то ReadyState
    } else {
      if (combine.length > 1) {
        throw Exception('Не может быть больше одного актуального измерения');
      }

      final measureEntity = combine.single;

      final sessions =
          (await _stopwatchRepository.getMeasureSessions(measureEntity.id))
              .map(MeasureSessionViewModel.fromEntity);

      debugPrint('Restored sessions by Id ${measureEntity.id}: $sessions');

      final laps =
          (await _stopwatchRepository.getLapsByMeasureAsync(measureEntity.id))
              .map((lap) => LapViewModel.fromEntity(lap));

      final measure = MeasureViewModel.fromEntity(combine.single)
          .copyWith(laps: laps.toList(), sessions: sessions.toList());

      debugPrint('Laps added: ${measure.laps.length}');
      for (final element in measure.laps) {
        debugPrint(element.toString());
      }
      debugPrint('Sessions added: ${measure.sessions.length}');
      for (final element in measure.sessions) {
        debugPrint(element.toString());
      }
      debugPrint('Restored measure: ${measure.toString()}');

      if (measure.status == StopwatchStatus.Started) {
        // Если есть в статусе Запущено, то ReadyState, а затем в add(startEvent)
        yield MeasureReadyState(measure);
        add(MeasureStartedEvent(resume: true));
      } else if (measure.status == StopwatchStatus.Paused) {
        // TODO Повнимательнее с паттерном BLoC, нужно очень четко следить за состоянием

        //debugPrint("In Opened before paused: $measure");

        final updatedElapsedsMeasure = _updateElapseds(
          measure,
          DateTime.now(),
        ); //Ticker здесь не инициализирован!!!!
        //debugPrint("Hash code 1: ${measure.hashCode}");
        yield MeasurePausedState(
          updatedElapsedsMeasure,
        ); // Если есть в статусе Пауза, то PausedState
        controller.add(0);
      } else if (measure.status == StopwatchStatus.Ready) {
        yield MeasureReadyState(measure);
      }
    }
  }

  Stream<MeasureState> _mapTickToState(TickEvent tick) async* {
    yield MeasureStartedState(state.measure.copyWith(elapsed: tick.duration));
  }

  Stream<MeasureState> _mapLapAddedToState(LapAddedEvent event) async* {
    if (state is MeasureStartedState) {
      yield MeasureUpdatingState(state.measure);

      final dateNow = DateTime.now();

      final lapProps = state.measure.getCurrentLapDiffAndOverall(dateNow);

      var newLap = LapViewModel(
        id: null,
        measureId: state.measure.id!,
        order: state.measure.laps.length + 1,
        difference: lapProps[0],
        overall: lapProps[1],
      );

      final lapId =
          await _stopwatchRepository.addNewLapAsync(newLap.toEntity());

      newLap = newLap.copyWith(id: lapId);

      final newMeasure = state.measure
          .copyWith(laps: List.from(state.measure.laps)..add(newLap));

      final updatesElapsedsMeasure = _updateElapseds(newMeasure, dateNow);

      debugPrint('Before yield MeasureStartedState(state.measure);');
      yield MeasureStartedState(updatesElapsedsMeasure);
      debugPrint('After yield MeasureStartedState(state.measure);');
    } else {
      throw Exception('Wrong state!');
    }
  }

  Stream<MeasureState> _mapFinishedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState || state is MeasurePausedState) {
      // Не сохранять в БД, если это MeasureFinishedEvent и там указана соотв. настройка
      final nosaveDb = event is MeasureFinishedEvent && !event.saveMeasure;
      yield* _fixStopwatch(StopwatchStatus.Finished,
          finish: event is MeasureFinishedEvent, saveToDatabase: !nosaveDb);
      yield MeasureReadyState(
        MeasureViewModel(lastRestartedOverall: DateTime.now()),
      );
    } else {
      yield MeasureReadyState(
        MeasureViewModel(lastRestartedOverall: DateTime.now()),
      );
      //throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapPausedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState) {
      yield* _fixStopwatch(StopwatchStatus.Paused);
    } else {
      throw Exception('Wrong state!');
    }
  }

  Stream<MeasureState> _mapStartedToState(MeasureEvent event,
      {bool resume = false}) async* {
    if (state is MeasureReadyState || state is MeasurePausedState) {
      yield MeasureUpdatingState(state.measure);
      // Устанавливаем поля в модели, делаем запись в репозитории
      final nowDate = DateTime.now();

      final updateElapsedsMeasure = _updateElapseds(state.measure, nowDate);

      var targetMeasure = updateElapsedsMeasure.copyWith(
          status: StopwatchStatus.Started,
          dateCreated:
              updateElapsedsMeasure.dateStarted == null ? nowDate : null);

      // Если сущности не было, то необходимо создать и получить идентификатор
      if (targetMeasure.id == null) {
        final id = await _stopwatchRepository.createNewMeasureAsync();
        //debugPrint("id ${id.toString()} measureId ${measure.id.toString()}");

        targetMeasure = targetMeasure.copyWith(id: id); //.id = id;
      }

      debugPrint('targetMeasure ${targetMeasure.toString()}');

      if (!resume) {
        final session = MeasureSessionViewModel(
          id: null,
          measureId: targetMeasure.id!,
          startedOffset: targetMeasure.getElapsedSinceStarted(nowDate),
        );

        debugPrint('measureId (not resume) ${session.measureId.toString()}');

        // Если в БД есть такая запись - то обновить, иначе создать новую
        final sessionId =
            await _stopwatchRepository.addNewMeasureSession(session.toEntity());

        final writedSession = session.copyWith(id: sessionId);

        targetMeasure = targetMeasure.copyWith(
            sessions: List.from(targetMeasure.sessions)..add(writedSession));
      }

      _startTicker();

      // Обновить статус измерения в БД, тогда не нужно будет делать событие снэпшота
      await _stopwatchRepository.updateMeasureAsync(targetMeasure.toEntity());

      yield MeasureStartedState(targetMeasure);
    } else {
      throw Exception('Wrong state! $state');
    }
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((event) {
      controller.add(event);
    });
  }

  MeasureViewModel _updateElapseds(MeasureViewModel measure, DateTime nowDate) {
    debugPrint('After _updateElapseds ${measure.toString()}');

    return measure.copyWith(
      lastRestartedOverall: nowDate,
      elapsed: measure.getSumOfElapsed(nowDate),
      elapsedLap: measure.getCurrentLapDiffAndOverall(nowDate)[0],
    );
  }

  Stream<MeasureState> _fixStopwatch(
    StopwatchStatus status, {
    bool finish = false,
    bool saveToDatabase = true,
  }) async* {
    debugPrint('_fixStopwatch before');
    yield MeasureUpdatingState(state.measure.copyWith());
    debugPrint('_fixStopwatch after');

    await _tickerSubscription?.cancel();

    //state.measure.status = status;
    final dateNow = DateTime.now();

    // Завершить последний отрезок
    final lastSession = state.measure.getLastUnfinishedSession()?.copyWith(
        finishedOffset: state.measure.getElapsedSinceStarted(dateNow));

    debugPrint('LastUnfinishedSession: $lastSession');

    if (lastSession == null && !finish) {
      throw Exception('Не обнаружена последняя открытая сессия!');
    }

    debugPrint('LastUnfinishedSession (updated): $lastSession');

    final lastSessIndex = lastSession != null
        ? state.measure.sessions.indexWhere((s) => s.id == lastSession.id)
        : null;

    final updateElapsedsMeasure =
        _updateElapseds(state.measure, dateNow).copyWith(
      status: status,
      sessions: lastSessIndex != null
          ? (List.from(state.measure.sessions)..[lastSessIndex] = lastSession!)
          : null,
    );

    // Обновить измерительную сессию в измерении!
    debugPrint('state.measure after finish: ${state.measure}');

    controller.add(0); // Фиксируем счетчик времени

    if (saveToDatabase) {
      await _stopwatchRepository.updateMeasureAsync(
        updateElapsedsMeasure.toEntity(),
      ); // TODO Было вне условия??

      if (lastSession != null) {
        await _stopwatchRepository.updateMeasureSession(lastSession.toEntity());
      }
    } else {
      await _stopwatchRepository.deleteMeasures([state.measure.id!]);
    }

    if (status == StopwatchStatus.Paused) {
      yield MeasurePausedState(updateElapsedsMeasure);
    } else if (status == StopwatchStatus.Finished) {
      yield MeasureFinishedState(updateElapsedsMeasure);
    }
    debugPrint('fixStopwatch finished');
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
