import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:learnwords/models/word.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

import 'base/base_repository.dart';

class WordsJsonRepository implements BaseWordsRepository {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/dictionary.txt');
  }

  Future<String> _readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }

  Future<List<Word>> getWords() async {
    String jsonVals = await _readFile();
    await Future.delayed(Duration(seconds: 3));

    developer.log(jsonVals, name: 'LOG_1');

    // https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
    final List<dynamic> jsonResponse = json.decode(jsonVals);

    final words = jsonResponse.map<Word>((w) => Word.fromJson(w)).toList();
    return  words;
  }

  Future<String> generateWords() async {
    Word word1 = Word("Name", "Имя");
    Word word2 = Word("Street", "Улица");
    Word word3 = Word("Capital", "Столица");

    List<Word> words = List<Word>();
    words.add(word1);
    words.add(word2);
    words.add(word3);

    String jsonList = jsonEncode(words
        .map<Word>((w) => w)
        .toList());

    final file = await _localFile;

    await file.writeAsString(jsonList);

    // Write the file.
    return  jsonList;
  }
}
