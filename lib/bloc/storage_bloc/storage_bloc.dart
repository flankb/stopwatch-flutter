import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/models/stopwatch_status.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import './bloc.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StopwatchRepository stopwatchRepository;

  StorageBloc(this.stopwatchRepository);

  @override
  StorageState get initialState => LoadingStorageState();

  @override
  Stream<StorageState> mapEventToState(
    StorageEvent event,
  ) async* {
    debugPrint("Current state ${state.toString()} Bloc event: ${event.toString()}");
    // Для каждого события что-то делаем и возвращаем состояние
    if (event is LoadStorageEvent) {
      //  Данное событие должно срабатывать только один раз при загрузке списка
      // Загрузим список сущностей
      final openStorageEvent = event;
      if (openStorageEvent.entityType == MeasureViewModel) {
        final measures = await stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished));
        final resultList = measures.map((m) => MeasureViewModel.fromEntity(m)).toList();

        yield AvailableListState(resultList, resultList, null);
      } else if (openStorageEvent.entityType == LapViewModel) {
        final laps = (await stopwatchRepository.getLapsByMeasureAsync(openStorageEvent.measureId)).map((l) => LapViewModel.fromEntity(l)).toList();

        await Future.delayed(Duration(milliseconds: 1000));

        yield AvailableListState(laps, laps, null);
      }
    }
    if (event is FilterStorageEvent) {
      if (state is AvailableListState) {

        final availState = state as AvailableListState;
        yield LoadingStorageState();

        var result =  availState.entities;

        if (event.filter.query != null && event.filter.query != "") {
          result = result.where((en) => en.comment != null && en.comment.contains(event.filter.query)).toList();
        }

        if (event.entityType == MeasureViewModel) {
          result = result
              .map((e) => e as MeasureViewModel)
              .where((measure) =>
                  measure.dateCreated.millisecondsSinceEpoch > event.filter.dateFrom.millisecondsSinceEpoch &&
                  measure.dateCreated.millisecondsSinceEpoch < event.filter.dateTo.millisecondsSinceEpoch)
              .toList();
        }

        yield AvailableListState(result.map((e) => e).toList(), availState.allEntities, event.filter, filtered: true);
      } else {
        throw Exception("Wrong state for filtering!");
      }
    } else if (event is CancelFilterEvent) {
      // Получить текущее состояние (а именно списки и тип сущности) (должно быть только Available)
      if (state is AvailableListState) {
        final availState = state as AvailableListState;
        yield AvailableListState(availState.allEntities, availState.allEntities, availState.lastFilter, filtered: false);
      }
      else {
        throw Exception("Wrong state!");
      }
    }
    else if (event is DeleteStorageEvent) {
      if (state is AvailableListState) {
        final availState = state as AvailableListState;
        var entities = availState.entities;
        entities = entities.toSet().difference(event.entitiesForDelete.toSet()).toList();

        final all = availState.allEntities.toSet().difference(event.entitiesForDelete.toSet()).toList();

        await stopwatchRepository.deleteMeasures(event.entitiesForDelete.map((e) => e.id).toList());
        yield AvailableListState(entities, all, availState.lastFilter, filtered: availState.filtered);
      } else {
        throw Exception("Wrong state!");
      }
    }
  }
}
