
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';

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

  LapViewModel({int id, String comment, this.measureId, this.order, this.difference, this.overall}) : super(id: id, comment : comment);

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
  final int id;
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
}

class MeasureViewModel extends BaseStopwatchEntity {
  int elapsed;
  int elapsedLap;
  DateTime dateCreated;
  StopwatchStatus status;
  List<LapViewModel> laps = List();
  List<MeasureSessionViewModel> sessions = List();

  MeasureViewModel({int id,
    String comment,
    this.elapsed,
    this.laps,
    this.status = StopwatchStatus.Ready,
    this.dateCreated}) : super(id: id, comment : comment);

  String elapsedTime(){
    return elapsed.toString();
  }

  String elapsedTimeLap(){
    return elapsedLap.toString();
  }

  int getSumOfElapsed() {
    var elapsed = 0;
    sessions.forEach((s) => elapsed += s.finished.difference(s.started).inMilliseconds);
    return elapsed;
  }

  int getDifferernceWithPreviousLap(DateTime dateNow){
    if(!laps.any((_) => true)){

    }

    return 0;
  }

  int getOverallLapElapsed(DateTime dateNow) {
    final base = getSumOfElapsed();
    final lastSession = getLastUnfinishedSession();

    if (lastSession == null) {
      throw Exception("Last session must not be a null!");
    }

    return base + dateNow.difference(lastSession.started).inMilliseconds;
  }

  MeasureSessionViewModel getLastUnfinishedSession() {
    sessions.sort((a,b) => a.started.compareTo(b.started));
    return sessions.lastWhere((s) => s.finished == null, orElse: () => null);
  }

  Measure toEntity() {
    return Measure(id: id, status: status.toString(), dateCreated: dateCreated, elapsed: elapsed);
  }

  static MeasureViewModel fromEntity(Measure entity) {
    return MeasureViewModel(id: entity.id,
        status: StopwatchStatus.values.firstWhere((e) => e.toString() == entity.status),
        dateCreated: entity.dateCreated,
        elapsed: entity.elapsed);
  }
}
