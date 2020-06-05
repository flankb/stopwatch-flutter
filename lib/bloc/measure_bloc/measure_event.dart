import 'package:equatable/equatable.dart';

abstract class MeasureEvent extends Equatable {
  const MeasureEvent();
}

class MeasureBaseEvent extends MeasureEvent {
  @override
  List<Object> get props => null;
}

class MeasureOpenedEvent extends MeasureBaseEvent{}

class MeasureStartedEvent extends MeasureBaseEvent {
  final bool resume;

  MeasureStartedEvent({this.resume = false});
}

class MeasureFixSnapshotEvent extends MeasureBaseEvent { }

class MeasurePausedEvent extends MeasureBaseEvent { }

class MeasureFinishedEvent extends MeasureBaseEvent { }

class LapAddedEvent extends MeasureBaseEvent { }

class TickEvent extends MeasureBaseEvent {
  final int duration;

  TickEvent(this.duration);

  @override
  List<Object> get props => [duration];
}

/*
class TodoDeleted extends TodosEvent {
  final Todo todo;

  const TodoDeleted(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodoDeleted { todo: $todo }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}
 */