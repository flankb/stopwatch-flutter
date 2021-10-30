import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BaseStopwatchEntity with EquatableMixin {
  final int? id;
  final String? comment;

  BaseStopwatchEntity({this.id, this.comment});

  @override
  List<Object?> get props {
    return [id, comment];
  }
}
