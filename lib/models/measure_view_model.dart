import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/util/time_displayer.dart';

import 'stopwatch_proxy_models.dart';
import 'stopwatch_status.dart';
import 'package:stopwatch/util/math_helper.dart';

class MeasureViewModel extends BaseStopwatchEntity {
  int elapsed;
  int elapsedLap;
  DateTime? dateStarted;
  StopwatchStatus status;
  List<LapViewModel> laps;
  List<MeasureSessionViewModel> sessions;

  /// Вспомогательное свойство для динамического расчета истекшего времени
  DateTime? lastRestartedOverall;

  int checkPointLapTicks = 0;

  MeasureViewModel(
      {required int id,
      String? comment,
      this.elapsed = 0,
      this.elapsedLap = 0,
      this.laps = const <LapViewModel>[],
      this.sessions = const <MeasureSessionViewModel>[],
      this.status = StopwatchStatus.Ready,
      this.dateStarted})
      : super(id: id, comment: comment) {
    this.lastRestartedOverall = lastRestartedOverall ?? DateTime.now();
  }

  MeasureViewModel copyWith(
      {int? id,
      String? comment,
      int? elapsed,
      int? elapsedLap,
      List<LapViewModel>? laps,
      List<MeasureSessionViewModel>? sessions,
      StopwatchStatus? status,
      DateTime? dateCreated}) {
    return MeasureViewModel(
        id: id ?? this.id,
        comment: comment ?? this.comment,
        elapsed: elapsed ?? this.elapsed,
        elapsedLap: elapsedLap ?? this.elapsedLap,
        laps: laps ?? List.from(this.laps),
        sessions: sessions ?? List.from(this.sessions),
        status: status ?? this.status,
        dateStarted: dateCreated ?? this.dateStarted);
  }

  List<String> elapsedTime() {
    return [
      TimeDisplayer.formatBase(Duration(milliseconds: elapsed)),
      TimeDisplayer.formatMills(Duration(milliseconds: elapsed))
    ];
  }

  List<String> elapsedTimeLap() {
    return [
      TimeDisplayer.formatBase(Duration(milliseconds: elapsedLap)),
      TimeDisplayer.formatMills(Duration(milliseconds: elapsedLap))
    ];
  }

  int getElapsedSinceStarted(DateTime dateNow) {
    return dateNow.difference(dateStarted!).inMilliseconds;
  }

  int getSumOfElapsed(DateTime dateNow) {
    var elapsed = 0;

    debugPrint("All Sessions: ");
    sessions.forEach((element) {
      debugPrint(element.toString());
    });
    sessions.where((element) => element.finishedOffset != null).forEach((s) =>
        elapsed += (s.finishedOffset! -
            s.startedOffset)); // TODO При добавлении круга здесь ошибка!

    final lastUnfinishedSession = getLastUnfinishedSession();

    final elapsedAll = lastUnfinishedSession != null
        ? elapsed +
            (getElapsedSinceStarted(dateNow) -
                lastUnfinishedSession
                    .startedOffset) //dateNow.difference(lastUnfinishedSession.started).inMilliseconds
        : elapsed;

    return elapsedAll;
  }

  List<int> getCurrentLapDiffAndOverall(DateTime dateNow) {
    // Метод должен работать как при завершенной, так и незавершенной сессии

    final newOverall = getSumOfElapsed(dateNow).truncateToHundreds();

    // Здесь же можно найти разницу с предыдущим кругом
    final prevLapOverall = laps.any((_) => true) ? laps.last.overall : 0;
    final difference = newOverall - prevLapOverall;

    return [difference, newOverall];
  }

  MeasureSessionViewModel? getLastUnfinishedSession() {
    sessions.sort((a, b) => a.startedOffset.compareTo(b.startedOffset));

    if (sessions != null &&
        sessions.where((element) => element.finishedOffset == null).length >
            1) {
      throw new Exception(
          "Обнаружено более одной измерительной сессии с открытым окончанием!");
    }

    return sessions.lastWhere((s) => s.finishedOffset == null);
  }

  Measure toEntity() {
    return Measure(
        id: id,
        comment: comment,
        status: describeEnum(status),
        dateStarted: dateStarted,
        elapsed: elapsed);
  }

  static MeasureViewModel fromEntity(Measure entity) {
    return MeasureViewModel(
        id: entity.id,
        comment: entity.comment,
        status: StopwatchStatus.values
            .firstWhere((e) => describeEnum(e) == entity.status),
        dateStarted: entity.dateStarted,
        elapsed: entity.elapsed);
  }

  @override
  String toString() {
    return 'MeasureViewModel{id: $id, comment: $comment,  elapsed: $elapsed, elapsedLap: $elapsedLap, dateCreated: $dateStarted, status: $status}';
  }

  @override
  List<Object?> get props => super.props
    ..addAll([elapsed, elapsedLap, dateStarted, status, laps, sessions]);
}
