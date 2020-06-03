import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/resources/base/base_stopwatch_db_repository.dart';

class StopwatchRepository implements BaseStopwatchRepository {
  MyDatabase _database;

  // TODO В идеале в этом классе предоставить базовые CRUD-операции и возможность писать SQL-код

  StopwatchRepository() {
    _database = MyDatabase();
  }

  dispose(){
    _database.close();
  }

  Future<int> addNewMeasureSession(MeasureSession measureSession) {
    return _database.addNewMeasureSession(measureSession);
  }

  Future<List<MeasureSession>> getMeasureSessions(int measureId) {
    return _database.getMeasureSessions(measureId);
  }

  Future<List<Measure>> getMeasuresByStatusAsync(String status) {
    return _database.getMeasuresByStatusAsync(status);
  }

  Future<int> createNewMeasureAsync() {
    //final u =  _database.measures;
    return _database.createNewMeasureAsync();
  }

  Future<int> addNewLapAsync(Lap lap) {
    return _database.addNewLapAsync(lap);
  }

  Future updateMeasureAsync(Measure measure) {
    return _database.updateMeasureAsync(measure);
  }

  Future updateLapAsync(Lap lap) {
    return _database.updateLapAsync(lap);
  }

  Future<List<Lap>> getLapsByMeasureAsync(int measureId) {
    return _database.getLapsByMeasureAsync(measureId);
  }

  @override
  Future<bool> updateMeasureSession(MeasureSession measureSession) {
    return _database.updateMeasureSessionAsync(measureSession);
  }

  @override
  Future<List<Measure>> getMeasuresByIdAsync(int id) {
    return _database.getMeasuresByIdsync(id);
  }
}