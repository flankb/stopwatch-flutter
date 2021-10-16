import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class StorageState extends Equatable {
  const StorageState(this.version);

  final int version;
  static int _versionPool = 0;

  static int getUpdatedVersion() {
    _versionPool += 1;
    return _versionPool;
  }

  @override
  List<Object> get props => [version];
}

class LoadingStorageState extends StorageState {
  LoadingStorageState() : super(StorageState.getUpdatedVersion());
}

class AvailableListState extends StorageState {
  final List<BaseStopwatchEntity> allEntities;
  final List<BaseStopwatchEntity> entities;
  final Filter? lastFilter;
  final bool filtered;

  // Можно здесь же хранить фильтр

  @override
  List<Object> get props => [entities, filtered];

  AvailableListState(this.entities, this.allEntities, this.lastFilter,
      {this.filtered = false})
      : super(StorageState.getUpdatedVersion());
}
