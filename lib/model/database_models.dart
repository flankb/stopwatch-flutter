import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'database_models.g.dart';

class Laps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measureId => integer().named('measure_id').customConstraint('REFERENCES measures(id) ON DELETE CASCADE')();
  IntColumn get difference => integer()();
  IntColumn get order => integer()();
  IntColumn get overall => integer()();
  TextColumn get comment => text()();
}

class MeasureSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measureId => integer().named('measure_id').customConstraint('REFERENCES measures(id) ON DELETE CASCADE')(); // TODO ON DELETE CASCADE Не работает!!!
  DateTimeColumn get started => dateTime()();
  DateTimeColumn get finished => dateTime().nullable()();
}

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get elapsed => integer().withDefault(Constant(0))();
  DateTimeColumn get dateCreated => dateTime()();
  TextColumn get status => text().withLength(max: 16)();
  TextColumn get comment => text().nullable()();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dateCreated => dateTime()();
  IntColumn get frequency => integer()();
  TextColumn get name => text().customConstraint('UNIQUE')();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));
    return VmDatabase(file);
  });
}



@UseMoor(tables: [Laps, Measures, MeasureSessions, Tags])
class MyDatabase extends _$MyDatabase {
  /*
   SingletonOne._privateConstructor();

  static final SingletonOne _instance = SingletonOne._privateConstructor();

  factory SingletonOne(){
    return _instance;
  }

   */

  factory MyDatabase() {
    return _instance;
  }

  static final MyDatabase _instance = MyDatabase._privateConstructor();

  // we tell the database where to store the data with this constructor
  MyDatabase._privateConstructor() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;


  /*Future deleteEntities<T extends TableInfo>(){
    //delete(table)

    //  // delete the oldest nine tasks
    //  return (delete(todos)..where((t) => t.id.isSmallerThanValue(10))).go();

    T table;
    Expression<bool> Function(T tbl) filter;

    return (delete(table)..where(filter)).go();
  }*/

  /*Future<List<Measure>> getMeasuresByStatusAsync(String status) {
    return (select(measures)..where((m) => m.status.equals(status))).get();
  }

  Future<List<Measure>> getMeasuresByIdsync(int id) {
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

  Future updateMeasureSessionAsync(MeasureSession measureSession) {
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
  }*/
}

