import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import './bloc.dart';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final StopwatchRepository stopwatchRepository;

  EntityBloc(this.stopwatchRepository) : super(const LoadingEntityState()) {
    on<EntityEvent>((event, emitter) async {
      debugPrint(
        'Current state ${state.toString()}, Bloc event: ${event.toString()}',
      );

      if (event is OpenEntityEvent) {
        emitter(AvailableEntityState(event.entity));
      } else if (event is SaveEntityEvent) {
        emitter(const LoadingEntityState());

        if (event.entity is LapViewModel) {
          final lapViewModel =
              (event.entity as LapViewModel).copyWith(comment: event.comment);

          await stopwatchRepository.updateLapAsync(lapViewModel.toEntity());

          emitter(AvailableEntityState(lapViewModel));
        } else if (event.entity is MeasureViewModel) {
          final measureViewModel = (event.entity as MeasureViewModel)
              .copyWith(comment: event.comment);

          await stopwatchRepository
              .updateMeasureAsync(measureViewModel.toEntity());

          debugPrint(
            'SaveEntityEvent: ${(event.entity as MeasureViewModel).toEntity().toString()}',
          );
          emitter(AvailableEntityState(measureViewModel));
        }
      }
    });
  }
}
