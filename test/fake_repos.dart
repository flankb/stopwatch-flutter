
// Fake class
import 'dart:collection';

import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/category_info.dart';
import 'package:learnwords/models/persistent_type.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/resources/base/base_database_repository.dart';
import 'package:learnwords/resources/base/base_word_category_repository.dart';
import 'package:learnwords/resources/base/base_word_repository.dart';
import 'package:learnwords/resources/floor_repository.dart';
import 'package:mockito/mockito.dart';

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

class FakeDatabaseRepository extends Fake implements BaseDatabaseRepository {
  //List<String> _favors;
  List<LastWord> _bookmarks;
  List<CategoryInfo> _categories;
  List<MlCategoryWord> _links;
  List<Category> _categoriesDb;

  FakeDatabaseRepository(): super() {
    //_favors = List<String>();
    _bookmarks = List<LastWord>();
    _categories = List<CategoryInfo>();
    _links = List<MlCategoryWord>();
    _categoriesDb = List<Category>();
  }

  @override
  Future addWordToFavCategoryAsync(String orig) async {
    //_favors.add(orig);

    _links.add(MlCategoryWord(id: 0, categoryId: 0, word: orig));
  }

  @override
  Future createDatabase() async {
    Category fav = Category(id: 0, name: Featured);
    _categoriesDb.add(fav);
  }

  @override
  Future<List<LastWord>> getBookMarksAsync() async {
    return _bookmarks;
  }

  @override
  Future<List<CategoryInfo>> getCategoriesAsync() async {
    return _categories;
  }

  @override
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo categoryInfo) async {
    var category = _categoriesDb.firstWhere((_) => _.name == categoryInfo.name, orElse: null); //TODO Выдать сущность БД

    return _links.where((_) => _.categoryId == category.id).map((_) => _.word).toList();
  }

  @override
  Future removeWordFromFavCategoryAsync(String orig) async {
    var categoriesToRemove = _links.where((_) => _.word == orig).toList();
    categoriesToRemove.forEach((c) => _links.remove(c));
  }

  @override
  Future saveBookmarkAsync(CategoryInfo categoryInfo, String word) async {
    var newBookMark = LastWord(id: _bookmarks.length + 1, word: word, category: categoryInfo.name);
    return _bookmarks.add(newBookMark);
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