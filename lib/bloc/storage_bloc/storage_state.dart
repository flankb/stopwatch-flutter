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

abstract class AvailableListState {
   final List<BaseStopwatchEntity> allEntities;

  AvailableListState(this.allEntities);
}

class ReadyStorageState extends InitialStorageState implements AvailableListState {
  final List<BaseStopwatchEntity> allEntities;

  final BaseStopwatchEntity editableEntity;

  @override
  List<Object> get props => [allEntities, editableEntity];

  ReadyStorageState(this.allEntities, {this.editableEntity});
}

class FilteringState extends InitialStorageState implements AvailableListState {
  final List<BaseStopwatchEntity> allEntities;
  final List<BaseStopwatchEntity> filteredEntities;

  final BaseStopwatchEntity editableEntity;

  @override
  List<Object> get props => [allEntities, filteredEntities, editableEntity];

  FilteringState(this.allEntities, this.filteredEntities, {this.editableEntity});
}