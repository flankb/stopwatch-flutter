import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class EntityState extends Equatable {
  final int version;
  static int _versionPool = 0;

  static int getUpdatedVersion() {
    _versionPool += 1;
    return _versionPool;
  }

  const EntityState(this.version);

  @override
  List<Object> get props => [version];
}

class InitialEntityState extends EntityState {
  InitialEntityState(int version) : super(version);
}

class LoadingEntityState extends InitialEntityState {
  LoadingEntityState() : super(EntityState.getUpdatedVersion());
}

class AvailableEntityState extends InitialEntityState {
  final BaseStopwatchEntity entity;

  AvailableEntityState(this.entity) : super(EntityState.getUpdatedVersion());

  @override
  List<Object> get props => super.props..addAll([entity]);
}
