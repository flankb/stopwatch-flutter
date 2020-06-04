import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:learnwords/resources/base/base_stopwatch_db_repository.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import 'package:learnwords/util/ticker.dart';

import 'measure_event.dart';
import 'measure_state.dart';


class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final Ticker3 _ticker;
  final StopwatchRepository _stopwatchRepository; // TODO Заменить на интерфейс репозитория (либо на DI)

  StreamSubscription<int> _tickerSubscription;
  //Stream<int> _tickStream;
  Stream<int> get tickStream => controller.stream;

  var controller = new StreamController<int>();


  MeasureBloc(this._ticker, this._stopwatchRepository);

  @override
  MeasureState get initialState => MeasureUpdatingState(MeasureViewModel());

  @override
  Stream<MeasureState> mapEventToState(
    MeasureEvent event,
  ) async* {
    debugPrint("Current state ${state.toString()} Bloc event: ${event.toString()}");

    // Для каждого события что-то делаем и возвращаем состояние
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
    // Прочитать измерение с БД со всеми кругами и сессиями
    final measuresStarted = await _stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Started));
    final measuredPaused = await _stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Paused));
    final measuredReady = await _stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));

    List<Measure> combine = List<Measure>();

    combine.addAll(measuresStarted);
    combine.addAll(measuredPaused);
    combine.addAll(measuredReady);

    if (combine.length == 0) {
      yield MeasureReadyState(MeasureViewModel()); // Если в БД ниче нет, то ReadyState
    }
    else {
      if (combine.length > 1) {
        //-------------
        // Грохнуть лишнее
        //
        await _stopwatchRepository.deleteAllMeasuresDebug();
        //-------------

        throw Exception("Не может быть больше одного актуального измерения");
      }

      final measure = MeasureViewModel.fromEntity(combine.single);
      final sessions = (await _stopwatchRepository.getMeasureSessions(measure.id))
                    .map((_) => MeasureSessionViewModel.fromEntity(_));

      final laps = (await _stopwatchRepository.getLapsByMeasureAsync(measure.id))
                    .map((_) => LapViewModel.fromEntity(_));

      measure.laps.addAll(laps);
      measure.sessions.addAll(sessions);

      if (measure.status == StopwatchStatus.Started) {  // Если есть в статусе Запущено, то ReadyState, а затем в add(startEvent)
        yield MeasureReadyState(measure);
        add(MeasureStartedEvent(resume : true));
      } else if (measure.status == StopwatchStatus.Paused) {
        yield MeasurePausedState(measure);// Если есть в статусе Пауза, то PausedState
      }
    }
  }

  Stream<MeasureState> _mapTickToState(TickEvent tick) async* {
    state.measure.elapsed = tick.duration; // TODO ?????
    yield MeasureStartedState(state.measure);
  }

  Stream<MeasureState> _mapLapAddedToState(LapAddedEvent event) async* {
    if (state is MeasureStartedState) {
      yield MeasureUpdatingState(state.measure);
      // Сбросить счётчик времени круга
      state.measure.elapsedLap = 0;

      final lapProps = state.measure.getCurrentLapDiffAndOverall(DateTime.now());

      LapViewModel newLap = LapViewModel();
      newLap.measureId = state.measure.id;
      newLap.order = state.measure.laps.length + 1;
      newLap.difference = lapProps[0];
      newLap.overall = lapProps[1];
      newLap.comment = "Temp";

      state.measure.laps.add(newLap);
      newLap.id = await _stopwatchRepository.addNewLapAsync(newLap.toEntity());

      debugPrint("Before yield MeasureStartedState(state.measure);");
      yield MeasureStartedState(state.measure);
      debugPrint("After yield MeasureStartedState(state.measure);");
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapFinishedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState || state is MeasurePausedState) {
      yield* _fixStopwatch(StopwatchStatus.Finished, finish : event is MeasureFinishedEvent);
      yield MeasureReadyState(MeasureViewModel());
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapPausedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState) {
      yield* _fixStopwatch(StopwatchStatus.Paused);
      yield MeasurePausedState(state.measure);
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapStartedToState(MeasureEvent event, {bool resume = false}) async* {
    if (state is MeasureReadyState || state is MeasurePausedState) {
      yield MeasureUpdatingState(state.measure);
      // Устанавливаем поля в модели, делаем запись в репозитории
      state.measure.status = StopwatchStatus.Started;
      final nowDate = DateTime.now();

      if (state.measure.dateCreated == null) {
        state.measure.dateCreated = nowDate;
      }

      state.measure.lastRestartedOverall = nowDate;
      //state.measure.lastRestartedLap = nowDate;

      var targetMeasure = state.measure;

      debugPrint("targetMeasure ${targetMeasure.toString()}");

      // Если сущности не было, то необходимо создать и получить идентификатор
      if (targetMeasure.id == null) {
        final id = await _stopwatchRepository.createNewMeasureAsync();
        final measure = (await _stopwatchRepository.getMeasuresByIdAsync(id)).single;

        debugPrint("id ${id.toString()} measureId ${measure.id.toString()}");

        targetMeasure = MeasureViewModel.fromEntity(measure);
      }

      if (!resume) {

        // TODO Здесь не должно быть открытых измерительных сессий!!!
        // Удалим здесь все незавершённые сессии!
        //debugPrint()
        //final unfinishedSessions = targetMeasure.sessions.where((element) => element.finished == null);
        //await _stopwatchRepository.

        final session = MeasureSessionViewModel(id: null, measureId: targetMeasure.id, started: nowDate); // TODO id здесь пустой
        targetMeasure.sessions.add(session);

        debugPrint("measureId (not resume) ${session.measureId.toString()}");

        // Если в БД есть такая запись - то обновить, иначе создать новую
        //state.measure.id = await _stopwatchRepository.updateMeasureAsync(state.measure.toEntity());
        session.id = await _stopwatchRepository.addNewMeasureSession(session.toEntity());
      }

      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.tick().listen((event) { controller.add(event);} );

      //.tick(ticks: state.measure.elapsed)
      //.listen((duration) => add(TickEvent(duration)));

      yield MeasureStartedState(targetMeasure);
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _fixStopwatch(StopwatchStatus status, {bool finish = false}) async* {
    debugPrint("_fixStopwatch before");
    yield MeasureUpdatingState(state.measure);
    debugPrint("_fixStopwatch after");

    await _tickerSubscription?.cancel();

    //await controller.sink.close();
    //await controller.close();

    state.measure.status = status;
    final dateNow = DateTime.now();

    // Завершить последний отрезок
    final lastSession = state.measure.getLastUnfinishedSession();

    debugPrint("LastUnfinishedSession: " + lastSession.toString());

    if (lastSession == null && !finish) {
      throw Exception("Не обнаружена последняя открытая сессия!");
    }

    if (lastSession != null){
      lastSession.finished = dateNow;
    }

    debugPrint("LastUnfinishedSession: " + lastSession.toString());

    // Вычислить сумму всех законченных отрезочков
    state.measure.elapsed = state.measure.getSumOfElapsed();
    state.measure.elapsedLap = state.measure.getCurrentLapDiffAndOverall(dateNow)[0]; // TODO Ошибка при Finished

    //_tickerSubscription?.cancel();
    controller.add(5000); // Как-бы фиксируем

    await _stopwatchRepository.updateMeasureAsync(state.measure.toEntity());

    if (lastSession != null) {
      await _stopwatchRepository.updateMeasureSession(lastSession.toEntity());
    }


    //await Future.delayed(Duration(seconds: 2));

    debugPrint("fixStopwatch finished");
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  // TODO Ticker для срабатывания секундомера:
  // https://bloclibrary.dev/#/fluttertimertutorial


  /*
      Stream<TimerState> _mapStartToState(Start start) async* {
       yield Running(start.duration);
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(ticks: start.duration)
          .listen((duration) => add(Tick(duration: duration)));
    }

    Stream<TimerState> _mapPauseToState(Pause pause) async* {
      if (state is Running) {
        _tickerSubscription?.pause();
        yield Paused(state.duration);
      }
    }

    Stream<TimerState> _mapTickToState(Tick tick) async* {
      yield tick.duration > 0 ? Running(tick.duration) : Finished();
    }
   */
}
