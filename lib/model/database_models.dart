import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moor/ffi.dart';
import '../constants.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'database_models.g.dart';

class MillisDateConverter extends TypeConverter<DateTime, int> {
  const MillisDateConverter();
  @override
  DateTime mapToDart(int fromDb) {
    if (fromDb == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int mapToSql(DateTime value) {
    return value?.millisecondsSinceEpoch;
  }
}

class Laps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measureId => integer().named('measure_id').customConstraint('REFERENCES measures(id) ON DELETE CASCADE')();
  IntColumn get difference => integer()();
  IntColumn get order => integer()();
  IntColumn get overall => integer()();
  TextColumn get comment => text().nullable()();
}

class MeasureSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measureId => integer().named('measure_id').customConstraint('REFERENCES measures(id) ON DELETE CASCADE')(); // TODO ON DELETE CASCADE Не работает!!!
  //DateTimeColumn get started => dateTime()();
  //DateTimeColumn get finished => dateTime().nullable()();
  IntColumn get startedOffset => integer()();
  IntColumn get finishedOffset => integer().nullable()();
}

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get elapsed => integer().withDefault(Constant(0))();
  //DateTimeColumn get dateCreated => dateTime()();
  IntColumn get dateStarted => integer().nullable().map(const MillisDateConverter())();
  TextColumn get status => text().withLength(max: 16)();
  TextColumn get comment => text().nullable()();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dateCreated => dateTime()();
  IntColumn get frequency => integer()();
  TextColumn get name => text().customConstraint('UNIQUE')();
}
/*
@UseMoor(tables: [Laps, Measures, MeasureSessions, Tags])
class MyDatabase {

}
*/

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, DATABASE_NAME));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Laps, Measures, MeasureSessions, Tags])
class MyDatabase extends _$MyDatabase {
  factory MyDatabase() {
    return _instance;
  }

  MyDatabase.fromCustomExecutor(QueryExecutor e) : super(e);

  static final MyDatabase _instance = MyDatabase._privateConstructor();

  // we tell the database where to store the data with this constructor
  MyDatabase._privateConstructor() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}

