import 'package:flutter/foundation.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/base/base_stopwatch_db_repository.dart';
import 'package:moor/moor.dart';

part 'stopwatch_db_repository.g.dart';

@UseDao(tables: [Laps, Measures, MeasureSessions, Tags])
class StopwatchRepository extends DatabaseAccessor<MyDatabase> with _$StopwatchRepositoryMixin implements BaseStopwatchRepository {
  StopwatchRepository() : super(MyDatabase());

  StopwatchRepository.fromDatabase(MyDatabase database) : super(database);

  Future<List<Measure>> getMeasuresByStatusAsync(String status) {
    return (select(measures)..where((m) => m.status.equals(status))..orderBy([(t) => OrderingTerm(expression: t.dateCreated, mode: OrderingMode.desc)])).get();
  }

  Future<Measure> getMeasuresByIdAsync(int id) {
    return (select(measures)..where((m) => m.id.equals(id))).getSingle();
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
    return (select(measureSessions)..where((m) => m.measureId.equals(measureId))).get();
  }

  Future updateMeasureAsync(Measure measure) {
    //into(measures).insert(measure).

    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(measures).replace(measure); //TODO Возможно заменить на insert.replace!
  }

  Future<bool> updateMeasureSession(MeasureSession measureSession) async {
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

  Future deleteMeasures(List<int> measureIds) async {
    final lapsToDelete = (await (select(laps)..where((l) => l.measureId.isIn(measureIds))).get()).map((e) => e.id);
    final sessionsToDelete = (await (select(measureSessions)..where((m) => m.measureId.isIn(measureIds))).get()).map((e) => e.id);

    return transaction(() async {
      // Удалить круги
      await (delete(laps)..where((l) => l.id.isIn(lapsToDelete))).go();
      // Удалить изм. сессии
      await (delete(measureSessions)..where((m) => m.id.isIn(sessionsToDelete))).go();

      await (delete(measures)..where((m) => m.id.isIn(measureIds))).go();
    });
  }

  Future deleteAllMeasuresDebug() {
    return delete(measures).go();
  }

  Future wipeDatabaseDebug() async {
    await delete(measureSessions).go();
    await delete(laps).go();
    await delete(tags).go();
    await delete(measures).go();
  }
}