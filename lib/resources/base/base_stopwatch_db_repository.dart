import 'package:stopwatch/model/database_models.dart';

abstract class BaseStopwatchRepository {
  Future<Measure> getMeasuresByIdAsync(int id);

  Future<List<Measure>> getMeasuresByStatusAsync(String status);

  Future<int> createNewMeasureAsync();

  Future<int> addNewLapAsync(Lap lap);

  Future updateMeasureAsync(Measure measure);

  Future updateLapAsync(Lap lap);

  Future<List<Lap>> getLapsByMeasureAsync(int measureId);

  Future<int> addNewMeasureSession(MeasureSession measureSession);

  Future<bool> updateMeasureSession(MeasureSession measureSession);

  Future<List<MeasureSession>> getMeasureSessions(int measureId);
}
