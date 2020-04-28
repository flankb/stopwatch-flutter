import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnwords/resources/dict_parser_repository.dart';
import 'package:learnwords/resources/word_category_repository.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void main() {
  group('Repositories tests', ()
  {
    WordCategoryRepository _categoryRepository;
    DictParserRepository _wordRepository;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      sqfliteFfiTestInit();


      _categoryRepository = WordCategoryRepository();
      _wordRepository = DictParserRepository();

      //await PlatformAssetBundle.loadAssets(MainDb.getAssetNames());
    });

    test("FloorRepository test", () async {
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