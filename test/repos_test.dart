import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/measure_view_model.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';

void main() {
  group('Repository test', () {
    late StopwatchRepository _stopwatchRepository;
    late MyDatabase database;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      //sqfliteFfiTestInit();

      database = MyDatabase.fromCustomExecutor(NativeDatabase.memory());

      _stopwatchRepository = StopwatchRepository.fromDatabase(database);
    });

    tearDown(() {
      database.close();
    });

    test('FloorRepository test', () async {});

    test('Repo test', () async {
      await _stopwatchRepository.createNewMeasureAsync();

      final readyMeasure = await _stopwatchRepository
          .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));
      //readyMeasure.single.dateStarted = DateTime.now();

      expect(
        readyMeasure.single.status == describeEnum(StopwatchStatus.Ready),
        true,
        reason: 'Не создалось измерение со статусом Ready!',
      );

      final measureId = readyMeasure.single.id;

      final measureById =
          await _stopwatchRepository.getMeasuresByIdAsync(measureId);
      expect(measureId, equals(measureById.id), reason: 'Id неверный!');

      final lap = Lap(
        order: 1,
        measureId: measureId,
        id: 1,
        difference: 10,
        overall: 10,
      );

      await _stopwatchRepository.addNewLapAsync(lap);

      final measureViewModel = MeasureViewModel.fromEntity(readyMeasure.single)
          .copyWith(dateCreated: DateTime.now());
      await _stopwatchRepository.addNewMeasureSession(
        MeasureSession(
          startedOffset:
              measureViewModel.getElapsedSinceStarted(DateTime.now()),
          finishedOffset: measureViewModel.getElapsedSinceStarted(
            DateTime.now().add(
              const Duration(seconds: 23),
            ),
          ),
          measureId: measureId,
          id: 1,
        ),
      );

      var laps = await _stopwatchRepository.getLapsByMeasureAsync(measureId);
      var sessions = await _stopwatchRepository.getMeasureSessions(measureId);

      expect(
        laps.length == 1 && sessions.length == 1,
        true,
        reason: 'Не добавились круги или сессии',
      );

      await _stopwatchRepository.deleteMeasures([measureId]);

      final measures = await _stopwatchRepository
          .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Ready));
      laps = await _stopwatchRepository.getLapsByMeasureAsync(measureId);
      sessions = await _stopwatchRepository.getMeasureSessions(measureId);

      expect(
        measures.isEmpty && laps.isEmpty && sessions.isEmpty,
        true,
        reason: 'Не удалились сущности',
      );
    });
  });
}
