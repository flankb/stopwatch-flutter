import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import './bloc.dart';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final StopwatchRepository stopwatchRepository;

  EntityBloc(this.stopwatchRepository);

  @override
  EntityState get initialState => LoadingEntityState();

  @override
  Stream<EntityState> mapEventToState(
    EntityEvent event,
  ) async* {
    if (event is OpenEntityEvent) {
      yield AvailableEntityState(event.entity);
    } else if (event is SaveEntityEvent) {
      if (event.entity is LapViewModel) {
        await stopwatchRepository.updateLapAsync((event.entity as LapViewModel).toEntity());
      } else if (event.entity is MeasureViewModel) {
        await stopwatchRepository.updateMeasureAsync((event.entity as MeasureViewModel).toEntity());

        debugPrint("SaveEntityEvent: ${(event.entity as MeasureViewModel).toEntity().toString()}");
      }

      yield AvailableEntityState(event.entity);
    }
  }

  void dispose() {}
}
