// Start by creating a class that holds some view the app's state. In
// our example, we'll have a simple counter that starts at 0 can be
// incremented.
//
// Note: It must extend from Model.
import 'dart:collection';
import 'dart:convert';
import "package:collection/collection.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/category_info.dart';
import 'package:learnwords/models/persistent_type.dart';
import 'package:learnwords/models/word.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/resources/base/base_database_repository.dart';
import 'package:learnwords/resources/base/base_repository.dart';
import 'package:learnwords/resources/base/base_word_category_repository.dart';
import 'package:learnwords/resources/base/base_word_repository.dart';
import 'package:learnwords/resources/floor_repository.dart';
import 'package:learnwords/resources/words_json_repository.dart';
import 'package:learnwords/resources/dict_parser_repository.dart';
import 'package:scoped_model/scoped_model.dart';

class LearnWordsModel extends Model {
  // TODO Похоже, что в репозиторий необходимо перенести бОльшую часть кода, а этот класс оставить ответственным только за интерфейс
  List<WordDict> _wordsDict = List<WordDict>();

  List<WordDict> _searchResult = List<WordDict>();

  List<CategoryInfo> _categories = List<CategoryInfo>();
  CategoryInfo _selectedCategory = CategoryInfo.empty();

  bool _isLoading = true;
  bool _isLoadingCategories = true;
  bool _isLoadingSearch = false;

  List<WordDict> get wordsDict => _wordsDict;
  List<WordDict> get searchResult => _searchResult;

  List<CategoryInfo> get categories => _categories;
  CategoryInfo get selectedCategory => _selectedCategory;

  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoading => _isLoading;
  bool get isLoadingSearch => _isLoadingSearch;

  //final BaseWordsRepository repository;
  final BaseWordRepository dictRepository;
  final BaseWordCategoryRepository categoryRepository;
  final BaseDatabaseRepository databaseRepository; // TODO Хотелось бы сделать private

  //static int lastScrollPosition = 0;

  LearnWordsModel({@required this.dictRepository,
    @required this.categoryRepository,
    @required this.databaseRepository});

  Future loadAllModelAsync() async {
    await databaseRepository.createDatabase()
        .then((_) => loadBookmarksAsync())
        .then((_) => loadOtherDataAsync())
        .then((_) => loadCategoriesAsync())
        .then((_) => loadWordDictAsync());

    //loadOtherDataAsync()
    //loadCategoriesAsync();
    //loadWordDictAsync();
  }

  Future addWordToFavCategoryAsync(String orig) async {
    await databaseRepository.addWordToFavCategoryAsync(orig);
  }

  Future removeWordFromFavCategoryAsync(String orig) async {
    await databaseRepository.removeWordFromFavCategoryAsync(orig);
  }

  Future saveBookmarkAsync(String word) async {
    await databaseRepository.saveBookmarkAsync(_selectedCategory, word);
  }

  /*Future getBookmarkByCategory() async {
    // TODO Not implemented
  }*/

  /// Load selected category
  Future loadOtherDataAsync() async {
    _selectedCategory = await categoryRepository.getSelectedCategoryAsync();
    notifyListeners();
  }

  Future updateCategoryAsync(CategoryInfo category) async {
      _selectedCategory = category;
      await categoryRepository.saveCategoryAsync(category);
      await loadWordDictAsync();

      notifyListeners();
  }

  Future<int> getBookmarkIndexAsync() async
  {
    if (_bookmarks.containsKey(_selectedCategory.name)) {
      var index = _getWordIndexByWord(_bookmarks[_selectedCategory.name]);
      _bookmarks[_selectedCategory.name] = "";

      return index;
    }

    return -1;
  }

  Map<String, String> _bookmarks = Map();
  Future loadBookmarksAsync() async {
    var bookmarksData = await databaseRepository.getBookMarksAsync();
    // https://stackoverflow.com/questions/16831535/how-to-convert-a-list-into-a-map-in-dart

    _bookmarks = groupBy(bookmarksData, (LastWord obj) => obj.category).map((k, v) => MapEntry(k, v.first.word));

    //map((k, v) => MapEntry(k, v.map((item) { item.remove('release_date'); return item;}).toList()));
    //https://stackoverflow.com/questions/54029370/flutter-dart-how-to-groupby-list-of-maps
  }

