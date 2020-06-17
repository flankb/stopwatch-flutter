import 'package:equatable/equatable.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class EntityEvent extends Equatable {
  final BaseStopwatchEntity entity;
  const EntityEvent(this.entity);

  @override
  List<Object> get props => [entity];
}

class OpenEntityEvent extends EntityEvent {
  OpenEntityEvent(BaseStopwatchEntity entity) : super(entity);
}

class SaveEntityEvent extends EntityEvent {
  SaveEntityEvent(BaseStopwatchEntity entity) : super(entity);
}
