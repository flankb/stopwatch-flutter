
class LapViewModel {
  final int id;
  final int order;
  final int difference;
  final int overall;
  final String comment;

  LapViewModel({this.id, this.order, this.difference, this.overall, this.comment});

  @override
  String toString() {
    return 'LapViewModel{order: $order, difference: $difference, overall: $overall, comment: $comment}';
  }

  Map<String, dynamic> toMap() {
    return {
      'order': this.order,
      'difference': this.difference,
      'overall': this.overall,
      'comment': this.comment,
    };
  }

  factory LapViewModel.fromMap(Map<String, dynamic> map) {
    return new LapViewModel(
      order: map['order'] as int,
      difference: map['difference'] as int,
      overall: map['overall'] as int,
      comment: map['comment'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LapViewModel &&
              runtimeType == other.runtimeType &&
              order == other.order &&
              difference == other.difference &&
              overall == other.overall &&
              comment == other.comment;

  @override
  int get hashCode =>
      order.hashCode ^
      difference.hashCode ^
      overall.hashCode ^
      comment.hashCode;

}

class MeasureViewModel {
  final int id;
  final String elapsedTime;
  final String elapsedTimeLap;
  final String comment;

  MeasureViewModel({this.id, this.elapsedTime, this.elapsedTimeLap, this.comment});

  Map<String, dynamic> toMap() {
    return {
      'elapsedTime': this.elapsedTime,
      'elapsedTimeLap': this.elapsedTimeLap,
      'comment': this.comment,
    };
  }

  factory MeasureViewModel.fromMap(Map<String, dynamic> map) {
    return new MeasureViewModel(
      elapsedTime: map['elapsedTime'] as String,
      elapsedTimeLap: map['elapsedTimeLap'] as String,
      comment: map['comment'] as String,
    );
  }
}
