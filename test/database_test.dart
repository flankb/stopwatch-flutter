import 'package:flutter_test/flutter_test.dart';
import 'package:learnwords/dao/database_dao.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/resources/floor_repository.dart';
import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiTestInit();

  group('database tests', () {
    AppDatabase database;
    CategoryDao categoryDao;

    setUp(() async {
      database = await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .build();

      categoryDao = database.categoryDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('Insert and check category', () async {
      final category = Category(id: null, name: "Clothes");
      await categoryDao.insertCategory(category);

      final actual = await categoryDao.findCategoryByName("Clothes");
      expect(actual.name, equals(category.name));
    });
  });
}