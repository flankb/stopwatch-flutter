import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:stopwatch/models/database/database_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/base/base_stopwatch_db_repository.dart';

import '../models/database/database_models.dart';

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

  void watchFinishedMeasures(int limit) {
    final statement = (select(measures)
      ..where((m) => m.status.equals(describeEnum(StopwatchStatus.Finished)))
      ..limit(limit));
    watcher = statement.watch();

    watcher.listen((event) {
      _guaranteedAmountOfFinishedMeasures = event.length;
      debugPrint('watchFinishedMeasures $_guaranteedAmountOfFinishedMeasures');
    });
  }

  @override
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

  @override
  Future<Measure> getMeasuresByIdAsync(int id) =>
      (select(measures)..where((m) => m.id.equals(id))).getSingle();

  @override
  Future<int> createNewMeasureAsync() {
    final measureInsert = MeasuresCompanion.insert(
      elapsed: const Value(0),
      dateStarted: const Value(null),
      status: describeEnum(StopwatchStatus.Ready),
    );

    return into(measures).insert(measureInsert);
  }

  @override
  Future<int> addNewLapAsync(Insertable<Lap> lap) => into(laps).insert(lap);

  @override
  Future<int> addNewMeasureSession(Insertable<MeasureSession> measureSession) =>
      into(measureSessions).insert(measureSession);

  @override
  Future<List<MeasureSession>> getMeasureSessions(int measureId) =>
      (select(measureSessions)..where((m) => m.measureId.equals(measureId)))
          .get();

  @override
  Future updateMeasureAsync(Insertable<Measure> measure) =>
      update(measures).replace(measure);

  @override
  Future<bool> updateMeasureSession(
    Insertable<MeasureSession> measureSession,
  ) async {
    debugPrint(
      'updateMeasureSessionAsync measureSession ${measureSession.toString()}',
    );

    return update(measureSessions).replace(measureSession);
  }

  @override
  Future updateLapAsync(Insertable<Lap> lap) => update(laps).replace(lap);

  @override
  Future<List<Lap>> getLapsByMeasureAsync(int measureId) =>
      (select(laps)..where((l) => l.measureId.equals(measureId))).get();

  Future deleteMeasures(List<int> measureIds) async {
    final lapsToDelete =
        (await (select(laps)..where((l) => l.measureId.isIn(measureIds))).get())
            .map((e) => e.id);
    final sessionsToDelete = (await (select(measureSessions)
              ..where((m) => m.measureId.isIn(measureIds)))
            .get())
        .map((e) => e.id);

    return transaction<void>(() async {
      // Удалить круги
      await (delete(laps)..where((l) => l.id.isIn(lapsToDelete))).go();
      // Удалить изм. сессии
      await (delete(measureSessions)..where((m) => m.id.isIn(sessionsToDelete)))
          .go();

      await (delete(measures)..where((m) => m.id.isIn(measureIds))).go();
    });
  }

  Future deleteAllMeasuresDebug() => delete(measures).go();

  Future wipeDatabaseDebug() async {
    // final finished =
    //     await getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished));

    // await deleteMeasures(finished.map((l) => l.id).toList());
    await delete(measureSessions).go();
    await delete(laps).go();
    await delete(tags).go();
    await delete(measures).go();
  }
}
