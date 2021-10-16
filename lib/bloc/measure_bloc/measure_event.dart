import 'package:equatable/equatable.dart';

abstract class MeasureEvent extends Equatable {
  const MeasureEvent();
}

class MeasureBaseEvent extends MeasureEvent {
  @override
  List<Object?> get props => [];
}

class MeasureOpenedEvent extends MeasureBaseEvent {}

class MeasureStartedEvent extends MeasureBaseEvent {
  final bool resume;

  MeasureStartedEvent({this.resume = false});
}

class MeasureFixSnapshotEvent extends MeasureBaseEvent {}

class MeasurePausedEvent extends MeasureBaseEvent {}

class MeasureFinishedEvent extends MeasureBaseEvent {
  final bool saveMeasure;

  MeasureFinishedEvent(this.saveMeasure);
}

class LapAddedEvent extends MeasureBaseEvent {}

class TickEvent extends MeasureBaseEvent {
  final int duration;

  TickEvent(this.duration);

  @override
  List<Object> get props => [duration];
}
