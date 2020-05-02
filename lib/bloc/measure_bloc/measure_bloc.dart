import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:learnwords/resources/base/base_stopwatch_db_repository.dart';
import 'package:learnwords/util/ticker.dart';

import 'measure_event.dart';
import 'measure_state.dart';


class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final Ticker _ticker;
  final BaseStopwatchRepository _stopwatchRepository;

  StreamSubscription<int> _tickerSubscription;

  MeasureBloc(this._ticker, this._stopwatchRepository);

  @override
  MeasureState get initialState => MeasureReadyState(MeasureViewModel());

  @override
  Stream<MeasureState> mapEventToState(
    MeasureEvent event,
  ) async* {
    // Для каждого события что-то делаем и возвращаем состояние
    if (event is TickEvent) {
      yield* _mapTickToState(event);
    } if (event is MeasureStartedEvent) {
      yield* _mapStartedToState(event);
    } else if (event is MeasurePausedEvent) {
      yield* _mapPausedToState(event);
    } else if (event is MeasureFinishedEvent) {
      yield* _mapFinishedToState(event);
    } else if (event is LapAddedEvent) {
      yield* _mapLapAddedToState(event);
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

      final lapProps = state.measure.getNewLapDiffAndOverall(DateTime.now());

      LapViewModel newLap = LapViewModel();
      newLap.measureId = state.measure.id;
      newLap.difference = 0; //TODO Вычислить разницу с предыдущим кругом
      newLap.order = state.measure.laps.length + 1;
      newLap.difference = lapProps[0];
      newLap.overall = lapProps[1];

      state.measure.laps.add(newLap);
      newLap.id = await _stopwatchRepository.addNewLapAsync(newLap.toEntity());

      yield MeasureStartedState(state.measure);
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapFinishedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState || state is MeasurePausedState) {
      yield* _fixStopwatch(StopwatchStatus.Finished);
      yield MeasureReadyState(MeasureViewModel());
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapPausedToState(MeasureEvent event) async* {
    if (state is MeasureStartedState) {
      _fixStopwatch(StopwatchStatus.Paused);
      yield MeasurePausedState(state.measure);
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _mapStartedToState(MeasureEvent event) async* {
    if (state is MeasureReadyState || state is MeasurePausedState) {
      yield MeasureUpdatingState(state.measure);
      // Устанавливаем поля в модели, делаем запись в репозитории
      state.measure.status = StopwatchStatus.Started;
      final nowDate = DateTime.now();

      if (state.measure.dateCreated == null) {
        state.measure.dateCreated = nowDate;
      }

      final session = MeasureSessionViewModel(id: state.measure.id, started: nowDate);
      state.measure.sessions.add(session);

      // Если в БД есть такая запись - то обновить, иначе создать новую
      await _stopwatchRepository.updateMeasureAsync(state.measure.toEntity());
      await _stopwatchRepository.addNewMeasureSession(session.toEntity());

      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker
          .tick(ticks: state.measure.elapsed)
          .listen((duration) => add(TickEvent(duration)));

      yield MeasureStartedState(state.measure);
    }
    else {
      throw Exception("Wrong state!");
    }
  }

  Stream<MeasureState> _fixStopwatch(StopwatchStatus status) async* {
    yield MeasureUpdatingState(state.measure);
    _tickerSubscription?.cancel();
    state.measure.status = status;
    final dateNow = DateTime.now();

    // Завершить последний отрезок
    final lastSession = state.measure.getLastUnfinishedSession();

    if (lastSession == null) {
      throw Exception("Не обнаружена последняя открытая сессия!");
    }

    lastSession.finished = dateNow;

    // Вычислить сумму всех законченных отрезочков
    state.measure.elapsed = state.measure.getSumOfElapsed();

    await _stopwatchRepository.updateMeasureAsync(state.measure.toEntity());
    await _stopwatchRepository.updateMeasureSession(lastSession.toEntity());

    await Future.delayed(Duration(seconds: 2));
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
