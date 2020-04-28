

import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/category_info.dart';

abstract class BaseDatabaseRepository {
  Future createDatabase();
  Future removeWordFromFavCategoryAsync(String orig);
  Future<List<CategoryInfo>> getCategoriesAsync();
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo categoryInfo);
  Future addWordToFavCategoryAsync(String orig);
  Future saveBookmarkAsync(CategoryInfo categoryInfo, String word);
  Future<List<LastWord>> getBookMarksAsync();
}