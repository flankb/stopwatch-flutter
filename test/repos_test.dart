import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';

void main() {
  group('Repository test', ()
  {
    StopwatchRepository _stopwatchRepository;
    MyDatabase database;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      sqfliteFfiTestInit();

      database = MyDatabase.fromCustomExecutor(VmDatabase.memory());

      _stopwatchRepository = StopwatchRepository.fromDatabase(database);
    });

    tearDown((){
      database.close();
    });

    test("FloorRepository test", () async {
    });

    test("Repo test", () async {
      await _stopwatchRepository.createNewMeasureAsync();
      final readyMeasure = await _stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));

      expect(readyMeasure.single.status == describeEnum(StopwatchStatus.Ready), true, reason: "Не создалось измерение со статусом Ready!");


    });

    /*test("WordCategoryRepository test", () async {
      final categories = await _categoryRepository.getCategoriesAsync();
      expect(categories.length, greaterThan(0));
    });

    test("DictParserRepository test", () async {
      final words = await _wordRepository.getWords();
      expect(words.length, greaterThan(0));
    });*/
  });
}
