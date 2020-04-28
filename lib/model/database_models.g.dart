// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_models.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Lap extends DataClass implements Insertable<Lap> {
  final int id;
  final int measureId;
  final int overall;
  final String comment;
  Lap(
      {@required this.id,
      @required this.measureId,
      @required this.overall,
      @required this.comment});
  factory Lap.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Lap(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      measureId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}measure_id']),
      overall:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}overall']),
      comment:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  factory Lap.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Lap(
      id: serializer.fromJson<int>(json['id']),
      measureId: serializer.fromJson<int>(json['measureId']),
      overall: serializer.fromJson<int>(json['overall']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measureId': serializer.toJson<int>(measureId),
      'overall': serializer.toJson<int>(overall),
      'comment': serializer.toJson<String>(comment),
    };
  }

  @override
  LapsCompanion createCompanion(bool nullToAbsent) {
    return LapsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      measureId: measureId == null && nullToAbsent
          ? const Value.absent()
          : Value(measureId),
      overall: overall == null && nullToAbsent
          ? const Value.absent()
          : Value(overall),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  Lap copyWith({int id, int measureId, int overall, String comment}) => Lap(
        id: id ?? this.id,
        measureId: measureId ?? this.measureId,
        overall: overall ?? this.overall,
        comment: comment ?? this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('Lap(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('overall: $overall, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(measureId.hashCode, $mrjc(overall.hashCode, comment.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Lap &&
          other.id == this.id &&
          other.measureId == this.measureId &&
          other.overall == this.overall &&
          other.comment == this.comment);
}

class LapsCompanion extends UpdateCompanion<Lap> {
  final Value<int> id;
  final Value<int> measureId;
  final Value<int> overall;
  final Value<String> comment;
  const LapsCompanion({
    this.id = const Value.absent(),
    this.measureId = const Value.absent(),
    this.overall = const Value.absent(),
    this.comment = const Value.absent(),
  });
  LapsCompanion.insert({
    this.id = const Value.absent(),
    @required int measureId,
    @required int overall,
    @required String comment,
  })  : measureId = Value(measureId),
        overall = Value(overall),
        comment = Value(comment);
  LapsCompanion copyWith(
      {Value<int> id,
      Value<int> measureId,
      Value<int> overall,
      Value<String> comment}) {
    return LapsCompanion(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      overall: overall ?? this.overall,
      comment: comment ?? this.comment,
    );
  }
}

class $LapsTable extends Laps with TableInfo<$LapsTable, Lap> {
  final GeneratedDatabase _db;
  final String _alias;
  $LapsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _measureIdMeta = const VerificationMeta('measureId');
  GeneratedIntColumn _measureId;
  @override
  GeneratedIntColumn get measureId => _measureId ??= _constructMeasureId();
  GeneratedIntColumn _constructMeasureId() {
    return GeneratedIntColumn('measure_id', $tableName, false,
        $customConstraints: 'REFERENCES measures(id) ON DELETE CASCADE');
  }

  final VerificationMeta _overallMeta = const VerificationMeta('overall');
  GeneratedIntColumn _overall;
  @override
  GeneratedIntColumn get overall => _overall ??= _constructOverall();
  GeneratedIntColumn _constructOverall() {
    return GeneratedIntColumn(
      'overall',
      $tableName,
      false,
    );
  }

  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  GeneratedTextColumn _comment;
  @override
  GeneratedTextColumn get comment => _comment ??= _constructComment();
  GeneratedTextColumn _constructComment() {
    return GeneratedTextColumn(
      'comment',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, measureId, overall, comment];
  @override
  $LapsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'laps';
  @override
  final String actualTableName = 'laps';
  @override
  VerificationContext validateIntegrity(LapsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.measureId.present) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableValue(d.measureId.value, _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (d.overall.present) {
      context.handle(_overallMeta,
          overall.isAcceptableValue(d.overall.value, _overallMeta));
    } else if (isInserting) {
      context.missing(_overallMeta);
    }
    if (d.comment.present) {
      context.handle(_commentMeta,
          comment.isAcceptableValue(d.comment.value, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lap map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Lap.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LapsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.measureId.present) {
      map['measure_id'] = Variable<int, IntType>(d.measureId.value);
    }
    if (d.overall.present) {
      map['overall'] = Variable<int, IntType>(d.overall.value);
    }
    if (d.comment.present) {
      map['comment'] = Variable<String, StringType>(d.comment.value);
    }
    return map;
  }

  @override
  $LapsTable createAlias(String alias) {
    return $LapsTable(_db, alias);
  }
}

class Measure extends DataClass implements Insertable<Measure> {
  final int id;
  final int elapsed;
  final DateTime dateCreated;
  final int status;
  final String comment;
  Measure(
      {@required this.id,
      @required this.elapsed,
      @required this.dateCreated,
      @required this.status,
      @required this.comment});
  factory Measure.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return Measure(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      elapsed:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}elapsed']),
      dateCreated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created']),
      status: intType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
      comment:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  factory Measure.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<int>(json['id']),
      elapsed: serializer.fromJson<int>(json['elapsed']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      status: serializer.fromJson<int>(json['status']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'elapsed': serializer.toJson<int>(elapsed),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'status': serializer.toJson<int>(status),
      'comment': serializer.toJson<String>(comment),
    };
  }

  @override
  MeasuresCompanion createCompanion(bool nullToAbsent) {
    return MeasuresCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      elapsed: elapsed == null && nullToAbsent
          ? const Value.absent()
          : Value(elapsed),
      dateCreated: dateCreated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateCreated),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  Measure copyWith(
          {int id,
          int elapsed,
          DateTime dateCreated,
          int status,
          String comment}) =>
      Measure(
        id: id ?? this.id,
        elapsed: elapsed ?? this.elapsed,
        dateCreated: dateCreated ?? this.dateCreated,
        status: status ?? this.status,
        comment: comment ?? this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('Measure(')
          ..write('id: $id, ')
          ..write('elapsed: $elapsed, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('status: $status, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          elapsed.hashCode,
          $mrjc(dateCreated.hashCode,
              $mrjc(status.hashCode, comment.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Measure &&
          other.id == this.id &&
          other.elapsed == this.elapsed &&
          other.dateCreated == this.dateCreated &&
          other.status == this.status &&
          other.comment == this.comment);
}

class MeasuresCompanion extends UpdateCompanion<Measure> {
  final Value<int> id;
  final Value<int> elapsed;
  final Value<DateTime> dateCreated;
  final Value<int> status;
  final Value<String> comment;
  const MeasuresCompanion({
    this.id = const Value.absent(),
    this.elapsed = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.status = const Value.absent(),
    this.comment = const Value.absent(),
  });
  MeasuresCompanion.insert({
    this.id = const Value.absent(),
    @required int elapsed,
    @required DateTime dateCreated,
    @required int status,
    @required String comment,
  })  : elapsed = Value(elapsed),
        dateCreated = Value(dateCreated),
        status = Value(status),
        comment = Value(comment);
  MeasuresCompanion copyWith(
      {Value<int> id,
      Value<int> elapsed,
      Value<DateTime> dateCreated,
      Value<int> status,
      Value<String> comment}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      elapsed: elapsed ?? this.elapsed,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      comment: comment ?? this.comment,
    );
  }
}

class $MeasuresTable extends Measures with TableInfo<$MeasuresTable, Measure> {
  final GeneratedDatabase _db;
  final String _alias;
  $MeasuresTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _elapsedMeta = const VerificationMeta('elapsed');
  GeneratedIntColumn _elapsed;
  @override
  GeneratedIntColumn get elapsed => _elapsed ??= _constructElapsed();
  GeneratedIntColumn _constructElapsed() {
    return GeneratedIntColumn(
      'elapsed',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  GeneratedDateTimeColumn _dateCreated;
  @override
  GeneratedDateTimeColumn get dateCreated =>
      _dateCreated ??= _constructDateCreated();
  GeneratedDateTimeColumn _constructDateCreated() {
    return GeneratedDateTimeColumn(
      'date_created',
      $tableName,
      false,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedIntColumn _status;
  @override
  GeneratedIntColumn get status => _status ??= _constructStatus();
  GeneratedIntColumn _constructStatus() {
    return GeneratedIntColumn(
      'status',
      $tableName,
      false,
    );
  }

  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  GeneratedTextColumn _comment;
  @override
  GeneratedTextColumn get comment => _comment ??= _constructComment();
  GeneratedTextColumn _constructComment() {
    return GeneratedTextColumn(
      'comment',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, elapsed, dateCreated, status, comment];
  @override
  $MeasuresTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'measures';
  @override
  final String actualTableName = 'measures';
  @override
  VerificationContext validateIntegrity(MeasuresCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.elapsed.present) {
      context.handle(_elapsedMeta,
          elapsed.isAcceptableValue(d.elapsed.value, _elapsedMeta));
    } else if (isInserting) {
      context.missing(_elapsedMeta);
    }
    if (d.dateCreated.present) {
      context.handle(_dateCreatedMeta,
          dateCreated.isAcceptableValue(d.dateCreated.value, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (d.status.present) {
      context.handle(
          _statusMeta, status.isAcceptableValue(d.status.value, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (d.comment.present) {
      context.handle(_commentMeta,
          comment.isAcceptableValue(d.comment.value, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measure map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Measure.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MeasuresCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.elapsed.present) {
      map['elapsed'] = Variable<int, IntType>(d.elapsed.value);
    }
    if (d.dateCreated.present) {
      map['date_created'] =
          Variable<DateTime, DateTimeType>(d.dateCreated.value);
    }
    if (d.status.present) {
      map['status'] = Variable<int, IntType>(d.status.value);
    }
    if (d.comment.present) {
      map['comment'] = Variable<String, StringType>(d.comment.value);
    }
    return map;
  }

  @override
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(_db, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final DateTime dateCreated;
  final int frequency;
  final String name;
  Tag(
      {@required this.id,
      @required this.dateCreated,
      @required this.frequency,
      @required this.name});
  factory Tag.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return Tag(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      dateCreated: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created']),
      frequency:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}frequency']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      frequency: serializer.fromJson<int>(json['frequency']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'frequency': serializer.toJson<int>(frequency),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  TagsCompanion createCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      dateCreated: dateCreated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateCreated),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Tag copyWith({int id, DateTime dateCreated, int frequency, String name}) =>
      Tag(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        frequency: frequency ?? this.frequency,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('frequency: $frequency, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(dateCreated.hashCode, $mrjc(frequency.hashCode, name.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.dateCreated == this.dateCreated &&
          other.frequency == this.frequency &&
          other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<DateTime> dateCreated;
  final Value<int> frequency;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.frequency = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    @required DateTime dateCreated,
    @required int frequency,
    @required String name,
  })  : dateCreated = Value(dateCreated),
        frequency = Value(frequency),
        name = Value(name);
  TagsCompanion copyWith(
      {Value<int> id,
      Value<DateTime> dateCreated,
      Value<int> frequency,
      Value<String> name}) {
    return TagsCompanion(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      frequency: frequency ?? this.frequency,
      name: name ?? this.name,
    );
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  final GeneratedDatabase _db;
  final String _alias;
  $TagsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  GeneratedDateTimeColumn _dateCreated;
  @override
  GeneratedDateTimeColumn get dateCreated =>
      _dateCreated ??= _constructDateCreated();
  GeneratedDateTimeColumn _constructDateCreated() {
    return GeneratedDateTimeColumn(
      'date_created',
      $tableName,
      false,
    );
  }

  final VerificationMeta _frequencyMeta = const VerificationMeta('frequency');
  GeneratedIntColumn _frequency;
  @override
  GeneratedIntColumn get frequency => _frequency ??= _constructFrequency();
  GeneratedIntColumn _constructFrequency() {
    return GeneratedIntColumn(
      'frequency',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, dateCreated, frequency, name];
  @override
  $TagsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tags';
  @override
  final String actualTableName = 'tags';
  @override
  VerificationContext validateIntegrity(TagsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.dateCreated.present) {
      context.handle(_dateCreatedMeta,
          dateCreated.isAcceptableValue(d.dateCreated.value, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (d.frequency.present) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableValue(d.frequency.value, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Tag.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TagsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.dateCreated.present) {
      map['date_created'] =
          Variable<DateTime, DateTimeType>(d.dateCreated.value);
    }
    if (d.frequency.present) {
      map['frequency'] = Variable<int, IntType>(d.frequency.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LapsTable _laps;
  $LapsTable get laps => _laps ??= $LapsTable(this);
  $MeasuresTable _measures;
  $MeasuresTable get measures => _measures ??= $MeasuresTable(this);
  $TagsTable _tags;
  $TagsTable get tags => _tags ??= $TagsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [laps, measures, tags];
}
