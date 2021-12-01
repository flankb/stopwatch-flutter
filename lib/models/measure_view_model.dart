import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/util/math_helper.dart';
import 'package:stopwatch/util/time_displayer.dart';

import 'stopwatch_proxy_models.dart';
import 'stopwatch_status.dart';

@immutable
class MeasureViewModel extends BaseStopwatchEntity {
  final int elapsed;
  final int elapsedLap;
  final DateTime? dateStarted;
  final StopwatchStatus status;
  final List<LapViewModel> laps;
  final List<MeasureSessionViewModel> sessions;

  /// Вспомогательное свойство для динамического расчета истекшего времени
  final DateTime lastRestartedOverall; //DateTime.now()

  // @deprecated
  // final int checkPointLapTicks; //0

  MeasureViewModel({
    required this.lastRestartedOverall,
    int? id,
    String? comment,
    this.elapsed = 0,
    this.elapsedLap = 0,
    this.laps = const <LapViewModel>[],
    this.sessions = const <MeasureSessionViewModel>[],
    this.status = StopwatchStatus.Ready,
    this.dateStarted,
    //this.checkPointLapTicks = 0,
  }) : super(id: id, comment: comment);

  MeasureViewModel copyWith({
    int? id,
    String? comment,
    int? elapsed,
    int? elapsedLap,
    List<LapViewModel>? laps,
    List<MeasureSessionViewModel>? sessions,
    StopwatchStatus? status,
    DateTime? dateCreated,
    DateTime? lastRestartedOverall,
    int? checkPointLapTicks,
  }) =>
      MeasureViewModel(
        id: id ?? this.id,
        comment: comment ?? this.comment,
        elapsed: elapsed ?? this.elapsed,
        elapsedLap: elapsedLap ?? this.elapsedLap,
        laps: laps ?? List.from(this.laps),
        sessions: sessions ?? List.from(this.sessions),
        status: status ?? this.status,
        dateStarted: dateCreated ?? dateStarted,
        lastRestartedOverall: lastRestartedOverall ?? this.lastRestartedOverall,
        //checkPointLapTicks: checkPointLapTicks ?? this.checkPointLapTicks
      );

  List<String> elapsedTime() => [
        formatBase(Duration(milliseconds: elapsed)),
        formatMills(Duration(milliseconds: elapsed))
      ];

  List<String> elapsedTimeLap() => [
        formatBase(Duration(milliseconds: elapsedLap)),
        formatMills(Duration(milliseconds: elapsedLap))
      ];

  int getElapsedSinceStarted(DateTime dateNow) =>
      dateNow.difference(dateStarted!).inMilliseconds;

  /// Вычислить все прошедшее время измерения
  int getSumOfElapsed(DateTime dateNow) {
    var elapsed = 0;

    debugPrint('All Sessions: ');
    for (final element in sessions) {
      debugPrint(element.toString());
    }
    sessions.where((element) => element.finishedOffset != null).forEach(
          (s) => elapsed += s.finishedOffset! - s.startedOffset,
        ); // TODO При добавлении круга здесь ошибка!

    final lastUnfinishedSession = getLastUnfinishedSession();

    final elapsedAll = lastUnfinishedSession != null
        ? elapsed +
            (getElapsedSinceStarted(dateNow) -
                lastUnfinishedSession
                    .startedOffset) //dateNow.difference(lastUnfinishedSession.started).inMilliseconds
        : elapsed;

    return elapsedAll;
  }

  /// Вернуть два значения:
  /// Сколько прошло времени для текущего круга
  /// Сколько всего прошло времени измерения
  List<int> getCurrentLapDiffAndOverall(DateTime dateNow) {
    // Метод должен работать как при завершенной, так и незавершенной сессии
    final newOverall = getSumOfElapsed(dateNow).truncateToHundreds();

    // Здесь же можно найти разницу с предыдущим кругом
    final prevLapOverall = laps.isNotEmpty ? laps.last.overall : 0;
    final difference = newOverall - prevLapOverall;

    return [difference, newOverall];
  }

  MeasureSessionViewModel? getLastUnfinishedSession() {
    if (sessions.where((element) => element.finishedOffset == null).length >
        1) {
      throw Exception(
        'Обнаружено более одной измерительной сессии с открытым окончанием!',
      );
    }

    return sessions.lastWhereOrNull((s) => s.finishedOffset == null);
  }

  MeasuresCompanion toEntity() => MeasuresCompanion(
        id: id != null ? Value<int>(id!) : const Value.absent(),
        comment: Value(comment),
        status: Value(describeEnum(status)),
        dateStarted: Value(dateStarted),
        elapsed: Value(elapsed),
      );

  factory MeasureViewModel.fromEntity(Measure entity) => MeasureViewModel(
        id: entity.id,
        comment: entity.comment,
        status: StopwatchStatus.values
            .firstWhere((e) => describeEnum(e) == entity.status),
        dateStarted: entity.dateStarted,
        elapsed: entity.elapsed,
        lastRestartedOverall: DateTime.now(),
      );

  @override
  String toString() =>
      'MeasureViewModel id: $id, comment: $comment,  elapsed: $elapsed, elapsedLap: $elapsedLap, dateCreated: $dateStarted, status: $status';

  @override
  List<Object?> get props => super.props
    ..addAll([elapsed, elapsedLap, dateStarted, status, laps, sessions]);
}
