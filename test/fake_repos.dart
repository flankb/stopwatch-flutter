// Fake class
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:mockito/mockito.dart';

class StopwatchFakeRepository extends Fake implements StopwatchRepository {
  List<MeasureViewModel> _measures;
  List<LapViewModel> _laps;
  List<MeasureSessionViewModel> sessions;
  
  StopwatchFakeRepository({bool preBuild =false}) {
    if (preBuild) {
      _measures = FakeDataFabric.measuresHistory();
      _laps = FakeDataFabric.lapsHistory();
      sessions = FakeDataFabric.sessionsHistory();
    } else {
      _measures = List<MeasureViewModel>();
      _laps = List<LapViewModel>();
      sessions = List<MeasureSessionViewModel>();
    }
  }
  
  @override
  Future<List<Measure>> getMeasuresByStatusAsync(String status) async {
    return _measures.where((element) => describeEnum(element.status) == status).map((e) => e.toEntity()).toList();
  }

  @override
  Future<Measure> getMeasuresByIdAsync(int id) async {
      return _measures.firstWhere((element) => element.id == id, orElse: () => null).toEntity();
  }

  @override
  Future<int> createNewMeasureAsync() async{
    Measure measure = Measure(id: Random(43).nextInt(2000) + 100,
        elapsed: 0,
        dateCreated: DateTime.now(),
        status: describeEnum(StopwatchStatus.Ready));

    _measures.add(MeasureViewModel.fromEntity(measure));

    return measure.id;
  }

  @override
  Future<int> addNewLapAsync(Lap lap) async {
    final lapViewModel = LapViewModel.fromEntity(lap);
    lapViewModel.id = Random(50).nextInt(2000) + 100;

    _laps.add(lapViewModel);
    return lapViewModel.id;
  }

  @override
  Future<int> addNewMeasureSession(MeasureSession measureSession) async {
    MeasureSessionViewModel session = MeasureSessionViewModel.fromEntity(measureSession);
    session.id = Random(55).nextInt(2000) + 100;

    sessions.add(session);
    return session.id;
  }

  @override
  Future<List<MeasureSession>> getMeasureSessions(int measureId) async {
    return sessions.where((element) => element.measureId == measureId).map((e) => e.toEntity()).toList();
  }

  @override
  Future updateMeasureAsync(Measure measure) async {
    final measureForUpdate = _measures.firstWhere((element) => element.id == measure.id);
    _measures.remove(measureForUpdate);

    _measures.add(MeasureViewModel.fromEntity(measure));
  }

  @override
  Future<bool> updateMeasureSession(MeasureSession measureSession) async {
    final sessionForUpdate = sessions.firstWhere((element) => element.id == measureSession.id);
    sessions.remove(sessionForUpdate);

    sessions.add(MeasureSessionViewModel.fromEntity(measureSession));
    return true;
  }

  @override
  Future updateLapAsync(Lap lap) async {
    final lapForUpdate = _laps.firstWhere((element) => element.id == lap.id);
    _laps.remove(lapForUpdate);

    _laps.add(LapViewModel.fromEntity(lap));
  }

  @override
  Future<List<Lap>> getLapsByMeasureAsync(int measureId) async {
    return _laps.where((element) => element.measureId == measureId).map((e) => e.toEntity()).toList();
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