import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class EntityEvent extends Equatable {
  final BaseStopwatchEntity entity;
  const EntityEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class OpenEntityEvent extends EntityEvent {
  const OpenEntityEvent(BaseStopwatchEntity entity) : super(entity);
}

class SaveEntityEvent extends EntityEvent {
  final String? comment;

  const SaveEntityEvent(BaseStopwatchEntity entity, {this.comment})
      : super(entity);

  @override
  List<Object?> get props => [entity, comment];
}
