// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_repository.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LastWordDao _lastWordDaoInstance;

  CategoryDao _categoryDaoInstance;

  MlCategoryWordDao _mlCategoryWordDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `last_word` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category` TEXT NOT NULL, `word` TEXT NOT NULL, `locale` TEXT NOT NULL, `isLast` INTEGER, `comment` TEXT, `date` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `locale` TEXT NOT NULL, `order` INTEGER NOT NULL, `translation` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ml_category_word` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_id` INTEGER NOT NULL, `word` TEXT NOT NULL, FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  LastWordDao get lastWordDao {
    return _lastWordDaoInstance ??= _$LastWordDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  MlCategoryWordDao get mlCategoryWordDao {
    return _mlCategoryWordDaoInstance ??=
        _$MlCategoryWordDao(database, changeListener);
  }
}

class _$LastWordDao extends LastWordDao {
  _$LastWordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lastWordInsertionAdapter = InsertionAdapter(
            database,
            'last_word',
            (LastWord item) => <String, dynamic>{
                  'id': item.id,
                  'category': item.category,
                  'word': item.word,
                  'locale': item.locale,
                  'isLast': item.isLast ? 1 : 0,
                  'comment': item.comment,
                  'date': item.date
                }),
        _lastWordUpdateAdapter = UpdateAdapter(
            database,
            'last_word',
            ['id'],
            (LastWord item) => <String, dynamic>{
                  'id': item.id,
                  'category': item.category,
                  'word': item.word,
                  'locale': item.locale,
                  'isLast': item.isLast ? 1 : 0,
                  'comment': item.comment,
                  'date': item.date
                }),
        _lastWordDeletionAdapter = DeletionAdapter(
            database,
            'last_word',
            ['id'],
            (LastWord item) => <String, dynamic>{
                  'id': item.id,
                  'category': item.category,
                  'word': item.word,
                  'locale': item.locale,
                  'isLast': item.isLast ? 1 : 0,
                  'comment': item.comment,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _last_wordMapper = (Map<String, dynamic> row) => LastWord(
      id: row['id'] as int,
      category: row['category'] as String,
      word: row['word'] as String,
      locale: row['locale'] as String,
      isLast: (row['isLast'] as int) != 0,
      comment: row['comment'] as String,
      date: row['date'] as int);

  final InsertionAdapter<LastWord> _lastWordInsertionAdapter;

  final UpdateAdapter<LastWord> _lastWordUpdateAdapter;

  final DeletionAdapter<LastWord> _lastWordDeletionAdapter;

  @override
  Future<List<LastWord>> findAllLastWords() async {
    return _queryAdapter.queryList('SELECT * FROM last_word',
        mapper: _last_wordMapper);
  }

  @override
  Future<List<LastWord>> findLastWordByCategory(String category) async {
    return _queryAdapter.queryList('SELECT * FROM last_word WHERE category = ?',
        arguments: <dynamic>[category], mapper: _last_wordMapper);
  }

  @override
  Future<void> insertLastWord(LastWord lastWord) async {
    await _lastWordInsertionAdapter.insert(
        lastWord, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<int> updatePersons(List<LastWord> person) {
    return _lastWordUpdateAdapter.updateListAndReturnChangedRows(
        person, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteBookmarks(List<LastWord> lastWords) {
    return _lastWordDeletionAdapter.deleteListAndReturnChangedRows(lastWords);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'category',
            (Category item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'locale': item.locale,
                  'order': item.order,
                  'translation': item.translation
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _categoryMapper = (Map<String, dynamic> row) => Category(
      id: row['id'] as int,
      name: row['name'] as String,
      locale: row['locale'] as String,
      order: row['order'] as int,
      translation: row['translation'] as String);

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  @override
  Future<List<Category>> findAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM category',
        mapper: _categoryMapper);
  }

  @override
  Future<Category> findCategoryByName(String name) async {
    return _queryAdapter.query('SELECT * FROM category WHERE name = ?',
        arguments: <dynamic>[name], mapper: _categoryMapper);
  }

  @override
  Future<void> insertCategory(Category category) async {
    await _categoryInsertionAdapter.insert(
        category, sqflite.ConflictAlgorithm.replace);
  }
}

class _$MlCategoryWordDao extends MlCategoryWordDao {
  _$MlCategoryWordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _mlCategoryWordInsertionAdapter = InsertionAdapter(
            database,
            'ml_category_word',
            (MlCategoryWord item) => <String, dynamic>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'word': item.word
                }),
        _mlCategoryWordDeletionAdapter = DeletionAdapter(
            database,
            'ml_category_word',
            ['id'],
            (MlCategoryWord item) => <String, dynamic>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'word': item.word
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _ml_category_wordMapper = (Map<String, dynamic> row) =>
      MlCategoryWord(
          id: row['id'] as int,
          categoryId: row['category_id'] as int,
          word: row['word'] as String);

  final InsertionAdapter<MlCategoryWord> _mlCategoryWordInsertionAdapter;

  final DeletionAdapter<MlCategoryWord> _mlCategoryWordDeletionAdapter;

  @override
  Future<List<MlCategoryWord>> getWordsByCategory(int categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ml_category_word WHERE category_id = ?',
        arguments: <dynamic>[categoryId],
        mapper: _ml_category_wordMapper);
  }

  @override
  Future<List<MlCategoryWord>> getWordsByName(String word) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ml_category_word WHERE word = ?',
        arguments: <dynamic>[word],
        mapper: _ml_category_wordMapper);
  }

  @override
  Future<void> insertMlCategoryWordDao(MlCategoryWord link) async {
    await _mlCategoryWordInsertionAdapter.insert(
        link, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<int> deleteLinks(List<MlCategoryWord> links) {
    return _mlCategoryWordDeletionAdapter.deleteListAndReturnChangedRows(links);
  }
}
