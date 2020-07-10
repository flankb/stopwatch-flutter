import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/util/time_displayer.dart';

import 'stopwatch_proxy_models.dart';
import 'stopwatch_status.dart';

class MeasureViewModel extends BaseStopwatchEntity {
  int elapsed;
  int elapsedLap;
  DateTime dateCreated;
  StopwatchStatus status;
  List<LapViewModel> laps;
  List<MeasureSessionViewModel> sessions;

  /// Вспомогательное свойство для динамического расчета истекшего времени
  DateTime lastRestartedOverall;

  int checkPointLapTicks = 0;

  MeasureViewModel({int id,
    String comment,
    this.elapsed = 0,
    this.elapsedLap = 0,
    this.laps,
    this.sessions,
    this.status = StopwatchStatus.Ready,
    this.dateCreated}) : super(id: id, comment : comment) {
    this.lastRestartedOverall = lastRestartedOverall ?? DateTime.now();
    this.laps = laps ?? List<LapViewModel>();
    this.sessions = sessions ?? List<MeasureSessionViewModel>();
  }

  MeasureViewModel copyWith({int id,
    String comment,
    int elapsed,
    int elapsedLap,
    List<LapViewModel> laps,
    List<MeasureSessionViewModel> sessions,
    StopwatchStatus status,
    DateTime dateCreated}) {
    return MeasureViewModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      elapsed: elapsed ?? this.elapsed,
      elapsedLap: elapsedLap ?? this.elapsedLap,
      laps: laps ?? this.laps,
      sessions: sessions ?? this.sessions,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated);
  }

  List<String> elapsedTime() {
    return [TimeDisplayer.formatBase(Duration(milliseconds: elapsed)), TimeDisplayer.formatMills(Duration(milliseconds: elapsed))];
  }

  List<String> elapsedTimeLap() {
    return [TimeDisplayer.formatBase(Duration(milliseconds: elapsedLap)), TimeDisplayer.formatMills(Duration(milliseconds: elapsedLap))];
  }

  int getElapsedSinceStarted(DateTime dateNow){
    return dateNow.difference(dateCreated).inMilliseconds;
  }

  int getSumOfElapsed(DateTime dateNow) {
    var elapsed = 0;

    debugPrint("All Sessions: ");
    sessions.forEach((element) { debugPrint(element.toString()); });
    sessions.where((element) => element.finished != null).forEach((s) => elapsed += (s.finished - s.started)); // TODO При добавлении круга здесь ошибка!

    final lastUnfinishedSession = getLastUnfinishedSession();

    final elapsedAll = lastUnfinishedSession != null
        ? elapsed + (getElapsedSinceStarted(dateNow) - lastUnfinishedSession.started) //dateNow.difference(lastUnfinishedSession.started).inMilliseconds
        : elapsed;

    return elapsedAll;
  }

  List<int> getCurrentLapDiffAndOverall(DateTime dateNow) {
    // Метод должен работать как при завершенной, так и незавершенной сессии

    final newOverall = getSumOfElapsed(dateNow);

    // Здесь же можно найти разницу с предыдущим кругом
    final prevLapOverall = laps.any((_) => true) ? laps.last.overall : 0;
    final difference = newOverall - prevLapOverall;

    return [difference, newOverall];
  }

  MeasureSessionViewModel getLastUnfinishedSession() {
    sessions.sort((a,b) => a.started.compareTo(b.started));

    if (sessions.where((element) => element.finished == null).length > 1) {
      throw new Exception("Обнаружено более одной измерительной сессии с открытым окончанием!");
    }

    return sessions.lastWhere((s) => s.finished == null, orElse: () => null);
  }

  Measure toEntity() {
    return Measure(id: id, comment: comment, status: describeEnum(status), dateCreated: dateCreated, elapsed: elapsed);
  }

  static MeasureViewModel fromEntity(Measure entity) {
    return MeasureViewModel(id: entity.id,
        comment: entity.comment,
        status: StopwatchStatus.values.firstWhere((e) => describeEnum(e) == entity.status),
        dateCreated: entity.dateCreated,
        elapsed: entity.elapsed);
  }

  @override
  String toString() {
    return 'MeasureViewModel{id: $id, comment: $comment,  elapsed: $elapsed, elapsedLap: $elapsedLap, dateCreated: $dateCreated, status: $status}';
  }

  @override
  List<Object> get props => super.props..addAll([elapsed, elapsedLap, dateCreated, status, laps, sessions]);
}