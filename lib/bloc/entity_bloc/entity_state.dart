import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class EntityState extends Equatable {
  const EntityState();

  @override
  List<Object?> get props => [];
}

class InitialEntityState extends EntityState {
  InitialEntityState() : super();
}

class LoadingEntityState extends InitialEntityState {
  LoadingEntityState() : super();
}

class AvailableEntityState extends InitialEntityState {
  final BaseStopwatchEntity entity;

  AvailableEntityState(this.entity) : super();

  @override
  List<Object?> get props => super.props..addAll([entity]);
}
