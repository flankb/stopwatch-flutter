import 'package:equatable/equatable.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => null;
}

class OpenStorageEvent extends StorageEvent {
  // Определение типа: https://stackoverflow.com/questions/55835258/get-the-name-of-a-dart-class-as-a-type-or-string
  final Type entityType;
  final int measureId;

  OpenStorageEvent(this.entityType, {this.measureId});

  @override
  List<Object> get props => [entityType, measureId];
}

class RequestEditEvent extends StorageEvent {
  final BaseStopwatchEntity entity;

  RequestEditEvent(this.entity);
}

class FilterStorageEvent extends StorageEvent {
  final String query;

  FilterStorageEvent(this.query);
}

class ApplyChangesEvent extends StorageEvent {
  final BaseStopwatchEntity entity;
  ApplyChangesEvent(this.entity);
}