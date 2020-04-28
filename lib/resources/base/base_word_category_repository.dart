
import 'package:learnwords/models/category_info.dart';

abstract class BaseWordCategoryRepository {
  Future<List<CategoryInfo>> getCategoriesAsync();
  Future<List<String>> getWordsByCategoryAsync(CategoryInfo category);

  Future<CategoryInfo> getSelectedCategoryAsync();
  Future saveCategoryAsync(CategoryInfo category);
}