
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/util/time_displayer.dart';

abstract class BaseStopwatchEntity with EquatableMixin {
  int id;
  String comment;

  BaseStopwatchEntity({this.id, this.comment});

  @override
  List<Object> get props {
    return [id, comment];
  }
}

class LapViewModel extends BaseStopwatchEntity {
  int measureId;
  int order;
  int difference;
  int overall;

  String differenceTime() {
    return TimeDisplayer.formatBase(Duration(milliseconds: difference));
  }

  String overallTime() {
    return TimeDisplayer.formatBase(Duration(milliseconds: overall));
  }

  String differenceMills() {
    return TimeDisplayer.formatMills(Duration(milliseconds: difference));
  }

  String overallMills() {
    return TimeDisplayer.formatMills(Duration(milliseconds: overall));
  }

  LapViewModel({int id, String comment, this.measureId, this.order, this.difference = 0, this.overall = 0}) : super(id: id, comment : comment);

  Lap toEntity() {
    return Lap(id: id, measureId: measureId, order: order, difference : difference, comment: comment, overall: overall);
  }

  static LapViewModel fromEntity(Lap entity) {
    return LapViewModel(id: entity.id,
        measureId: entity.measureId,
        order: entity.order,
        difference : entity.difference,
        comment: entity.comment,
        overall: entity.overall);
  }

  @override
  String toString() {
    return 'LapViewModel{order: $order, difference: $difference, overall: $overall, comment: $comment}';
  }

  @override
  List<Object> get props => super.props..addAll([measureId, order, difference, overall]);
}

class MeasureSessionViewModel with EquatableMixin {
  int id;
  int measureId;
  DateTime started;
  DateTime finished;

  MeasureSessionViewModel({this.id, this.measureId, this.started, this.finished});

  MeasureSession toEntity() {
    return MeasureSession(id: id, measureId: measureId, started: started, finished: finished);
  }

  static MeasureSessionViewModel fromEntity(MeasureSession entity) {
    return MeasureSessionViewModel(id: entity.id,
        measureId: entity.measureId,
        started: entity.started,
        finished: entity.finished);
  }

  @override
  String toString() {
    return 'MeasureSessionViewModel{id: $id, measureId: $measureId, started: $started, finished: $finished}';
  }

  @override
  List<Object> get props {
    return [id, measureId, started, finished];
  }
}

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
    this.status = StopwatchStatus.Ready,
    this.dateCreated}) : super(id: id, comment : comment) {
    lastRestartedOverall = DateTime.now();
    laps = List<LapViewModel>();
    sessions = List<MeasureSessionViewModel>();
  }

  List<String> elapsedTime() {
    return [TimeDisplayer.formatBase(Duration(milliseconds: elapsed)), TimeDisplayer.formatMills(Duration(milliseconds: elapsed))];
  }

  List<String> elapsedTimeLap() {
    return [TimeDisplayer.formatBase(Duration(milliseconds: elapsedLap)), TimeDisplayer.formatMills(Duration(milliseconds: elapsedLap))];
  }

  int getSumOfElapsed(DateTime dateNow) {
    var elapsed = 0;

    debugPrint("All Sessions: ");
    sessions.forEach((element) { debugPrint(element.toString()); });
    sessions.where((element) => element.finished != null).forEach((s) => elapsed += s.finished.difference(s.started).inMilliseconds); // TODO При добавлении круга здесь ошибка!

    final lastUnfinishedSession = getLastUnfinishedSession();

    final elapsedAll = lastUnfinishedSession != null
        ? elapsed + dateNow.difference(lastUnfinishedSession.started).inMilliseconds
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
