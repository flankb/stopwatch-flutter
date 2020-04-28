
import 'dart:convert';
import 'dart:core';

import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/category_info.dart';
import 'package:learnwords/models/persistent_type.dart';
import 'package:learnwords/resources/base/base_word_category_repository.dart';
import 'package:learnwords/util/FileUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordCategoryRepository implements BaseWordCategoryRepository {
  List<String> _categoryLines;
   static const String CATEGORY = "category";

  _readAllLinesAsync() async {
    if (_categoryLines == null) {
      String body = await FileUtils.readFileFromAsset('assets/words_by_categ.txt');
      _categoryLines = body.split('\n').toList();
    }
  }

  CategoryInfo _getHeader(String raw) {
    var mas = raw.split(':');
    return CategoryInfo(name: mas[0], translation: mas[1]/*.trimRight()*/, persistentType: PersistentType.File);
  }

  @override
  Future<List<CategoryInfo>> getCategoriesAsync() async {
    await _readAllLinesAsync();
    List<String> categs = _categoryLines
        .where((String s) => s.startsWith('#'))
        .map((String s) =>  s.substring(1))
        .toList();

    categs = categs.where((_) => !_.startsWith("Irregular")).toList();
    
    List<CategoryInfo> categoryInfos = categs.map((String name) => _getHeader(name)).toList();

    //TODO Пока не загружать неправильные глаголы!! (Irregular Verbs)
    //TODO Также пока нет Prehistoric
    //TODO Vehicles Удалить пробелы в начале

    return categoryInfos;
  }

  @override
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo category) async {
    await _readAllLinesAsync();

    int index = _categoryLines.indexOf("#${category.name}:${category.translation}");

    String word = "";

    List<String> result = List<String>();

    while(!word.startsWith("#") && index < _categoryLines.length - 1){
      index++;
      word = _categoryLines[index];

      if(word.length > 2){
        result.add(word);
      }
    }

    return result;
  }

  @override
  Future<CategoryInfo> getSelectedCategoryAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String category = (prefs.getString(CATEGORY) ?? "");

    if (category == "") {
      return CategoryInfo.empty();
    }

    try{
      Map<String, dynamic> categoryInfo = jsonDecode(category);
      return CategoryInfo.fromJson(categoryInfo);
    }
    catch(ex) {
      return CategoryInfo.empty();
    }
  }

  @override
  Future saveCategoryAsync(CategoryInfo category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(category);
    await prefs.setString(CATEGORY, json);
  }
}