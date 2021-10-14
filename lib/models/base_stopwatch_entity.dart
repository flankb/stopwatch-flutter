import 'package:equatable/equatable.dart';

abstract class BaseStopwatchEntity with EquatableMixin {
  int id;
  String? comment;

  BaseStopwatchEntity({required this.id, this.comment});

  @override
  List<Object?> get props {
    return [id, comment];
  }
}
