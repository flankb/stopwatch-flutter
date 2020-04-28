
import 'package:learnwords/models/word_dict.dart';

abstract class BaseWordRepository {
  Future<List<WordDict>> getWords();
  Future<List<WordDict>> getSpecificWordsAsync(List<String> words);
}