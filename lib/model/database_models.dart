import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';

//flutter packages pub run build_runner build

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'database_models.g.dart';

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
}

