// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_models.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Lap extends DataClass implements Insertable<Lap> {
  final int id;
  final int measureId;
  final int difference;
  final int order;
  final int overall;
  final String comment;
  Lap(
      {@required this.id,
      @required this.measureId,
      @required this.difference,
      @required this.order,
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
      difference:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}difference']),
      order: intType.mapFromDatabaseResponse(data['${effectivePrefix}order']),
      overall:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}overall']),
      comment:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || measureId != null) {
      map['measure_id'] = Variable<int>(measureId);
    }
    if (!nullToAbsent || difference != null) {
      map['difference'] = Variable<int>(difference);
    }
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    if (!nullToAbsent || overall != null) {
      map['overall'] = Variable<int>(overall);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  LapsCompanion toCompanion(bool nullToAbsent) {
    return LapsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      measureId: measureId == null && nullToAbsent
          ? const Value.absent()
          : Value(measureId),
      difference: difference == null && nullToAbsent
          ? const Value.absent()
          : Value(difference),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      overall: overall == null && nullToAbsent
          ? const Value.absent()
          : Value(overall),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory Lap.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Lap(
      id: serializer.fromJson<int>(json['id']),
      measureId: serializer.fromJson<int>(json['measureId']),
      difference: serializer.fromJson<int>(json['difference']),
      order: serializer.fromJson<int>(json['order']),
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
      'difference': serializer.toJson<int>(difference),
      'order': serializer.toJson<int>(order),
      'overall': serializer.toJson<int>(overall),
      'comment': serializer.toJson<String>(comment),
    };
  }

  Lap copyWith(
          {int id,
          int measureId,
          int difference,
          int order,
          int overall,
          String comment}) =>
      Lap(
        id: id ?? this.id,
        measureId: measureId ?? this.measureId,
        difference: difference ?? this.difference,
        order: order ?? this.order,
        overall: overall ?? this.overall,
        comment: comment ?? this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('Lap(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('difference: $difference, ')
          ..write('order: $order, ')
          ..write('overall: $overall, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          measureId.hashCode,
          $mrjc(
              difference.hashCode,
              $mrjc(order.hashCode,
                  $mrjc(overall.hashCode, comment.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Lap &&
          other.id == this.id &&
          other.measureId == this.measureId &&
          other.difference == this.difference &&
          other.order == this.order &&
          other.overall == this.overall &&
          other.comment == this.comment);
}

class LapsCompanion extends UpdateCompanion<Lap> {
  final Value<int> id;
  final Value<int> measureId;
  final Value<int> difference;
  final Value<int> order;
  final Value<int> overall;
  final Value<String> comment;
  const LapsCompanion({
    this.id = const Value.absent(),
    this.measureId = const Value.absent(),
    this.difference = const Value.absent(),
    this.order = const Value.absent(),
    this.overall = const Value.absent(),
    this.comment = const Value.absent(),
  });
  LapsCompanion.insert({
    this.id = const Value.absent(),
    @required int measureId,
    @required int difference,
    @required int order,
    @required int overall,
    @required String comment,
  })  : measureId = Value(measureId),
        difference = Value(difference),
        order = Value(order),
        overall = Value(overall),
        comment = Value(comment);
  static Insertable<Lap> custom({
    Expression<int> id,
    Expression<int> measureId,
    Expression<int> difference,
    Expression<int> order,
    Expression<int> overall,
    Expression<String> comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measureId != null) 'measure_id': measureId,
      if (difference != null) 'difference': difference,
      if (order != null) 'order': order,
      if (overall != null) 'overall': overall,
      if (comment != null) 'comment': comment,
    });
  }

  LapsCompanion copyWith(
      {Value<int> id,
      Value<int> measureId,
      Value<int> difference,
      Value<int> order,
      Value<int> overall,
      Value<String> comment}) {
    return LapsCompanion(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      difference: difference ?? this.difference,
      order: order ?? this.order,
      overall: overall ?? this.overall,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (measureId.present) {
      map['measure_id'] = Variable<int>(measureId.value);
    }
    if (difference.present) {
      map['difference'] = Variable<int>(difference.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (overall.present) {
      map['overall'] = Variable<int>(overall.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
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

  final VerificationMeta _differenceMeta = const VerificationMeta('difference');
  GeneratedIntColumn _difference;
  @override
  GeneratedIntColumn get difference => _difference ??= _constructDifference();
  GeneratedIntColumn _constructDifference() {
    return GeneratedIntColumn(
      'difference',
      $tableName,
      false,
    );
  }

  final VerificationMeta _orderMeta = const VerificationMeta('order');
  GeneratedIntColumn _order;
  @override
  GeneratedIntColumn get order => _order ??= _constructOrder();
  GeneratedIntColumn _constructOrder() {
    return GeneratedIntColumn(
      'order',
      $tableName,
      false,
    );
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
  List<GeneratedColumn> get $columns =>
      [id, measureId, difference, order, overall, comment];
  @override
  $LapsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'laps';
  @override
  final String actualTableName = 'laps';
  @override
  VerificationContext validateIntegrity(Insertable<Lap> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('measure_id')) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableOrUnknown(data['measure_id'], _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('difference')) {
      context.handle(
          _differenceMeta,
          difference.isAcceptableOrUnknown(
              data['difference'], _differenceMeta));
    } else if (isInserting) {
      context.missing(_differenceMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order'], _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('overall')) {
      context.handle(_overallMeta,
          overall.isAcceptableOrUnknown(data['overall'], _overallMeta));
    } else if (isInserting) {
      context.missing(_overallMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment'], _commentMeta));
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
  $LapsTable createAlias(String alias) {
    return $LapsTable(_db, alias);
  }
}

class Measure extends DataClass implements Insertable<Measure> {
  final int id;
  final int elapsed;
  final DateTime dateCreated;
  final String status;
  final String comment;
  Measure(
      {@required this.id,
      @required this.elapsed,
      @required this.dateCreated,
      @required this.status,
      this.comment});
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
      status:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
      comment:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || elapsed != null) {
      map['elapsed'] = Variable<int>(elapsed);
    }
    if (!nullToAbsent || dateCreated != null) {
      map['date_created'] = Variable<DateTime>(dateCreated);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  MeasuresCompanion toCompanion(bool nullToAbsent) {
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

  factory Measure.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<int>(json['id']),
      elapsed: serializer.fromJson<int>(json['elapsed']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      status: serializer.fromJson<String>(json['status']),
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
      'status': serializer.toJson<String>(status),
      'comment': serializer.toJson<String>(comment),
    };
  }

  Measure copyWith(
          {int id,
          int elapsed,
          DateTime dateCreated,
          String status,
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
  final Value<String> status;
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
    this.elapsed = const Value.absent(),
    @required DateTime dateCreated,
    @required String status,
    this.comment = const Value.absent(),
  })  : dateCreated = Value(dateCreated),
        status = Value(status);
  static Insertable<Measure> custom({
    Expression<int> id,
    Expression<int> elapsed,
    Expression<DateTime> dateCreated,
    Expression<String> status,
    Expression<String> comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (elapsed != null) 'elapsed': elapsed,
      if (dateCreated != null) 'date_created': dateCreated,
      if (status != null) 'status': status,
      if (comment != null) 'comment': comment,
    });
  }

  MeasuresCompanion copyWith(
      {Value<int> id,
      Value<int> elapsed,
      Value<DateTime> dateCreated,
      Value<String> status,
      Value<String> comment}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      elapsed: elapsed ?? this.elapsed,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (elapsed.present) {
      map['elapsed'] = Variable<int>(elapsed.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
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
    return GeneratedIntColumn('elapsed', $tableName, false,
        defaultValue: Constant(0));
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
  GeneratedTextColumn _status;
  @override
  GeneratedTextColumn get status => _status ??= _constructStatus();
  GeneratedTextColumn _constructStatus() {
    return GeneratedTextColumn('status', $tableName, false, maxTextLength: 16);
  }

  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  GeneratedTextColumn _comment;
  @override
  GeneratedTextColumn get comment => _comment ??= _constructComment();
  GeneratedTextColumn _constructComment() {
    return GeneratedTextColumn(
      'comment',
      $tableName,
      true,
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
  VerificationContext validateIntegrity(Insertable<Measure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('elapsed')) {
      context.handle(_elapsedMeta,
          elapsed.isAcceptableOrUnknown(data['elapsed'], _elapsedMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created'], _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status'], _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment'], _commentMeta));
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
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(_db, alias);
  }
}

class MeasureSession extends DataClass implements Insertable<MeasureSession> {
  final int id;
  final int measureId;
  final DateTime started;
  final DateTime finished;
  MeasureSession(
      {@required this.id,
      @required this.measureId,
      @required this.started,
      this.finished});
  factory MeasureSession.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return MeasureSession(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      measureId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}measure_id']),
      started: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}started']),
      finished: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}finished']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || measureId != null) {
      map['measure_id'] = Variable<int>(measureId);
    }
    if (!nullToAbsent || started != null) {
      map['started'] = Variable<DateTime>(started);
    }
    if (!nullToAbsent || finished != null) {
      map['finished'] = Variable<DateTime>(finished);
    }
    return map;
  }

  MeasureSessionsCompanion toCompanion(bool nullToAbsent) {
    return MeasureSessionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      measureId: measureId == null && nullToAbsent
          ? const Value.absent()
          : Value(measureId),
      started: started == null && nullToAbsent
          ? const Value.absent()
          : Value(started),
      finished: finished == null && nullToAbsent
          ? const Value.absent()
          : Value(finished),
    );
  }

  factory MeasureSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MeasureSession(
      id: serializer.fromJson<int>(json['id']),
      measureId: serializer.fromJson<int>(json['measureId']),
      started: serializer.fromJson<DateTime>(json['started']),
      finished: serializer.fromJson<DateTime>(json['finished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measureId': serializer.toJson<int>(measureId),
      'started': serializer.toJson<DateTime>(started),
      'finished': serializer.toJson<DateTime>(finished),
    };
  }

  MeasureSession copyWith(
          {int id, int measureId, DateTime started, DateTime finished}) =>
      MeasureSession(
        id: id ?? this.id,
        measureId: measureId ?? this.measureId,
        started: started ?? this.started,
        finished: finished ?? this.finished,
      );
  @override
  String toString() {
    return (StringBuffer('MeasureSession(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('started: $started, ')
          ..write('finished: $finished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(measureId.hashCode, $mrjc(started.hashCode, finished.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is MeasureSession &&
          other.id == this.id &&
          other.measureId == this.measureId &&
          other.started == this.started &&
          other.finished == this.finished);
}

class MeasureSessionsCompanion extends UpdateCompanion<MeasureSession> {
  final Value<int> id;
  final Value<int> measureId;
  final Value<DateTime> started;
  final Value<DateTime> finished;
  const MeasureSessionsCompanion({
    this.id = const Value.absent(),
    this.measureId = const Value.absent(),
    this.started = const Value.absent(),
    this.finished = const Value.absent(),
  });
  MeasureSessionsCompanion.insert({
    this.id = const Value.absent(),
    @required int measureId,
    @required DateTime started,
    this.finished = const Value.absent(),
  })  : measureId = Value(measureId),
        started = Value(started);
  static Insertable<MeasureSession> custom({
    Expression<int> id,
    Expression<int> measureId,
    Expression<DateTime> started,
    Expression<DateTime> finished,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measureId != null) 'measure_id': measureId,
      if (started != null) 'started': started,
      if (finished != null) 'finished': finished,
    });
  }

  MeasureSessionsCompanion copyWith(
      {Value<int> id,
      Value<int> measureId,
      Value<DateTime> started,
      Value<DateTime> finished}) {
    return MeasureSessionsCompanion(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      started: started ?? this.started,
      finished: finished ?? this.finished,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (measureId.present) {
      map['measure_id'] = Variable<int>(measureId.value);
    }
    if (started.present) {
      map['started'] = Variable<DateTime>(started.value);
    }
    if (finished.present) {
      map['finished'] = Variable<DateTime>(finished.value);
    }
    return map;
  }
}

class $MeasureSessionsTable extends MeasureSessions
    with TableInfo<$MeasureSessionsTable, MeasureSession> {
  final GeneratedDatabase _db;
  final String _alias;
  $MeasureSessionsTable(this._db, [this._alias]);
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

  final VerificationMeta _startedMeta = const VerificationMeta('started');
  GeneratedDateTimeColumn _started;
  @override
  GeneratedDateTimeColumn get started => _started ??= _constructStarted();
  GeneratedDateTimeColumn _constructStarted() {
    return GeneratedDateTimeColumn(
      'started',
      $tableName,
      false,
    );
  }

  final VerificationMeta _finishedMeta = const VerificationMeta('finished');
  GeneratedDateTimeColumn _finished;
  @override
  GeneratedDateTimeColumn get finished => _finished ??= _constructFinished();
  GeneratedDateTimeColumn _constructFinished() {
    return GeneratedDateTimeColumn(
      'finished',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, measureId, started, finished];
  @override
  $MeasureSessionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'measure_sessions';
  @override
  final String actualTableName = 'measure_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<MeasureSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('measure_id')) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableOrUnknown(data['measure_id'], _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('started')) {
      context.handle(_startedMeta,
          started.isAcceptableOrUnknown(data['started'], _startedMeta));
    } else if (isInserting) {
      context.missing(_startedMeta);
    }
    if (data.containsKey('finished')) {
      context.handle(_finishedMeta,
          finished.isAcceptableOrUnknown(data['finished'], _finishedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasureSession map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return MeasureSession.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $MeasureSessionsTable createAlias(String alias) {
    return $MeasureSessionsTable(_db, alias);
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || dateCreated != null) {
      map['date_created'] = Variable<DateTime>(dateCreated);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<int>(frequency);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
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
  static Insertable<Tag> custom({
    Expression<int> id,
    Expression<DateTime> dateCreated,
    Expression<int> frequency,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateCreated != null) 'date_created': dateCreated,
      if (frequency != null) 'frequency': frequency,
      if (name != null) 'name': name,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
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
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created'], _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency'], _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
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
  $MeasureSessionsTable _measureSessions;
  $MeasureSessionsTable get measureSessions =>
      _measureSessions ??= $MeasureSessionsTable(this);
  $TagsTable _tags;
  $TagsTable get tags => _tags ??= $TagsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [laps, measures, measureSessions, tags];
}
