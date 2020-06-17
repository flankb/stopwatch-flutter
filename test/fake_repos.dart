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
  List<MeasureSessionViewModel> _sessions;
  
  StopwatchFakeRepository() {
    _measures = FakeDataFabric.measuresHistory();
    _laps = FakeDataFabric.lapsHistory();
    _sessions = List<MeasureSessionViewModel>();
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

    _sessions.add(session);
    return session.id;
  }

  @override
  Future<List<MeasureSession>> getMeasureSessions(int measureId) async {
    return _sessions.where((element) => element.measureId == measureId).map((e) => e.toEntity());
  }

  @override
  Future updateMeasureAsync(Measure measure) async {
    final measureForUpdate = _measures.firstWhere((element) => element.id == measure.id);
    _measures.remove(measureForUpdate);

    _measures.add(MeasureViewModel.fromEntity(measure));
  }

  @override
  Future<bool> updateMeasureSession(MeasureSession measureSession) async {
    final sessionForUpdate = _sessions.firstWhere((element) => element.id == measureSession.id);
    _sessions.remove(sessionForUpdate);

    _sessions.add(MeasureSessionViewModel.fromEntity(measureSession));
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
      _sessions.removeWhere((s) => s.measureId == element);
      _laps.removeWhere((l) => l.measureId == element);
    });
  }
}

/*
class FakeWordRepository extends Fake implements BaseWordRepository {
  List<WordDict> _words;

  FakeWordRepository(){
    _words = List<WordDict>();

    WordDict w1 = WordDict();
    w1.orig = "name";
    w1.raw = ["имя"];

    WordDict w2 = WordDict();
    w2.orig = "way";
    w2.raw = ["путь"];

    WordDict w3 = WordDict();
    w3.orig = "bus";
    w3.raw = ["автобус"];

    _words.addAll([w1, w2, w3]);
  }

  @override
  Future<List<WordDict>> getSpecificWordsAsync(List<String> words) async {
    return _words.where((_) => words.contains(_.orig)).toList();
  }

  @override
  Future<List<WordDict>> getWords() async {
    return _words;
  }
}


class FakeCategoriesRepository extends Fake implements BaseWordCategoryRepository {
  List<CategoryInfo> _categories;
  CategoryInfo _selectedCategory;
  HashMap<String, List<String>> _wordsByCategories;

  FakeCategoriesRepository() : super() {
    _categories = List<CategoryInfo>();

    CategoryInfo c1 = CategoryInfo(persistentType: PersistentType.File, name: "Adverbs", translation: "Наречия");
    CategoryInfo c2 = CategoryInfo(persistentType: PersistentType.File, name: "Cars", translation: "Автомобили");
    CategoryInfo cAll = CategoryInfo(persistentType: PersistentType.File, name: "", translation: "Все слова");

    _selectedCategory = cAll;
    _categories.addAll([c1, c2, cAll]);

    _wordsByCategories = HashMap();
    _wordsByCategories[c1.name] = ["accordingly"];
    _wordsByCategories[c2.name] = ["way", "bus"];
  }

  @override
  Future<List<CategoryInfo>> getCategoriesAsync() async {
    return _categories;
  }

  @override
  Future<CategoryInfo> getSelectedCategoryAsync() async {
    return _selectedCategory;
  }

  @override
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo category) async {
    if(_wordsByCategories.containsKey(category.name)){
      return _wordsByCategories[category.name];
    }

    var result = List<String>();
    _wordsByCategories.forEach((w, l) => result.addAll(l));
    return result;
  }

  @override
  Future saveCategoryAsync(CategoryInfo category) async {
    _selectedCategory = category;
  }
}
*/