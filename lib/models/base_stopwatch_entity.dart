//import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BaseStopwatchEntity with EquatableMixin {
  final int? id;
  final String? comment;

  BaseStopwatchEntity({this.id, this.comment});

  //UpdateCompanion<T> toEntity<T>();

  @override
  List<Object?> get props => [id, comment];
}
