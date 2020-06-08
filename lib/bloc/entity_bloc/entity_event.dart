import 'package:equatable/equatable.dart';
import 'package:learnwords/bloc/entity_bloc/bloc.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

abstract class EntityEvent extends Equatable {
  final BaseStopwatchEntity entity;
  const EntityEvent(this.entity);

  @override
  List<Object> get props => [entity];
}

class OpenEntity extends EntityEvent {
  OpenEntity(BaseStopwatchEntity entity) : super(entity);
}

class SaveEntity extends EntityEvent {
  SaveEntity(BaseStopwatchEntity entity) : super(entity);
}
