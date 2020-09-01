import 'package:equatable/equatable.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

abstract class MeasureState extends Equatable {
  final MeasureViewModel measure;
  final int version;
  static int _versionPool = 0;

  static int getUpdatedVersion() {
    _versionPool += 1;
    return _versionPool;
  }

  MeasureState(this.measure, this.version);

  @override
  List<Object> get props => [version];
}

class MeasureReadyState extends MeasureState {
  MeasureReadyState(MeasureViewModel measure) : super(measure, MeasureState.getUpdatedVersion());
}

class MeasureUpdatingState extends MeasureState {
  // Пока можно это состояние присваивать при старте программы перед загрузкой секундомера
  MeasureUpdatingState(MeasureViewModel measure) : super(measure, MeasureState.getUpdatedVersion());
}

class MeasurePausedState extends MeasureState {
  MeasurePausedState(MeasureViewModel measure) : super(measure, MeasureState.getUpdatedVersion());
}

class MeasureStartedState extends MeasureState {
  MeasureStartedState(MeasureViewModel measure) : super(measure, MeasureState.getUpdatedVersion());
}

class MeasureFinishedState extends MeasureState {
  MeasureFinishedState(MeasureViewModel measure) : super(measure, MeasureState.getUpdatedVersion());
}