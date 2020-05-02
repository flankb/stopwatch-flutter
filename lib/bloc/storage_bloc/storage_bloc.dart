import 'dart:async';
import 'package:bloc/bloc.dart';
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
    // Для каждого события что-то делаем и возвращаем состояние
    if (event is OpenStorageEvent) { //  Данное событие должно срабатывать только один раз при загрузке списка
      // Загрузим список сущностей
      final openStorageEvent = event;
      if (openStorageEvent.entityType == MeasureViewModel){
        final measures = await stopwatchRepository.getMeasuresByStatusAsync(StopwatchStatus.Finished.toString());
        final resultList = measures.map((m) => MeasureViewModel.fromEntity(m)).toList();
        
        yield ReadyStorageState(resultList, resultList);
      } else if (openStorageEvent.entityType == LapViewModel) {
          final laps = (await stopwatchRepository
              .getLapsByMeasureAsync(openStorageEvent.measureId))
              .map((l) => LapViewModel.fromEntity(l))
              .toList();

          yield ReadyStorageState(laps, laps);
      }
    } if (event is RequestEditEvent) {
      if (state is ReadyStorageState) {
        final entity = event.entity;
        final list1 = (state as ReadyStorageState).allEntities;
        final list2 = (state as ReadyStorageState).filteredEntities;

        yield ReadyStorageState(list1, list2, editableEntity: entity);
      }
      else {
        throw Exception("Wrong state for edit!");
      }
    } if (event is FilterStorageEvent) {

    }
    else if (event is ApplyChangesEvent) {
      //yield* _mapPausedToState(event);
    }
  }
}
