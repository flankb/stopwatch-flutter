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
  final String? comment;
  Lap(
      {required this.id,
      required this.measureId,
      required this.difference,
      required this.order,
      required this.overall,
      this.comment});
  factory Lap.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Lap(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      measureId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}measure_id'])!,
      difference: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}difference'])!,
      order: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
      overall: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}overall'])!,
      comment: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['measure_id'] = Variable<int>(measureId);
    map['difference'] = Variable<int>(difference);
    map['order'] = Variable<int>(order);
    map['overall'] = Variable<int>(overall);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String?>(comment);
    }
    return map;
  }

  LapsCompanion toCompanion(bool nullToAbsent) {
    return LapsCompanion(
      id: Value(id),
      measureId: Value(measureId),
      difference: Value(difference),
      order: Value(order),
      overall: Value(overall),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory Lap.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lap(
      id: serializer.fromJson<int>(json['id']),
      measureId: serializer.fromJson<int>(json['measureId']),
      difference: serializer.fromJson<int>(json['difference']),
      order: serializer.fromJson<int>(json['order']),
      overall: serializer.fromJson<int>(json['overall']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measureId': serializer.toJson<int>(measureId),
      'difference': serializer.toJson<int>(difference),
      'order': serializer.toJson<int>(order),
      'overall': serializer.toJson<int>(overall),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  Lap copyWith(
          {int? id,
          int? measureId,
          int? difference,
          int? order,
          int? overall,
          String? comment}) =>
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
  int get hashCode =>
      Object.hash(id, measureId, difference, order, overall, comment);
  @override
  bool operator ==(Object other) =>
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
  final Value<String?> comment;
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
    required int measureId,
    required int difference,
    required int order,
    required int overall,
    this.comment = const Value.absent(),
  })  : measureId = Value(measureId),
        difference = Value(difference),
        order = Value(order),
        overall = Value(overall);
  static Insertable<Lap> custom({
    Expression<int>? id,
    Expression<int>? measureId,
    Expression<int>? difference,
    Expression<int>? order,
    Expression<int>? overall,
    Expression<String?>? comment,
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
      {Value<int>? id,
      Value<int>? measureId,
      Value<int>? difference,
      Value<int>? order,
      Value<int>? overall,
      Value<String?>? comment}) {
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
      map['comment'] = Variable<String?>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LapsCompanion(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('difference: $difference, ')
          ..write('order: $order, ')
          ..write('overall: $overall, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $LapsTable extends Laps with TableInfo<$LapsTable, Lap> {
  final GeneratedDatabase _db;
  final String? _alias;
  $LapsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _measureIdMeta = const VerificationMeta('measureId');
  late final GeneratedColumn<int?> measureId = GeneratedColumn<int?>(
      'measure_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES measures(id) ON DELETE CASCADE');
  final VerificationMeta _differenceMeta = const VerificationMeta('difference');
  late final GeneratedColumn<int?> difference = GeneratedColumn<int?>(
      'difference', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _orderMeta = const VerificationMeta('order');
  late final GeneratedColumn<int?> order = GeneratedColumn<int?>(
      'order', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _overallMeta = const VerificationMeta('overall');
  late final GeneratedColumn<int?> overall = GeneratedColumn<int?>(
      'overall', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  late final GeneratedColumn<String?> comment = GeneratedColumn<String?>(
      'comment', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, measureId, difference, order, overall, comment];
  @override
  String get aliasedName => _alias ?? 'laps';
  @override
  String get actualTableName => 'laps';
  @override
  VerificationContext validateIntegrity(Insertable<Lap> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('measure_id')) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableOrUnknown(data['measure_id']!, _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('difference')) {
      context.handle(
          _differenceMeta,
          difference.isAcceptableOrUnknown(
              data['difference']!, _differenceMeta));
    } else if (isInserting) {
      context.missing(_differenceMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('overall')) {
      context.handle(_overallMeta,
          overall.isAcceptableOrUnknown(data['overall']!, _overallMeta));
    } else if (isInserting) {
      context.missing(_overallMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lap map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Lap.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LapsTable createAlias(String alias) {
    return $LapsTable(_db, alias);
  }
}

class Measure extends DataClass implements Insertable<Measure> {
  final int id;
  final int elapsed;
  final DateTime? dateStarted;
  final String status;
  final String? comment;
  Measure(
      {required this.id,
      required this.elapsed,
      this.dateStarted,
      required this.status,
      this.comment});
  factory Measure.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Measure(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      elapsed: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}elapsed'])!,
      dateStarted: $MeasuresTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_started'])),
      status: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      comment: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comment']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['elapsed'] = Variable<int>(elapsed);
    if (!nullToAbsent || dateStarted != null) {
      final converter = $MeasuresTable.$converter0;
      map['date_started'] = Variable<int?>(converter.mapToSql(dateStarted));
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String?>(comment);
    }
    return map;
  }

  MeasuresCompanion toCompanion(bool nullToAbsent) {
    return MeasuresCompanion(
      id: Value(id),
      elapsed: Value(elapsed),
      dateStarted: dateStarted == null && nullToAbsent
          ? const Value.absent()
          : Value(dateStarted),
      status: Value(status),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory Measure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<int>(json['id']),
      elapsed: serializer.fromJson<int>(json['elapsed']),
      dateStarted: serializer.fromJson<DateTime?>(json['dateStarted']),
      status: serializer.fromJson<String>(json['status']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'elapsed': serializer.toJson<int>(elapsed),
      'dateStarted': serializer.toJson<DateTime?>(dateStarted),
      'status': serializer.toJson<String>(status),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  Measure copyWith(
          {int? id,
          int? elapsed,
          DateTime? dateStarted,
          String? status,
          String? comment}) =>
      Measure(
        id: id ?? this.id,
        elapsed: elapsed ?? this.elapsed,
        dateStarted: dateStarted ?? this.dateStarted,
        status: status ?? this.status,
        comment: comment ?? this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('Measure(')
          ..write('id: $id, ')
          ..write('elapsed: $elapsed, ')
          ..write('dateStarted: $dateStarted, ')
          ..write('status: $status, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, elapsed, dateStarted, status, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measure &&
          other.id == this.id &&
          other.elapsed == this.elapsed &&
          other.dateStarted == this.dateStarted &&
          other.status == this.status &&
          other.comment == this.comment);
}

class MeasuresCompanion extends UpdateCompanion<Measure> {
  final Value<int> id;
  final Value<int> elapsed;
  final Value<DateTime?> dateStarted;
  final Value<String> status;
  final Value<String?> comment;
  const MeasuresCompanion({
    this.id = const Value.absent(),
    this.elapsed = const Value.absent(),
    this.dateStarted = const Value.absent(),
    this.status = const Value.absent(),
    this.comment = const Value.absent(),
  });
  MeasuresCompanion.insert({
    this.id = const Value.absent(),
    this.elapsed = const Value.absent(),
    this.dateStarted = const Value.absent(),
    required String status,
    this.comment = const Value.absent(),
  }) : status = Value(status);
  static Insertable<Measure> custom({
    Expression<int>? id,
    Expression<int>? elapsed,
    Expression<DateTime?>? dateStarted,
    Expression<String>? status,
    Expression<String?>? comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (elapsed != null) 'elapsed': elapsed,
      if (dateStarted != null) 'date_started': dateStarted,
      if (status != null) 'status': status,
      if (comment != null) 'comment': comment,
    });
  }

  MeasuresCompanion copyWith(
      {Value<int>? id,
      Value<int>? elapsed,
      Value<DateTime?>? dateStarted,
      Value<String>? status,
      Value<String?>? comment}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      elapsed: elapsed ?? this.elapsed,
      dateStarted: dateStarted ?? this.dateStarted,
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
    if (dateStarted.present) {
      final converter = $MeasuresTable.$converter0;
      map['date_started'] =
          Variable<int?>(converter.mapToSql(dateStarted.value));
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String?>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasuresCompanion(')
          ..write('id: $id, ')
          ..write('elapsed: $elapsed, ')
          ..write('dateStarted: $dateStarted, ')
          ..write('status: $status, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $MeasuresTable extends Measures with TableInfo<$MeasuresTable, Measure> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MeasuresTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _elapsedMeta = const VerificationMeta('elapsed');
  late final GeneratedColumn<int?> elapsed = GeneratedColumn<int?>(
      'elapsed', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _dateStartedMeta =
      const VerificationMeta('dateStarted');
  late final GeneratedColumnWithTypeConverter<DateTime, int?> dateStarted =
      GeneratedColumn<int?>('date_started', aliasedName, true,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<DateTime>($MeasuresTable.$converter0);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String?> status = GeneratedColumn<String?>(
      'status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 16),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  late final GeneratedColumn<String?> comment = GeneratedColumn<String?>(
      'comment', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, elapsed, dateStarted, status, comment];
  @override
  String get aliasedName => _alias ?? 'measures';
  @override
  String get actualTableName => 'measures';
  @override
  VerificationContext validateIntegrity(Insertable<Measure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('elapsed')) {
      context.handle(_elapsedMeta,
          elapsed.isAcceptableOrUnknown(data['elapsed']!, _elapsedMeta));
    }
    context.handle(_dateStartedMeta, const VerificationResult.success());
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measure map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Measure.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(_db, alias);
  }

  static TypeConverter<DateTime, int> $converter0 = const MillisDateConverter();
}

class MeasureSession extends DataClass implements Insertable<MeasureSession> {
  final int id;
  final int measureId;
  final int startedOffset;
  final int? finishedOffset;
  MeasureSession(
      {required this.id,
      required this.measureId,
      required this.startedOffset,
      this.finishedOffset});
  factory MeasureSession.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MeasureSession(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      measureId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}measure_id'])!,
      startedOffset: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}started_offset'])!,
      finishedOffset: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}finished_offset']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['measure_id'] = Variable<int>(measureId);
    map['started_offset'] = Variable<int>(startedOffset);
    if (!nullToAbsent || finishedOffset != null) {
      map['finished_offset'] = Variable<int?>(finishedOffset);
    }
    return map;
  }

  MeasureSessionsCompanion toCompanion(bool nullToAbsent) {
    return MeasureSessionsCompanion(
      id: Value(id),
      measureId: Value(measureId),
      startedOffset: Value(startedOffset),
      finishedOffset: finishedOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedOffset),
    );
  }

  factory MeasureSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasureSession(
      id: serializer.fromJson<int>(json['id']),
      measureId: serializer.fromJson<int>(json['measureId']),
      startedOffset: serializer.fromJson<int>(json['startedOffset']),
      finishedOffset: serializer.fromJson<int?>(json['finishedOffset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measureId': serializer.toJson<int>(measureId),
      'startedOffset': serializer.toJson<int>(startedOffset),
      'finishedOffset': serializer.toJson<int?>(finishedOffset),
    };
  }

  MeasureSession copyWith(
          {int? id, int? measureId, int? startedOffset, int? finishedOffset}) =>
      MeasureSession(
        id: id ?? this.id,
        measureId: measureId ?? this.measureId,
        startedOffset: startedOffset ?? this.startedOffset,
        finishedOffset: finishedOffset ?? this.finishedOffset,
      );
  @override
  String toString() {
    return (StringBuffer('MeasureSession(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('startedOffset: $startedOffset, ')
          ..write('finishedOffset: $finishedOffset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, measureId, startedOffset, finishedOffset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasureSession &&
          other.id == this.id &&
          other.measureId == this.measureId &&
          other.startedOffset == this.startedOffset &&
          other.finishedOffset == this.finishedOffset);
}

class MeasureSessionsCompanion extends UpdateCompanion<MeasureSession> {
  final Value<int> id;
  final Value<int> measureId;
  final Value<int> startedOffset;
  final Value<int?> finishedOffset;
  const MeasureSessionsCompanion({
    this.id = const Value.absent(),
    this.measureId = const Value.absent(),
    this.startedOffset = const Value.absent(),
    this.finishedOffset = const Value.absent(),
  });
  MeasureSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int measureId,
    required int startedOffset,
    this.finishedOffset = const Value.absent(),
  })  : measureId = Value(measureId),
        startedOffset = Value(startedOffset);
  static Insertable<MeasureSession> custom({
    Expression<int>? id,
    Expression<int>? measureId,
    Expression<int>? startedOffset,
    Expression<int?>? finishedOffset,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measureId != null) 'measure_id': measureId,
      if (startedOffset != null) 'started_offset': startedOffset,
      if (finishedOffset != null) 'finished_offset': finishedOffset,
    });
  }

  MeasureSessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? measureId,
      Value<int>? startedOffset,
      Value<int?>? finishedOffset}) {
    return MeasureSessionsCompanion(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      startedOffset: startedOffset ?? this.startedOffset,
      finishedOffset: finishedOffset ?? this.finishedOffset,
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
    if (startedOffset.present) {
      map['started_offset'] = Variable<int>(startedOffset.value);
    }
    if (finishedOffset.present) {
      map['finished_offset'] = Variable<int?>(finishedOffset.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasureSessionsCompanion(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('startedOffset: $startedOffset, ')
          ..write('finishedOffset: $finishedOffset')
          ..write(')'))
        .toString();
  }
}

class $MeasureSessionsTable extends MeasureSessions
    with TableInfo<$MeasureSessionsTable, MeasureSession> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MeasureSessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _measureIdMeta = const VerificationMeta('measureId');
  late final GeneratedColumn<int?> measureId = GeneratedColumn<int?>(
      'measure_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES measures(id) ON DELETE CASCADE');
  final VerificationMeta _startedOffsetMeta =
      const VerificationMeta('startedOffset');
  late final GeneratedColumn<int?> startedOffset = GeneratedColumn<int?>(
      'started_offset', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _finishedOffsetMeta =
      const VerificationMeta('finishedOffset');
  late final GeneratedColumn<int?> finishedOffset = GeneratedColumn<int?>(
      'finished_offset', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, measureId, startedOffset, finishedOffset];
  @override
  String get aliasedName => _alias ?? 'measure_sessions';
  @override
  String get actualTableName => 'measure_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<MeasureSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('measure_id')) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableOrUnknown(data['measure_id']!, _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('started_offset')) {
      context.handle(
          _startedOffsetMeta,
          startedOffset.isAcceptableOrUnknown(
              data['started_offset']!, _startedOffsetMeta));
    } else if (isInserting) {
      context.missing(_startedOffsetMeta);
    }
    if (data.containsKey('finished_offset')) {
      context.handle(
          _finishedOffsetMeta,
          finishedOffset.isAcceptableOrUnknown(
              data['finished_offset']!, _finishedOffsetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasureSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MeasureSession.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
      {required this.id,
      required this.dateCreated,
      required this.frequency,
      required this.name});
  factory Tag.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Tag(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
      frequency: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}frequency'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_created'] = Variable<DateTime>(dateCreated);
    map['frequency'] = Variable<int>(frequency);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      dateCreated: Value(dateCreated),
      frequency: Value(frequency),
      name: Value(name),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      frequency: serializer.fromJson<int>(json['frequency']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'frequency': serializer.toJson<int>(frequency),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith(
          {int? id, DateTime? dateCreated, int? frequency, String? name}) =>
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
  int get hashCode => Object.hash(id, dateCreated, frequency, name);
  @override
  bool operator ==(Object other) =>
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
    required DateTime dateCreated,
    required int frequency,
    required String name,
  })  : dateCreated = Value(dateCreated),
        frequency = Value(frequency),
        name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<DateTime>? dateCreated,
    Expression<int>? frequency,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateCreated != null) 'date_created': dateCreated,
      if (frequency != null) 'frequency': frequency,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? dateCreated,
      Value<int>? frequency,
      Value<String>? name}) {
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

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('frequency: $frequency, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TagsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _frequencyMeta = const VerificationMeta('frequency');
  late final GeneratedColumn<int?> frequency = GeneratedColumn<int?>(
      'frequency', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  @override
  List<GeneratedColumn> get $columns => [id, dateCreated, frequency, name];
  @override
  String get aliasedName => _alias ?? 'tags';
  @override
  String get actualTableName => 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Tag.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $LapsTable laps = $LapsTable(this);
  late final $MeasuresTable measures = $MeasuresTable(this);
  late final $MeasureSessionsTable measureSessions =
      $MeasureSessionsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [laps, measures, measureSessions, tags];
}
