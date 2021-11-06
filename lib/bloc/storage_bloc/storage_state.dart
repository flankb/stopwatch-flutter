import 'package:equatable/equatable.dart';

import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object?> get props => [];
}

class LoadingStorageState extends StorageState {
  LoadingStorageState() : super();
}

class AvailableListState extends StorageState {
  final List<BaseStopwatchEntity> allEntities;
  final List<BaseStopwatchEntity> entities;
  final Filter lastFilter;
  final bool filtered;

  @override
  List<Object?> get props => [allEntities, entities, lastFilter, filtered];

  AvailableListState(this.entities, this.allEntities, this.lastFilter,
      {this.filtered = false})
      : super();

  AvailableListState copyWith({
    List<BaseStopwatchEntity>? allEntities,
    List<BaseStopwatchEntity>? entities,
    Filter? lastFilter,
    bool? filtered,
  }) {
    return AvailableListState(
      allEntities ?? this.allEntities,
      entities ?? this.entities,
      lastFilter ?? this.lastFilter,
      filtered: filtered ?? this.filtered,
    );
  }
}
