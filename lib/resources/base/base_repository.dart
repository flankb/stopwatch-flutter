
import '../../models/word.dart';

@Deprecated("Deprecated repository")
abstract class BaseWordsRepository {
  Future<List<Word>> getWords();
  Future<String> generateWords();
}