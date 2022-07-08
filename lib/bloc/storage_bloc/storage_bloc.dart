import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';

import './bloc.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StopwatchRepository stopwatchRepository;
  // Компонент редактирования сущности
  final EntityBloc entityBloc;

  StorageBloc(this.stopwatchRepository, this.entityBloc)
      : super(const LoadingStorageState()) {
    on<StorageEvent>(
      (event, emitter) async {
        debugPrint(
          'Current state ${state.toString()} Bloc event: ${event.toString()}',
        );
        // Для каждого события что-то делаем и возвращаем состояние
        if (event is LoadStorageEvent) {
          //  Данное событие должно срабатывать только один раз при загрузке списка
          // Загрузим список сущностей
          final openStorageEvent = event;
          if (openStorageEvent.entityType == MeasureViewModel) {
            final measures = await stopwatchRepository.getMeasuresByStatusAsync(
              describeEnum(StopwatchStatus.Finished),
            );
            final resultList =
                measures.map((e) => MeasureViewModel.fromEntity(e)).toList();

            emitter(AvailableListState(resultList, resultList, Filter.empty()));
          } else if (openStorageEvent.entityType == LapViewModel) {
            final laps = (await stopwatchRepository
                    .getLapsByMeasureAsync(openStorageEvent.measureId!))
                .map((l) => LapViewModel.fromEntity(l))
                .toList();

            emitter(AvailableListState(laps, laps, Filter.empty()));
          }
        } else if (event is ClearStorageEvent) {
          // Здесь при необходимости можно удалять элементы из списка
          emitter(const LoadingStorageState());
        } else if (event is FilterStorageEvent) {
          if (state is AvailableListState) {
            final availState = state as AvailableListState;
            emitter(const LoadingStorageState());

            var result = availState.entities;

            if (event.filter?.query != null && event.filter!.query != '') {
              result = result
                  .where(
                    (en) =>
                        en.comment != null &&
                        en.comment!.contains(
                          event.filter!.query,
                        ),
                  )
                  .toList();
            }

            if (event.entityType == MeasureViewModel) {
              result = result
                  .map((e) => e as MeasureViewModel)
                  .where(
                    (measure) =>
                        measure.dateStarted!.millisecondsSinceEpoch >
                            event.filter!.dateFrom!.millisecondsSinceEpoch &&
                        measure.dateStarted!.millisecondsSinceEpoch <
                            event.filter!.dateTo!.millisecondsSinceEpoch,
                  )
                  .toList();
            }

            emitter(
              AvailableListState(
                result.map((e) => e).toList(),
                availState.allEntities,
                event.filter ?? Filter.empty(),
                filtered: true,
              ),
            );
          } else {
            throw Exception('Wrong state for filtering!');
          }
        } else if (event is CancelFilterEvent) {
          // Получить текущее состояние (а именно списки и тип сущности) (должно быть только Available)
          if (state is AvailableListState) {
            final availState = state as AvailableListState;
            emitter(
              AvailableListState(
                availState.allEntities,
                availState.allEntities,
                availState.lastFilter,
                filtered: false,
              ),
            );
          } else {
            throw Exception('Wrong state!');
          }
        } else if (event is DeleteStorageEvent) {
          if (state is AvailableListState) {
            final availState = state as AvailableListState;
            emitter(const LoadingStorageState());
            var entities = availState.entities;
            entities = entities
                .toSet()
                .difference(event.entitiesForDelete.toSet())
                .toList();

            final all = availState.allEntities
                .toSet()
                .difference(event.entitiesForDelete.toSet())
                .toList();

            await stopwatchRepository.deleteMeasures(
              event.entitiesForDelete
                  .where((e) => e.id != null)
                  .map((e) => e.id!)
                  .toList(),
            );
            emitter(
              AvailableListState(
                entities,
                all,
                availState.lastFilter,
                filtered: availState.filtered,
              ),
            );
          } else {
            throw Exception('Wrong state!');
          }
        } else if (event is ApplyChangesEvent) {
          if (state is AvailableListState) {
            final availState = state as AvailableListState;

            List<BaseStopwatchEntity> updateEntities(
              List<BaseStopwatchEntity> entities,
            ) {
              final entityIndex = entities
                  .indexWhere((element) => element.id == event.entity.id);

              return List.from(entities)..[entityIndex] = event.entity;
            }

            emitter(
              availState.copyWith(
                entities: updateEntities(availState.entities),
                allEntities: updateEntities(availState.allEntities),
              ),
            );
          }
        }
      },
      transformer: sequential(),
    );

    entityBloc.stream.listen(
      (entityState) => {
        // Обновим сущность в списках
        if (entityState is AvailableEntityState && state is AvailableListState)
          {add(ApplyChangesEvent(entityState.entity))}
      },
    );
  }
}
