import 'package:equatable/equatable.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

abstract class EntityState extends Equatable {
  const EntityState();
}

class InitialEntityState extends EntityState {
  @override
  List<Object> get props => [];
}

class LoadingEntityState extends InitialEntityState {
}

class AvailableEntityState extends InitialEntityState {
  final BaseStopwatchEntity entity;

  AvailableEntityState(this.entity);
}