  Future searchAsync(String query) async {
    _isLoadingSearch = true;
    _searchResult = _wordsDict.where((WordDict wd) => wd.orig.contains(query) || wd.raw.contains(query)).toList();

    await Future.delayed(Duration(milliseconds: 1500));

    _isLoadingSearch = false;
    notifyListeners();
  }

  int getWordIndex(WordDict word) {
    var item = _wordsDict.firstWhere((WordDict wd) => wd.orig == word.orig);

    if(item == null){
      return -1;
    }

    return _wordsDict.indexOf(item);
  }

  int getCurrentCategoryIndex(){
    var item = _categories.firstWhere((_) => _.name == _selectedCategory.name, orElse: () => null);

    if(item == null){
      return -1;
    }

    return _categories.indexOf(item);
  }

  int _getWordIndexByWord(String word) {
    if (_wordsDict == null || _wordsDict.length == 0){
      return -1;
    }

    var item = _wordsDict.firstWhere((WordDict wd) => wd.orig == word, orElse: () => null);

    if(item == null){
      return -1;
    }

    return _wordsDict.indexOf(item);
  }

  /// Загрузить все слова
  Future loadWordDictAsync() async {
      _isLoading = true;

      if(_selectedCategory.name == "") {
        _wordsDict = await dictRepository.getWords();
      }
      else {
        var categoryWords = List<String>();

        if(_selectedCategory.persistentType == PersistentType.File) {
          //Здесь нужно понять, что за категория и в зависимости от этого её слова либо с файла, либо с базы данных
          categoryWords = await categoryRepository.getWordsByCategoryAsync(_selectedCategory);
        }
        else {
          categoryWords = await databaseRepository.getWordsByCategoryAsync(_selectedCategory);
        }
        
        _wordsDict = await dictRepository.getSpecificWordsAsync(categoryWords);

        // Определить избранные слова и проставить отметки
        var featuredWords = await databaseRepository.getWordsByCategoryAsync(CategoryInfo(name: Featured, translation: "Избранные"));

        if (featuredWords != null) {
          _wordsDict.where((_) => featuredWords.contains(_.orig)).forEach((_) => _.isFav = true);
        }
      }

      _isLoading = false;
      notifyListeners();
  }

  Future loadCategoriesAsync() async {
    _isLoadingCategories = true;

    // Здесь необходимо вытащить категории из базы данных и присоединить их в общую кучу
    _categories = await databaseRepository.getCategoriesAsync();
    _categories.addAll(await categoryRepository.getCategoriesAsync());

    _selectedCategory = await categoryRepository.getSelectedCategoryAsync();

    _isLoadingCategories = false;

    notifyListeners();
  }

  void removeWordDictFromList(WordDict wordDict) {
    _wordsDict.remove(wordDict);
    notifyListeners();
  }

  void updateWordDictState(WordDict wordDict) {
    final index = _wordsDict.indexWhere((e) => e.orig == wordDict.orig);
    if (index >= 0) {
      if (wordDict.isFav) {
        databaseRepository.addWordToFavCategoryAsync(wordDict.orig);
      }
      else {
        databaseRepository.removeWordFromFavCategoryAsync(wordDict.orig);
      }
      
      _wordsDict[index] = wordDict; //TODO Рефакторить
      notifyListeners();
    }
  }

  /*
  void updateTodo(Todo todo) {
    final index = todos.indexWhere((e) => e.id == todo.id);
    if (index >= 0) {
      todos[index] = todo;
      notifyListeners();
    }
  }

  // TODO
  // https://github.com/harbirchahal/flutter-scoped-model-and-listview-example

  // TODO Toggle Button
  // https://api.flutter.dev/flutter/material/ToggleButtons-class.html

  **/

  static LearnWordsModel of(BuildContext context) =>
      ScopedModel.of<LearnWordsModel>(context);

  // Samples
  // https://github.com/brianegan/flutter_architecture_samples/blob/master/scoped_model
  // https://www.codeproject.com/Articles/1257076/MVVM-in-Flutter-using-ScopedModel
  // https://blog.geekyants.com/e-commerce-app-using-flutter-part-4-scoped-model-c5991cda039
  // https://pub.dev/packages/scoped_model#-readme-tab-

  /*void increment() {
    // First, increment the counter
    _counter++;

    // Then notify all the listeners.
    notifyListeners();
  }*/
}