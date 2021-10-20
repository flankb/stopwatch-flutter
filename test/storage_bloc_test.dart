import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

Future<bool> existsMeasure(
    StopwatchFakeRepository repository, StopwatchStatus status) async {
  final measures =
      await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.length > 0;
}

void main() {
  group('StorageBloc', () {
    late StopwatchFakeRepository repository;
    late StorageBloc storageBloc;

    setUp(() {
      repository = StopwatchFakeRepository(preBuild: true);
      storageBloc = StorageBloc(repository);
    });

    tearDown(() {
      //measureBloc?.close();
    });

    test('Initial state test', () {
      //final initialState = LoadingStorageState();
      expect(storageBloc.state is LoadingStorageState, true);
    });

    //expectLater(actual, matcher) // TODO Асинхронный expect

    test("Full storage bloc test", () async {
      final _testController = StreamController<bool>();
      int counterStates = 0;

      storageBloc.stream.listen((state) async {
        debugPrint("Listened: " + state.toString());
        final availableState = (state is AvailableListState) ? state : null;

        /**
         * Listened: LoadingStorageState
            Current state LoadingStorageState Bloc event: LoadStorageEvent
            Listened: AvailableListState
            Current state AvailableListState Bloc event: FilterStorageEvent
            Listened: LoadingStorageState
            Listened: AvailableListState
            Current state AvailableListState Bloc event: CancelFilterEvent
            Listened: AvailableListState
            Current state AvailableListState Bloc event: DeleteStorageEvent
            Listened: LoadingStorageState
            Listened: AvailableListState
         */

        switch (counterStates) {
          case 1:
            // Проверить, что в сотоянии есть загруженные элементы
            final existsElements =
                availableState!.entities.any((element) => true);
            expect(existsElements, true,
                reason: "В сотоянии нет загруженных элементов");
            break;
          case 3:
            // Проверить, что отфильтровано (перед этим задать фильтр)
            final filteredEntities = availableState!.entities
                .where((element) => element.comment!.contains("сто"));
            final onlyFilteredExists =
                filteredEntities.length == availableState.entities.length;
            expect(onlyFilteredExists, true,
                reason: "Неверное количество отфильтрованных элементов");

            final stateIsFiltered = availableState.filtered;
            expect(stateIsFiltered, true, reason: 'Флаг не выставился!');

            break;
          case 6:
            // Проверить, что есть загруженные элементы
            final existsElements =
                availableState!.entities.any((element) => true);
            expect(existsElements, true,
                reason: "После удаления нет загруженных элементов!");
        }

        if (counterStates == 6) {
          _testController.add(true);
          _testController.close();
        }

        counterStates++;
      });

      storageBloc.add(LoadStorageEvent(MeasureViewModel, measureId: null));

      Filter filter = Filter.defaultFilter();
      filter.query = "сто";
      storageBloc.add(FilterStorageEvent(MeasureViewModel, filter));

      storageBloc.add(CancelFilterEvent(MeasureViewModel));
      storageBloc.add(DeleteStorageEvent(<BaseStopwatchEntity>[]));

      expectLater(_testController.stream, emits(true));
    });

    blocTest<StorageBloc, StorageState>(
      'States flow',
      build: () => storageBloc,
      wait: Duration(seconds: 0),
      act: (bloc) async {
        bloc.add(LoadStorageEvent(MeasureViewModel, measureId: null));
        bloc.add(FilterStorageEvent(MeasureViewModel, Filter.defaultFilter()));
        bloc.add(CancelFilterEvent(MeasureViewModel));
        bloc.add(DeleteStorageEvent(<BaseStopwatchEntity>[]));
      },
      verify: (bloc) async {},
      expect: () => [
        isA<AvailableListState>(),
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
        isA<AvailableListState>(),
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
      ],
    );
  });
}
