import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnwords/models/category_info.dart';
import 'package:learnwords/models/persistent_type.dart';
import 'package:learnwords/scope_models/learn_words_model.dart';

import 'fake_repos.dart';

// Варианты запуска тестов:
// flutter test test/counter_test.dart
// dart test/fetch_post_test.dart  //(Mockito)
//

void main() {
  group("Main scope model tests", () {
    LearnWordsModel _testModel;

    setUp(() async {
      _testModel = LearnWordsModel(categoryRepository: FakeCategoriesRepository(),
          dictRepository: FakeWordRepository());

      await _testModel.loadAllModelAsync();
    });

    test("Common process", () async {
      expect(_testModel.selectedCategory.name, equals(""), reason: "Wrong check category!");
      var len = _testModel.wordsDict.length;

      expect(len, greaterThan(0));

      var category = _testModel.categories.where((c) => c.name == "Cars").single;
      //Выбираем категорию
      await _testModel.updateCategoryAsync(category);

      expect(_testModel.selectedCategory.name, equals("Cars"));

      //Загружаем слова, проверяем, что они соотв. категории
      var word = _testModel.wordsDict.first;

      FakeCategoriesRepository fcr = FakeCategoriesRepository();
      var words = await fcr.getWordsByCategoryAsync(_testModel.selectedCategory);

      expect(words.contains(word.orig), equals(true));

      //Сохраняем закладку, проверяем, что закладка сохранена

      await _testModel.loadBookmarksAsync();
      debugPrint("_testModel.selectedCategory.name " + _testModel.selectedCategory.name);

      final index = await _testModel.getBookmarkIndexAsync();

      expect(index, greaterThan(-1));

      var len2 = _testModel.wordsDict.length;

      expect(len2, lessThan(len));
      expect(_testModel.getWordIndex(word), equals(0), reason: "Error") ;




      expect(_testModel.wordsDict.length, equals(0));
    });


    test("Search test", () async {
      await _testModel.updateCategoryAsync(CategoryInfo.empty());

      await  _testModel.searchAsync("way");
      expect(_testModel.searchResult.length, greaterThan(0));
    });
  });
}