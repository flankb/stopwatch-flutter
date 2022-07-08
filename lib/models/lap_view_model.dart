import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'package:stopwatch/models/database/database_models.dart';
import 'package:stopwatch/util/time_displayer.dart';

import 'stopwatch_proxy_models.dart';

@immutable
class LapViewModel extends BaseStopwatchEntity {
  final int measureId;
  final int order;
  final int difference;
  final int overall;

  String differenceTime() => formatBase(Duration(milliseconds: difference));

  String overallTime() => formatBase(Duration(milliseconds: overall));

  String differenceMills() => formatMills(Duration(milliseconds: difference));

  String overallMills() => formatMills(Duration(milliseconds: overall));

  LapViewModel({
    required this.measureId,
    required this.order,
    int? id,
    String? comment,
    this.difference = 0,
    this.overall = 0,
  }) : super(id: id, comment: comment);

  LapsCompanion toEntity() => LapsCompanion(
        id: id != null ? Value(id!) : const Value.absent(),
        measureId: Value(measureId),
        order: Value(order),
        difference: Value(difference),
        comment: Value(comment),
        overall: Value(overall),
      );

  factory LapViewModel.fromEntity(Lap entity) => LapViewModel(
        id: entity.id,
        measureId: entity.measureId,
        order: entity.order,
        difference: entity.difference,
        comment: entity.comment,
        overall: entity.overall,
      );

  @override
  String toString() =>
      'LapViewModel{order: $order, difference: $difference, overall: $overall, comment: $comment}';

  @override
  List<Object?> get props =>
      super.props..addAll([measureId, order, difference, overall]);

  LapViewModel copyWith({
    int? id,
    String? comment,
    int? measureId,
    int? order,
    int? difference,
    int? overall,
  }) =>
      LapViewModel(
        id: id ?? this.id,
        comment: comment ?? this.comment,
        measureId: measureId ?? this.measureId,
        order: order ?? this.order,
        difference: difference ?? this.difference,
        overall: overall ?? this.overall,
      );
}
