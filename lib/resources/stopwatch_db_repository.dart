import 'package:flutter/foundation.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/base/base_stopwatch_db_repository.dart';
import 'package:drift/drift.dart';

part 'stopwatch_db_repository.g.dart';

@DriftAccessor(tables: [Laps, Measures, MeasureSessions, Tags])
class StopwatchRepository extends DatabaseAccessor<MyDatabase>
    with _$StopwatchRepositoryMixin
    implements BaseStopwatchRepository {
  late int _guaranteedAmountOfFinishedMeasures;

  int get guaranteedAmountOfFinishedMeasures =>
      _guaranteedAmountOfFinishedMeasures;
  StopwatchRepository() : super(MyDatabase());

  StopwatchRepository.fromDatabase(MyDatabase database) : super(database);

  late Stream<List<Measure>> watcher;

  watchFinishedMeasures(int limit) {
    var statement = (select(measures)
      ..where((m) => m.status.equals(describeEnum(StopwatchStatus.Finished)))
      ..limit(limit));
    watcher = statement.watch();

    watcher.listen((event) {
      _guaranteedAmountOfFinishedMeasures = event.length;
      debugPrint('watchFinishedMeasures $_guaranteedAmountOfFinishedMeasures');
    });
  }

  Future<List<Measure>> getMeasuresByStatusAsync(String status, {int? limit}) {
    var statement = (select(measures)
      ..where((m) => m.status.equals(status))
      ..orderBy([
        (t) => OrderingTerm(expression: t.dateStarted, mode: OrderingMode.desc)
      ]));
    if (limit != null) {
      statement = statement..limit(limit);
    }

    return statement.get();
  }

  Future<Measure> getMeasuresByIdAsync(int id) {
    return (select(measures)..where((m) => m.id.equals(id))).getSingle();
  }

  // returns the generated id
  Future<int> createNewMeasureAsync() {
    final measureInsert = MeasuresCompanion.insert(
        elapsed: const Value(0),
        dateStarted: const Value(null),
        status: describeEnum(StopwatchStatus.Ready));

    // Measure measure = Measure(
    //     id: null,
    //     elapsed: 0,
    //     dateStarted: null, //DateTime.now(),
    //     status: describeEnum(StopwatchStatus.Ready));

    return into(measures).insert(measureInsert);
  }

  Future<int> addNewLapAsync(Lap lap) {
    return into(laps).insert(lap);
  }

  Future<int> addNewMeasureSession(MeasureSession measureSession) {
    return into(measureSessions).insert(measureSession);
  }

  Future<List<MeasureSession>> getMeasureSessions(int measureId) {
    return (select(measureSessions)
          ..where((m) => m.measureId.equals(measureId)))
        .get();
  }

  Future updateMeasureAsync(Measure measure) {
    //into(measures).insert(measure).

    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(measures)
        .replace(measure); //TODO Возможно заменить на insert.replace!
  }

  Future<bool> updateMeasureSession(MeasureSession measureSession) async {
    debugPrint(
        "updateMeasureSessionAsync measureSession ${measureSession.toString()}");

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
    final lapsToDelete =
        (await (select(laps)..where((l) => l.measureId.isIn(measureIds))).get())
            .map((e) => e.id);
    final sessionsToDelete = (await (select(measureSessions)
              ..where((m) => m.measureId.isIn(measureIds)))
            .get())
        .map((e) => e.id);

    return transaction(() async {
      // Удалить круги
      await (delete(laps)..where((l) => l.id.isIn(lapsToDelete))).go();
      // Удалить изм. сессии
      await (delete(measureSessions)..where((m) => m.id.isIn(sessionsToDelete)))
          .go();

      await (delete(measures)..where((m) => m.id.isIn(measureIds))).go();
    });
  }

  Future deleteAllMeasuresDebug() {
    return delete(measures).go();
  }

  Future wipeDatabaseDebug() async {
    final finished =
        await getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished));
    await deleteMeasures(finished.map((l) => l.id).toList());
    /*await delete(measureSessions).go();
    await delete(laps).go();
    await delete(tags).go();
    await delete(measures).go();*/
  }

  dispose() {}
}
