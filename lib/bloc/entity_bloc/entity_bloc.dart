import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import './bloc.dart';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final StopwatchRepository stopwatchRepository;

  EntityBloc(this.stopwatchRepository) : super(LoadingEntityState());

  @override
  Stream<EntityState> mapEventToState(
    EntityEvent event,
  ) async* {
    debugPrint(
        "Current state ${state.toString()} Bloc event: ${event.toString()}");

    if (event is OpenEntityEvent) {
      yield AvailableEntityState(event.entity);
    } else if (event is SaveEntityEvent) {
      yield LoadingEntityState();
      var entityViewModel;

      if (event.entity is LapViewModel) {
        entityViewModel =
            (event.entity as LapViewModel).copyWith(comment: event.comment);

        await stopwatchRepository.updateLapAsync(entityViewModel.toEntity());
      } else if (event.entity is MeasureViewModel) {
        entityViewModel =
            (event.entity as MeasureViewModel).copyWith(comment: event.comment);

        await stopwatchRepository
            .updateMeasureAsync(entityViewModel.toEntity());

        debugPrint(
            "SaveEntityEvent: ${(event.entity as MeasureViewModel).toEntity().toString()}");
      }

      yield AvailableEntityState(entityViewModel);
    }
  }

  void dispose() {}
}
