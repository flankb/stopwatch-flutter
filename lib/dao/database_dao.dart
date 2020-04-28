import 'package:floor/floor.dart';
import 'package:learnwords/model/database_models.dart';

@dao
abstract class LastWordDao {
  @Query('SELECT * FROM last_word')
  Future<List<LastWord>> findAllLastWords();

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertLastWord(LastWord lastWord);

  @Query('SELECT * FROM last_word WHERE category = :category')
  Future<List<LastWord>> findLastWordByCategory(String category);

  @update
  Future<int> updatePersons(List<LastWord> person);

  @delete
  Future<int> deleteBookmarks(List<LastWord> lastWords);
}


@dao
abstract class CategoryDao {
  @Query('SELECT * FROM category')
  Future<List<Category>> findAllCategories();

  @Query('SELECT * FROM category WHERE name = :name')
  Future<Category> findCategoryByName(String name);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertCategory(Category category);
}


@dao
abstract class MlCategoryWordDao {
  @Query('SELECT * FROM ml_category_word WHERE category_id = :categoryId')
  Future<List<MlCategoryWord>> getWordsByCategory(int categoryId);

  @Query('SELECT * FROM ml_category_word WHERE word = :word')
  Future<List<MlCategoryWord>> getWordsByName(String word);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertMlCategoryWordDao(MlCategoryWord link);

  @delete
  Future<int> deleteLinks(List<MlCategoryWord> links);
}

