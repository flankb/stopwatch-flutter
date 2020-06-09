import 'package:equatable/equatable.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

abstract class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object> get props => [];
}

/*class InitialStorageState extends StorageState {
  @override
  List<Object> get props => [];
}*/

class LoadingStorageState extends StorageState { }

class AvailableListState extends StorageState {
   final List<BaseStopwatchEntity> entities;
   final bool filtered;

   // Можно здесь же хранить фильтр

   @override
   List<Object> get props => [entities, filtered];

   AvailableListState(this.entities, {this.filtered = false});
}

/*class ReadyStorageState extends InitialStorageState implements AvailableListState {
  final List<BaseStopwatchEntity> allEntities;

  final BaseStopwatchEntity editableEntity;

  @override
  List<Object> get props => [allEntities, editableEntity];

  ReadyStorageState(this.allEntities, {this.editableEntity});
}*/

/*
class FilteredState extends InitialStorageState implements AvailableListState {
  final List<BaseStopwatchEntity> allEntities;
  final List<BaseStopwatchEntity> filteredEntities;

  final BaseStopwatchEntity editableEntity;

  @override
  List<Object> get props => [allEntities, filteredEntities, editableEntity];

  FilteredState(this.allEntities, this.filteredEntities, {this.editableEntity});
}*/