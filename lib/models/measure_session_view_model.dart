import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:stopwatch/model/database_models.dart';

@immutable
class MeasureSessionViewModel with EquatableMixin {
  final int? id;
  final int measureId;
  final int startedOffset;
  final int? finishedOffset;

  MeasureSessionViewModel({
    required this.measureId,
    required this.startedOffset,
    this.id,
    this.finishedOffset,
  });

  MeasureSessionsCompanion toEntity() {
    return MeasureSessionsCompanion(
        id: id != null ? Value(id!) : Value.absent(),
        measureId: Value(measureId),
        startedOffset: Value(startedOffset),
        finishedOffset: Value(finishedOffset));
  }

  static MeasureSessionViewModel fromEntity(MeasureSession entity) {
    return MeasureSessionViewModel(
        id: entity.id,
        measureId: entity.measureId,
        startedOffset: entity.startedOffset,
        finishedOffset: entity.finishedOffset);
  }

  @override
  String toString() {
    return 'MeasureSessionViewModel{id: $id, measureId: $measureId, started: $startedOffset, finished: $finishedOffset}';
  }

  @override
  List<Object?> get props {
    return [id, measureId, startedOffset, finishedOffset];
  }

  MeasureSessionViewModel copyWith({
    int? id,
    int? measureId,
    int? startedOffset,
    int? finishedOffset,
  }) {
    return MeasureSessionViewModel(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      startedOffset: startedOffset ?? this.startedOffset,
      finishedOffset: finishedOffset ?? this.finishedOffset,
    );
  }
}
