import 'package:equatable/equatable.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

abstract class StorageState extends Equatable {
  const StorageState();
}

class InitialStorageState extends StorageState {
  @override
  List<Object> get props => [];
}

class LoadingStorageState extends InitialStorageState { }

class ReadyStorageState extends InitialStorageState {
  final List<BaseStopwatchEntity> allEntities;
  final List<BaseStopwatchEntity> filteredEntities;

  final BaseStopwatchEntity editableEntity;

  @override
  List<Object> get props => [allEntities, filteredEntities, editableEntity];

  ReadyStorageState(this.allEntities, this.filteredEntities, {this.editableEntity});
}