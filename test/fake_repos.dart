// Fake class
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:collection/collection.dart';

class StopwatchFakeRepository extends Fake implements StopwatchRepository {
  late List<MeasureViewModel> _measures;
  late List<LapViewModel> _laps;
  late List<MeasureSessionViewModel> sessions;

  StopwatchFakeRepository({bool preBuild = false}) {
    if (preBuild) {
      _measures = FakeDataFabric.measuresHistory();
      _laps = FakeDataFabric.lapsHistory();
      sessions = FakeDataFabric.sessionsHistory();
    } else {
      _measures = <MeasureViewModel>[];
      _laps = <LapViewModel>[];
      sessions = <MeasureSessionViewModel>[];
    }
  }

  @override
  Future<List<Measure>> getMeasuresByStatusAsync(String status,
      {int? limit}) async {
    return _measures
        .where((element) => describeEnum(element.status) == status)
        .map(_convertToMeasure)
        .toList();
  }

  // TODO Refactor this methods!
  Measure _convertToMeasure(MeasureViewModel measureViewModel) {
    return Measure(
        id: measureViewModel.id!,
        comment: measureViewModel.comment,
        status: (describeEnum(measureViewModel.status)),
        dateStarted: measureViewModel.dateStarted,
        elapsed: measureViewModel.elapsed);
  }

  Lap _convertToLap(LapViewModel lapViewModel) {
    return Lap(
        id: lapViewModel.id!,
        measureId: lapViewModel.measureId,
        order: lapViewModel.order,
        difference: lapViewModel.difference,
        comment: lapViewModel.comment,
        overall: lapViewModel.overall);
  }

  MeasureSession _convertToMeasureSession(MeasureSessionViewModel msc) {
    return MeasureSession(
        id: msc.id!,
        measureId: msc.measureId,
        startedOffset: msc.startedOffset,
        finishedOffset: msc.finishedOffset);
  }

  MeasureViewModel _convertToMeasureViewModel(MeasuresCompanion mc) =>
      MeasureViewModel(
        id: mc.id.value,
        comment: mc.comment.value,
        status: StopwatchStatus.values
            .firstWhere((es) => describeEnum(es) == mc.status.value),
        dateStarted: mc.dateStarted.value,
        elapsed: mc.elapsed.value,
        lastRestartedOverall: DateTime.now(),
      );

  MeasureSessionViewModel _convertToMeasureSessionViewModel(
          MeasureSessionsCompanion measureSession, int generatedId) =>
      MeasureSessionViewModel(
        id: generatedId,
        measureId: measureSession.measureId.value,
        startedOffset: measureSession.startedOffset.value,
        finishedOffset: measureSession.finishedOffset.value,
      );

  LapViewModel _convertToLapViewModel(LapsCompanion lap, int generatedId) =>
      LapViewModel(
        id: generatedId,
        measureId: lap.measureId.value,
        order: lap.order.value,
        difference: lap.difference.value,
        comment: lap.comment.value,
        overall: lap.overall.value,
      );

  @override
  Future<Measure> getMeasuresByIdAsync(int id) async {
    final measureViewModel =
        _measures.firstWhereOrNull((element) => element.id == id);
    return _convertToMeasure(measureViewModel!);
  }

  @override
  Future<int> createNewMeasureAsync() async {
    final measure = Measure(
        id: Random(43).nextInt(2000) + 100,
        elapsed: 0,
        dateStarted: null, //DateTime.now(),
        status: describeEnum(StopwatchStatus.Ready));

    _measures.add(MeasureViewModel.fromEntity(measure));

    return measure.id;
  }

  @override
  Future<int> addNewLapAsync(Insertable<Lap> lap) async {
    final lapViewModel = _convertToLapViewModel(
        lap as LapsCompanion, Random(50).nextInt(2000) + 100);

    _laps.add(lapViewModel);
    return lapViewModel.id!;
  }

  @override
  Future<int> addNewMeasureSession(
      Insertable<MeasureSession> measureSession) async {
    final session = _convertToMeasureSessionViewModel(
      measureSession as MeasureSessionsCompanion,
      Random(55).nextInt(2000) + 100,
    );

    sessions.add(session);
    return session.id!;
  }

  @override
  Future<List<MeasureSession>> getMeasureSessions(int measureId) async =>
      sessions
          .where((element) => element.measureId == measureId)
          .map(_convertToMeasureSession)
          .toList();

  @override
  Future updateMeasureAsync(Insertable<Measure> measure) async {
    final measureForUpdate = _measures.firstWhere(
        (element) => element.id == (measure as MeasuresCompanion).id.value);
    _measures.remove(measureForUpdate);

    final viewModel = _convertToMeasureViewModel(measure as MeasuresCompanion);
    debugPrint('Converted from entity: $viewModel');

    _measures.add(viewModel);
  }

  @override
  Future<bool> updateMeasureSession(
      Insertable<MeasureSession> measureSession) async {
    final sessionForUpdate = sessions.firstWhere(
      (element) =>
          element.id == (measureSession as MeasureSessionsCompanion).id.value,
    );
    sessions
      ..remove(sessionForUpdate)
      ..add(
        _convertToMeasureSessionViewModel(
          measureSession as MeasureSessionsCompanion,
          measureSession.id.value,
        ),
      );
    return true;
  }

  @override
  Future updateLapAsync(Insertable<Lap> lap) async {
    final lapForUpdate = _laps
        .firstWhere((element) => element.id == (lap as LapsCompanion).id.value);
    _laps.remove(lapForUpdate);

    _laps.add(_convertToLapViewModel((lap as LapsCompanion), lap.id.value));
  }

  @override
  Future<List<Lap>> getLapsByMeasureAsync(int measureId) async {
    return _laps
        .where((element) => element.measureId == measureId)
        .map(_convertToLap)
        .toList();
  }

  @override
  Future deleteMeasures(List<int> measureIds) async {
    measureIds.forEach((element) {
      _measures.removeWhere((m) => m.id == element);
      sessions.removeWhere((s) => s.measureId == element);
      _laps.removeWhere((l) => l.measureId == element);
    });
  }
}
