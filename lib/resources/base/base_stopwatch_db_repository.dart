
import 'package:learnwords/model/database_models.dart';

abstract class BaseStopwatchRepository {
  Future<List<Measure>> getMeasuresByStatusAsync(String status);

  Future<int> createNewMeasureAsync();

  Future<int> addNewLapAsync(Measure measure);

  Future updateMeasureAsync(Measure measure);

  Future updateLapAsync(Lap lap);

  Future<List<Lap>> getLapsByMeasureAsync(Measure measure);
}