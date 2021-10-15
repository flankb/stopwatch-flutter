import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/util/time_displayer.dart';

import 'stopwatch_proxy_models.dart';

class LapViewModel extends BaseStopwatchEntity {
  int measureId;
  int order;
  int difference;
  int overall;

  String differenceTime() {
    return TimeDisplayer.formatBase(Duration(milliseconds: difference));
  }

  String overallTime() {
    return TimeDisplayer.formatBase(Duration(milliseconds: overall));
  }

  String differenceMills() {
    return TimeDisplayer.formatMills(Duration(milliseconds: difference));
  }

  String overallMills() {
    return TimeDisplayer.formatMills(Duration(milliseconds: overall));
  }

  LapViewModel(
      {required int id,
      String? comment,
      required this.measureId,
      required this.order,
      this.difference = 0,
      this.overall = 0})
      : super(id: id, comment: comment);

  Lap toEntity() {
    return Lap(
        id: id,
        measureId: measureId,
        order: order,
        difference: difference,
        comment: comment,
        overall: overall);
  }

  static LapViewModel fromEntity(Lap entity) {
    return LapViewModel(
        id: entity.id,
        measureId: entity.measureId,
        order: entity.order,
        difference: entity.difference,
        comment: entity.comment,
        overall: entity.overall);
  }

  @override
  String toString() {
    return 'LapViewModel{order: $order, difference: $difference, overall: $overall, comment: $comment}';
  }

  @override
  List<Object?> get props =>
      super.props..addAll([measureId, order, difference, overall]);
}
