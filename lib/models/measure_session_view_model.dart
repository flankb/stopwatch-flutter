import 'package:equatable/equatable.dart';
import 'package:stopwatch/model/database_models.dart';

class MeasureSessionViewModel with EquatableMixin {
  int id;
  int measureId;
  DateTime started;
  DateTime finished;

  MeasureSessionViewModel({this.id, this.measureId, this.started, this.finished});

  MeasureSession toEntity() {
    return MeasureSession(id: id, measureId: measureId, started: started, finished: finished);
  }

  static MeasureSessionViewModel fromEntity(MeasureSession entity) {
    return MeasureSessionViewModel(id: entity.id,
        measureId: entity.measureId,
        started: entity.started,
        finished: entity.finished);
  }

  @override
  String toString() {
    return 'MeasureSessionViewModel{id: $id, measureId: $measureId, started: $started, finished: $finished}';
  }

  @override
  List<Object> get props {
    return [id, measureId, started, finished];
  }
}