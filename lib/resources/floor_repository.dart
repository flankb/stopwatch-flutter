import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:learnwords/dao/database_dao.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/category_info.dart';
import 'package:learnwords/resources/base/base_database_repository.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'floor_repository.g.dart';

const String Featured = "Featured";

@Database(version: 1, entities: [LastWord, Category, MlCategoryWord])
abstract class AppDatabase extends FloorDatabase {
  //LastWordDao get lastWordDao;
  LastWordDao get lastWordDao;
  CategoryDao get categoryDao;
  MlCategoryWordDao get mlCategoryWordDao;
}

class FloorRepository implements BaseDatabaseRepository {
  AppDatabase database;
  Category _featuredCategory;
  
  Future createDatabase() async {
    /*final*/
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Создадим Категорию с избранными значениями
    _featuredCategory = await database.categoryDao.findCategoryByName(Featured);
    
    if (_featuredCategory == null) {
       var featuredCategory = Category(id: null, name: Featured, translation: "Избранные");
       await database.categoryDao.insertCategory(featuredCategory); // TODO При первом запуске программы идентификатор здесь не проставляется!
       _featuredCategory = await database.categoryDao.findCategoryByName(Featured); //TODO Поэтому проставим здесь нахождение
    }
  }

  @override
  Future addWordToFavCategoryAsync(String orig) async {
    debugPrint("addWordToFavCategoryAsync ${_featuredCategory.id} ${orig}");

    final ml = MlCategoryWord(id: null, categoryId: _featuredCategory.id, word: orig);
    await database.mlCategoryWordDao.insertMlCategoryWordDao(ml);
  }

  @override
  Future<List<CategoryInfo>> getCategoriesAsync() async {
    var listCategories = await database.categoryDao.findAllCategories();
    var listCategoryInfos = listCategories.map( (_) => CategoryInfo.fromDatabase(_)).toList();
    return listCategoryInfos;
  }

  @override
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo categoryInfo) async {
    var category = await database.categoryDao.findCategoryByName(categoryInfo.name);

    if (category == null) {
      return List<String>();
    }

    debugPrint("getWordsByCategoryAsync ${category.id} ${category.name}, ${category.translation}");

    var words = (await database.mlCategoryWordDao.getWordsByCategory(category.id)).map((_) => _.word).toList();
    return words;
  }

  @override
  Future saveBookmarkAsync(CategoryInfo categoryInfo, String word) async {
    //var bookmark = LastWord(id: null, category: categoryInfo.name, word: word);

    // TODO Здесь по-хорошему бы обновить закладку, а для этого сначала найдем такую же с категорией
    List<LastWord> categories = await database.lastWordDao.findLastWordByCategory(categoryInfo.name);
    debugPrint("deletedLastWords " + categories.toString() + " " + categoryInfo.name);

    int idto;
    if(categories != null && categories.length > 0) {
        idto = categories[0].id;

        // TODO Пока что удалим все закладки, связанные с данной категорией
        var cnt = await database.lastWordDao.deleteBookmarks(categories);
        debugPrint("deletedLastWords " + cnt.toString());
    }

    //TODO Сделать выборку всю и посчитать количество
    //var allMarks = await database.lastWordDao.findAllLastWords();
    //debugPrint("deletedLastWords counts " + allMarks.length.toString());

    var copy = LastWord(id: idto, category: categoryInfo.name, word: word);

    debugPrint("_saveBookmarkAsync db " + copy.word);
    await database.lastWordDao.insertLastWord(copy);

    //categories.forEach((LastWord lw) => LastWord(id: lw.id, category: lw.category, word: word));
    //await database.lastWordDao.updatePersons(categories);
  }

  @override
  Future<List<LastWord>> getBookMarksAsync() async {
    return await database.lastWordDao.findAllLastWords();
  }

  @override
  Future removeWordFromFavCategoryAsync(String orig) async {
    var words = await database.mlCategoryWordDao.getWordsByName(orig);
    await database.mlCategoryWordDao.deleteLinks(words);
  }
}