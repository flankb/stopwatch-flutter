import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
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

    late List<MeasureViewModel> measures;

    setUp(() {
      repository = StopwatchFakeRepository(preBuild: true);
      storageBloc = StorageBloc(repository, EntityBloc(repository));

      measures = FakeDataFabric.measuresHistory();
    });

    tearDown(() {});

    test('Initial state test', () {
      expect(storageBloc.state is LoadingStorageState, true);
    });

    blocTest<StorageBloc, StorageState>(
        'emit Storage events should change state',
        build: () {
          return storageBloc;
        },
        act: (bloc) {
          Filter filter = Filter.defaultFilter().copyWith(query: 'что');

          bloc
            ..add(LoadStorageEvent(MeasureViewModel, measureId: null))
            ..add(FilterStorageEvent(MeasureViewModel, filter))
            ..add(CancelFilterEvent(MeasureViewModel))
            ..add(DeleteStorageEvent(<BaseStopwatchEntity>[]));
        },
        expect: () => [
              isA<AvailableListState>(),
              isA<LoadingStorageState>(),
              isA<AvailableListState>(),
              isA<AvailableListState>(),
              isA<LoadingStorageState>(),
              isA<AvailableListState>(),
            ]);

    blocTest<StorageBloc, StorageState>(
        'emit Storage load event should change state',
        build: () {
          return storageBloc;
        },
        verify: (bloc) async {
          final existsElements = (bloc.state as AvailableListState)
              .entities
              .any((element) => true);
          expect(existsElements, true,
              reason: "State has not loaded elemrnts!");
        },
        act: (bloc) {
          bloc..add(LoadStorageEvent(MeasureViewModel, measureId: null));
        },
        expect: () => [
              isA<AvailableListState>(),
            ]);

    blocTest<StorageBloc, StorageState>(
        'emit Storage filter event should change state',
        build: () {
          return storageBloc;
        },
        verify: (bloc) async {
          final availableState = (bloc.state as AvailableListState);
          final filteredEntities = availableState.entities
              .where((element) => element.comment!.contains("сто"));
          final onlyFilteredExists =
              filteredEntities.length == availableState.entities.length;
          expect(onlyFilteredExists, true,
              reason: "Wrong count of filtered elements!");

          final stateIsFiltered = availableState.filtered;
          expect(stateIsFiltered, true, reason: 'Flag not appear!');
        },
        seed: () => AvailableListState(
            FakeDataFabric.measuresHistory(), [], Filter.empty()),
        act: (bloc) {
          Filter filter = Filter.defaultFilter().copyWith(query: 'сто');
          storageBloc.add(FilterStorageEvent(MeasureViewModel, filter));
        },
        expect: () => [
              isA<LoadingStorageState>(),
              isA<AvailableListState>(),
            ]);

    blocTest<StorageBloc, StorageState>(
        'emit Storage remove event should change state',
        build: () {
          return storageBloc;
        },
        verify: (bloc) async {
          final availableState = (bloc.state as AvailableListState);

          expect(availableState.entities.isEmpty, true);
        },
        seed: () => AvailableListState(measures, measures, Filter.empty()),
        act: (bloc) {
          storageBloc.add(DeleteStorageEvent(measures));
        },
        expect: () => [
              isA<LoadingStorageState>(),
              isA<AvailableListState>(),
            ]);

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
