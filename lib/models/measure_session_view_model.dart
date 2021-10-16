import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:stopwatch/model/database_models.dart';

class MeasureSessionViewModel with EquatableMixin {
  int? id;
  int measureId;
  int startedOffset;
  int? finishedOffset;

  MeasureSessionViewModel(
      {this.id,
      required this.measureId,
      required this.startedOffset,
      this.finishedOffset});

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
}
