import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:learnwords/models/word.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/resources/base/base_word_repository.dart';
import 'package:learnwords/util/FileUtils.dart';
import 'package:path_provider/path_provider.dart';

bool equalsIgnoreCase(String a, String b) =>
    (a == null && b == null) ||
        (a != null && b != null && a.toLowerCase() == b.toLowerCase());

extension containsIterableExtension on List<String> {
  bool containsIgnoreCase(String str){
    if(this == null || str == null){
      return false;
    }

    final item = this.firstWhere((_) {
      return equalsIgnoreCase(_, str);
    }, orElse: () => null);

    return item != null;
  }
}

class DictParserRepository implements BaseWordRepository {
  List<WordDict> _allWords;

  WordDict _findWord(String word) {
    return _allWords.firstWhere((_) {
      return equalsIgnoreCase(_.orig, word);
    }, orElse: () => null);
  }

  @override
  Future<List<WordDict>> getWords(/*String path*/) async {
    debugPrint('Start parseDict!');

    if (_allWords != null) {
      return _allWords;
    }

    String body = await FileUtils.readFileFromAsset('assets/mueller-base.dict.dz.uncompressed');
    List<String> lines = body.split('\n').where((String s) => s != '').skip(1000).toList();
    //lines = lines.where((String s) => s != '').skip(264); // Убираем пустые значения

    debugPrint("Lines len: " + lines.length.toString());
    debugPrint("Random line: " + lines[505]);

    RegExp latin = new RegExp(r'[A-Za-z]');

    WordDict newWord = WordDict();

    List<WordDict> words = List();

    for(String line in lines) {
      // Без пробелов начинается слово
      // С 2-х пробелов - транскрипция
      // С 4-х пробелов - перевод

      // Если вариантов перевода много, каждый из них начинается на цифру со скобкой, например 4)

      // Можно пока просто считать все строки, относящиеся к слову в специальный объект (List<String> raw)
      if (line.startsWith(latin)) {
        if (newWord.orig != null && newWord.orig.isNotEmpty) {
          words.add(newWord);
        }

        newWord = WordDict();
        newWord.orig = line;
      }
      else {
        newWord.raw.add(line);
      }
      /*else if (line.startsWith('  ')){
        // Вырезать то, что внутри []
        newWord.transcription = line.substring(line.indexOf('['), line.indexOf(']'));
      }*/
    }

    debugPrint("Words len: " + words.length.toString());

    _allWords = words;
    return words;
  }

  @override
  Future<List<WordDict>> getSpecificWordsAsync(List<String> words) async {
    await getWords();

    //TODO Здесь не обращать внимания на регистр

    //List<WordDict> specificWords = List();
    //words.map(f)

    // Выбираем только нужные слова
    List<WordDict> specificWords = _allWords.where((WordDict wd) => words.contains(wd.orig)).toList();

    return specificWords;
  }

  /*bool containsIgnoreCaseE(List<String> input, String str){
    //debugPrint("inputsdfdsf" + input.length.toString());
    if(input == null || str == null){
      return false;
    }

    final item = input.firstWhere((_) => _ == str, orElse: () => null);

    return item != null;
  }*/
}

/*
Если вариант один, то слово может выглядеть сл. образом
doctoral

  [ˈdɔktərəl] _a. докторский
*/

/** Более хитрый пример
 *
dock-master

    [ˈdɔkˌma:stə] _n. начальник дока
dockage

    I [ˈdɔkɪʤ] _n.

    1) стоянка судов в доках

    2) сбор за пользование доком

    II [ˈdɔkɪʤ] _n. сокращение, урезка
dock-dues

    [ˈdɔkdju:z] = dockage I, 2)
docker

    [ˈdɔkə] _n. докер, портовый рабочий
 */

/*
*
fugitive

  [ˈfju:ʤɪtɪv]

    1. _n.

      1) беглец

      2) беженец

      3) дезертир

    2. _a.

      1) беглый

      2) мимолётный, непрочный

      3): fugitive verse стихотворение, сочинённое по какому-л. случаю
fugle

  [ˈfju:gl] _v. руководить; служить образцом
fugleman

  [ˈfju:glmæn] _n.

    1) вожак; человек, служащий примером

    2) _воен. _уст. флигельман
fugue

  [fju:g] _n. _муз. фуга
fulcra

  [ˈfʌlkrə] _pl. от fulcrum
fulcrum

  [ˈfʌlkrəm] _n. (_pl. -ra)

    1) _физ. точка опоры (рычага)

    2) средство достижения цели

    3) _тех. ось или центр шарнира
fulfil

  [fulˈfɪl] _v.

    1) выполнять; исполнять, осуществлять; to fulfil the quota выполнять
    норму; to fulfil a promise выполнять обещание

    2) завершать

    3) удовлетворять (требованиям, условиям и т.п.); to fulfil oneself
    достичь совершенства (в пределах своих возможностей), наиболее полно
    выразить себя
*
* */