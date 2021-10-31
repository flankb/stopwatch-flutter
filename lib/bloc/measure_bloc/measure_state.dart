import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class MeasureState extends Equatable {
  final MeasureViewModel measure;

  MeasureState(this.measure);

  @override
  List<Object> get props => [measure];
}

class MeasureReadyState extends MeasureState {
  MeasureReadyState(MeasureViewModel measure) : super(measure);
}

class MeasureUpdatingState extends MeasureState {
  // Пока можно это состояние присваивать при старте программы перед загрузкой секундомера
  MeasureUpdatingState(MeasureViewModel measure) : super(measure);
}

class MeasurePausedState extends MeasureState {
  MeasurePausedState(MeasureViewModel measure) : super(measure);
}

class MeasureStartedState extends MeasureState {
  MeasureStartedState(MeasureViewModel measure) : super(measure);
}

class MeasureFinishedState extends MeasureState {
  MeasureFinishedState(MeasureViewModel measure) : super(measure);
}
