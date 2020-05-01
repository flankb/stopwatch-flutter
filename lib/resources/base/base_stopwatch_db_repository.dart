
import 'package:learnwords/model/database_models.dart';

abstract class BaseStopwatchRepository {
  Future<List<Measure>> getMeasuresByStatusAsync(String status);

  Future<int> createNewMeasureAsync();

  Future<int> addNewLapAsync(Lap lap);

  Future updateMeasureAsync(Measure measure);

  Future updateLapAsync(Lap lap);

  Future<List<Lap>> getLapsByMeasureAsync(Measure measure);

  Future<int> addNewMeasureSession(MeasureSession measureSession);

  Future<int> updateMeasureSession(MeasureSession measureSession);

  Future<List<MeasureSession>> getMeasureSessions(int measureId);
}