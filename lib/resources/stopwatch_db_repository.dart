import 'package:flutter/foundation.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:learnwords/resources/base/base_stopwatch_db_repository.dart';
import 'package:moor/moor.dart';

part 'stopwatch_db_repository.g.dart';

@UseDao(tables: [Laps, Measures, MeasureSessions, Tags])
class StopwatchRepository extends DatabaseAccessor<MyDatabase> with _$StopwatchRepositoryMixin implements BaseStopwatchRepository {
  MyDatabase _database;

  // TODO В идеале в этом классе предоставить базовые CRUD-операции и возможность писать SQL-код

  StopwatchRepository(MyDatabase database) : super(database) {
    // TODO??
    //_database = MyDatabase();
  }

  /*dispose() {
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
  }*/

  Future<List<Measure>> getMeasuresByStatusAsync(String status) {
    return (select(measures)..where((m) => m.status.equals(status))).get();
  }

  Future<List<Measure>> getMeasuresByIdAsync(int id) {
    return (select(measures)..where((m) => m.id.equals(id))).get();
  }

  // returns the generated id
  Future<int> createNewMeasureAsync() {
    Measure measure = Measure(id: null,
        elapsed: 0,
        dateCreated: DateTime.now(),
        status: describeEnum(StopwatchStatus.Ready));

    return into(measures).insert(measure);
  }

  Future<int> addNewLapAsync(Lap lap) {
    return into(laps).insert(lap);
  }

  Future<int> addNewMeasureSession(MeasureSession measureSession) {
    return into(measureSessions).insert(measureSession);
  }

  Future<List<MeasureSession>> getMeasureSessions(int measureId) {
    return (select(measureSessions)..where((m) => m.id.equals(measureId))).get();
  }

  /*
  Future<int> addNewMeasureSession(Table table){ // TODO Что-то придумать, чтобы избежать дублирования методов в разных слоях
    final t = select(table).get();
  }*/

  Future updateMeasureAsync(Measure measure) {
    //into(measures).insert(measure).

    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(measures).replace(measure); //TODO Возможно заменить на insert.replace!
  }

  Future<bool> updateMeasureSession(MeasureSession measureSession) {
    debugPrint("updateMeasureSessionAsync measureSession ${measureSession.toString()}");

    return update(measureSessions).replace(measureSession);
  }

  Future updateLapAsync(Lap lap) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(laps).replace(lap);
  }

  Future<List<Lap>> getLapsByMeasureAsync(int measureId) {
    return (select(laps)..where((l) => l.measureId.equals(measureId))).get();
  }

  /*@override
  Future<List<Measure>> getMeasuresByIdAsync(int id) {
    // TODO: implement getMeasuresByIdAsync
    throw UnimplementedError();
  }*/

  /*@override
  Future<bool> updateMeasureSession(MeasureSession measureSession) {
    // TODO: implement updateMeasureSession
    throw UnimplementedError();
  }*/

}
