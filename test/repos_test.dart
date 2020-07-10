import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/measure_view_model.dart';
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
      //readyMeasure.single.dateStarted = DateTime.now();

      expect(readyMeasure.single.status == describeEnum(StopwatchStatus.Ready), true, reason: "Не создалось измерение со статусом Ready!");

      final measureId = readyMeasure.single.id;

      final measureById = await _stopwatchRepository.getMeasuresByIdAsync(measureId);
      expect(measureId, equals(measureById.id), reason: "Id неверный!");

      Lap lap = Lap(order: 1, measureId: measureId, id: null, difference: 10, overall: 10);

      await _stopwatchRepository.addNewLapAsync(lap);

      var measureViewModel = MeasureViewModel.fromEntity(readyMeasure.single);
      measureViewModel.dateCreated = DateTime.now();
      await _stopwatchRepository.addNewMeasureSession(MeasureSession(startedOffset: measureViewModel.getElapsedSinceStarted(DateTime.now()), finishedOffset:  measureViewModel.getElapsedSinceStarted(DateTime.now().add(Duration(seconds: 23))), measureId: measureId, id: null, ));

      var laps = await _stopwatchRepository.getLapsByMeasureAsync(measureId);
      var sessions = await _stopwatchRepository.getMeasureSessions(measureId);

      expect(laps.length == 1 && sessions.length == 1, true, reason: "Не добавились круги или сессии");

      await _stopwatchRepository.deleteMeasures([measureId]);

      final measures = await _stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));
      laps = await _stopwatchRepository.getLapsByMeasureAsync(measureId);
      sessions = await _stopwatchRepository.getMeasureSessions(measureId);

      expect(measures.length == 0 && laps.length == 0 && sessions.length == 0, true, reason: "Не удалились сущности");
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
