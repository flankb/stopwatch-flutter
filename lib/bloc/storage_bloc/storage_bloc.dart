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
    if (event is OpenStorageEvent) {
      //  Данное событие должно срабатывать только один раз при загрузке списка
      // Загрузим список сущностей
      final openStorageEvent = event;
      if (openStorageEvent.entityType == MeasureViewModel) {
        final measures = await stopwatchRepository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished));
        final resultList = measures.map((m) => MeasureViewModel.fromEntity(m)).toList();

        yield AvailableListState(resultList);
      } else if (openStorageEvent.entityType == LapViewModel) {
        final laps = (await stopwatchRepository.getLapsByMeasureAsync(openStorageEvent.measureId)).map((l) => LapViewModel.fromEntity(l)).toList();

        yield AvailableListState(laps);
      }
    }

    /*
    if (event is RequestEditEvent) {
      if (state is AvailableListState) {
        final entity = event.entity;
        final list1 = (state as AvailableListState).allEntities;

        yield ReadyStorageState(list1, editableEntity: entity); //TODO Что если был Filtering ???
      } else {
        throw Exception("Wrong state for edit!");
      }
    }
    */

    if (event is FilterStorageEvent) {
      if (state is AvailableListState) {
        final filteredList = event.entityType == MeasureViewModel
            ? (state as AvailableListState)
                .allEntities
                .map((e) => e as MeasureViewModel)
                .where((_) =>
                    _.comment.contains(event.query) &&
                    _.dateCreated.millisecondsSinceEpoch > event.dateFrom.millisecondsSinceEpoch &&
                    _.dateCreated.millisecondsSinceEpoch < event.dateTo.millisecondsSinceEpoch)
                .toList()
            : (state as AvailableListState).allEntities.where((_) => _.comment.contains(event.query)).toList();

        yield AvailableListState(filteredList, filtered: true);
      } else {
        throw Exception("Wrong state for filtering!");
      }
    } else if (event is DeleteStorageEvent) {

    }

    /*
    else if (event is ApplyChangesEvent) {
      if (event.entity is LapViewModel) {
        await stopwatchRepository.updateLapAsync((event.entity as LapViewModel).toEntity());
      } else if (event.entity is MeasureViewModel) {
        await stopwatchRepository.updateMeasureAsync((event.entity as MeasureViewModel).toEntity());
      }
    }
    */

  }
}
