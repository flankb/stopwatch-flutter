import 'dart:io';
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
  IntColumn get overall => integer()();
  TextColumn get comment => text()();
}

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get elapsed => integer()();
  DateTimeColumn get dateCreated => dateTime()();
  IntColumn get status => integer()();
  TextColumn get comment => text()();
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
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Laps, Measures, Tags])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}