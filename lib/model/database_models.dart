
import 'package:floor/floor.dart';

@Entity(tableName: 'last_word')
class LastWord {
  @PrimaryKey(autoGenerate: true)
  final int id; // TODO Передавать null для инициализации

  @ColumnInfo(name: 'category', nullable: false)
  final String category;

  @ColumnInfo(nullable: false)
  final String word;

  @ColumnInfo(nullable: false)
  final String locale;

  @ColumnInfo()
  final bool isLast;

  @ColumnInfo()
  final String comment;

  @ColumnInfo()
  final int date;

  LastWord({this.id,
    this.category,
    this.word,
    this.locale="ru",
    this.isLast = true,
    // ignore: avoid_init_to_null
    this.comment = null,
    this.date = 0 });
}

@Entity(tableName: 'category')
class Category {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(nullable: false)
  final String name;

  @ColumnInfo(nullable: false)
  final String locale;

  @ColumnInfo(nullable: false)
  final int order;

  @ColumnInfo()
  final String translation;

  Category({this.id,
    this.name,
    this.locale = 'ru',
    this.order = 0,
    // ignore: avoid_init_to_null
    this.translation = null
  });
}


@Entity(
  tableName: 'ml_category_word',
  foreignKeys: [
    ForeignKey(
      childColumns: ['category_id'],
      parentColumns: ['id'],
      entity: Category,
    )
  ],
)
class MlCategoryWord {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: "category_id", nullable: false)
  final int categoryId;

  @ColumnInfo(nullable: false)
  final String word;

  MlCategoryWord({this.id,
    this.categoryId,
    this.word});
}