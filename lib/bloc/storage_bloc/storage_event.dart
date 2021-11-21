import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object?> get props => [];
}

class LoadStorageEvent extends StorageEvent {
  // Определение типа: https://stackoverflow.com/questions/55835258/get-the-name-of-a-dart-class-as-a-type-or-string
  final Type entityType;
  final int? measureId;

  const LoadStorageEvent(this.entityType, {required this.measureId});

  @override
  List<Object?> get props => [entityType, measureId];
}

class ClearStorageEvent extends StorageEvent {}

/*
class RequestEditEvent extends StorageEvent {
  final BaseStopwatchEntity entity;
  RequestEditEvent(this.entity);
}*/

class DeleteStorageEvent extends StorageEvent {
  final List<BaseStopwatchEntity> entitiesForDelete;

  const DeleteStorageEvent(this.entitiesForDelete);
}

class FilterStorageEvent extends StorageEvent {
  final Filter? filter;
  final Type entityType;

  const FilterStorageEvent(this.entityType, this.filter);
}

class CancelFilterEvent extends StorageEvent {
  final Type entityType;

  const CancelFilterEvent(this.entityType);
}

class ApplyChangesEvent extends StorageEvent {
  final BaseStopwatchEntity entity;
  const ApplyChangesEvent(this.entity);
}
