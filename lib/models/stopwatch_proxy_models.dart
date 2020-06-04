
import 'package:flutter/foundation.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:learnwords/util/time_displayer.dart';

abstract class BaseStopwatchEntity {
  int id;
  String comment;

  BaseStopwatchEntity({this.id, this.comment});
}

class LapViewModel extends BaseStopwatchEntity {
  int measureId;
  int order;
  int difference;
  int overall;

  String differenceTime() {
    return TimeDisplayer.format2(Duration(milliseconds: difference));
  }

  String overallTime() {
    return TimeDisplayer.format2(Duration(milliseconds: overall));
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

  /*static Type getClassType(){
    return LapViewModel().runtimeType;
  }*/

  @override
  String toString() {
    return 'LapViewModel{order: $order, difference: $difference, overall: $overall, comment: $comment}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LapViewModel &&
              runtimeType == other.runtimeType &&
              order == other.order &&
              difference == other.difference &&
              overall == other.overall &&
              comment == other.comment;

  @override
  int get hashCode =>
      order.hashCode ^
      difference.hashCode ^
      overall.hashCode ^
      comment.hashCode;
}

class MeasureSessionViewModel {
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

  /// Вспомогательное свойство для динамического расчета истекшего времени круга
  //DateTime lastRestartedLap;

  MeasureViewModel({int id,
    String comment,
    this.elapsed = 0,
    this.elapsedLap = 0,
    this.laps,
    this.status = StopwatchStatus.Ready,
    this.dateCreated}) : super(id: id, comment : comment){
    lastRestartedOverall = DateTime.now();
    laps = List<LapViewModel>();
    sessions = List<MeasureSessionViewModel>();
  }

  List<String> elapsedTime() {
    return [TimeDisplayer.format(Duration(milliseconds: elapsed)), TimeDisplayer.formatMills(Duration(milliseconds: elapsed))];
  }

  List<String> elapsedTimeLap() {
    return [TimeDisplayer.format(Duration(milliseconds: elapsedLap)), TimeDisplayer.formatMills(Duration(milliseconds: elapsedLap))];
  }

  int getSumOfElapsed() {
    var elapsed = 0;

    debugPrint("All Sessions: ");
    sessions.forEach((element) { debugPrint(element.toString()); });
    sessions.where((element) => element.finished != null).forEach((s) => elapsed += s.finished.difference(s.started).inMilliseconds); // TODO При добавлении круга здесь ошибка!

    return elapsed;
  }

  List<int> getCurrentLapDiffAndOverall(DateTime dateNow) {
    // Метод должен работать как при завершенной, так и незавершенной сессии

    final base = getSumOfElapsed();

    final lastUnfinishedSession = getLastUnfinishedSession();
    /*if (lastUnfinishedSession == null) {
      throw Exception("Не обнаружена открытая сессия!");
    }*/

    final newOverall = lastUnfinishedSession != null
        ? base + dateNow.difference(lastUnfinishedSession.started).inMilliseconds
        : base;

    // Здесь же можно найти разницу с предыдущим кругом
    final prevLapOverall = laps.any((_) => true) ? laps.last.overall : 0;
    final difference = newOverall - prevLapOverall;

    return [difference, newOverall];
    /*
    if (lastUnfinishedSession != null) {
      final newOverall = lastUnfinishedSession != null
          ? base + dateNow.difference(lastUnfinishedSession.started).inMilliseconds
          : base;

      // Здесь же можно найти разницу с предыдущим кругом
      final prevLapOverall = laps.any((_) => true) ? laps.last.overall : 0;
      final difference = newOverall - prevLapOverall;

      return [difference, newOverall];
    }
    else {
      final newOverall = base;

      final prevLapOverall = laps.any((_) => true) ? laps.last.overall : 0;
      final difference = newOverall - prevLapOverall;

      return [difference, newOverall];
    }
   */
  }

  MeasureSessionViewModel getLastUnfinishedSession() {
    sessions.sort((a,b) => a.started.compareTo(b.started));
    return sessions.lastWhere((s) => s.finished == null, orElse: () => null);
  }

  Measure toEntity() {
    return Measure(id: id, status: describeEnum(status), dateCreated: dateCreated, elapsed: elapsed);
  }

  static MeasureViewModel fromEntity(Measure entity) {
    return MeasureViewModel(id: entity.id,
        status: StopwatchStatus.values.firstWhere((e) => describeEnum(e) == entity.status),
        dateCreated: entity.dateCreated,
        elapsed: entity.elapsed);
  }

  @override
  String toString() {
    return 'MeasureViewModel{id: $id, elapsed: $elapsed, elapsedLap: $elapsedLap, dateCreated: $dateCreated, status: $status}';
  }
}
