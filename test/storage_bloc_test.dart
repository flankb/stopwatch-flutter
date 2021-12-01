import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';

import 'fake_repos.dart';

Future<bool> existsMeasure(
  StopwatchFakeRepository repository,
  StopwatchStatus status,
) async {
  final measures =
      await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.isNotEmpty;
}

void main() {
  group('StorageBloc', () {
    late StopwatchFakeRepository repository;
    late StorageBloc storageBloc;

    late List<MeasureViewModel> measures;

    setUp(() {
      repository = StopwatchFakeRepository(preBuild: true);
      storageBloc = StorageBloc(repository, EntityBloc(repository));

      measures = measuresHistory();
    });

    tearDown(() {});

    test('Initial state test', () {
      expect(storageBloc.state is LoadingStorageState, true);
    });

    blocTest<StorageBloc, StorageState>(
      'emit Storage events should change state',
      build: () => storageBloc,
      act: (bloc) {
        final filter = Filter.defaultFilter().copyWith(query: 'что');

        bloc
          ..add(const LoadStorageEvent(MeasureViewModel, measureId: null))
          ..add(FilterStorageEvent(MeasureViewModel, filter))
          ..add(const CancelFilterEvent(MeasureViewModel))
          ..add(const DeleteStorageEvent(<BaseStopwatchEntity>[]));
      },
      expect: () => [
        isA<AvailableListState>(),
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
        isA<AvailableListState>(),
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
      ],
    );

    blocTest<StorageBloc, StorageState>(
      'emit Storage load event should change state',
      build: () => storageBloc,
      verify: (bloc) async {
        final existsElements =
            (bloc.state as AvailableListState).entities.any((element) => true);
        expect(existsElements, true, reason: 'State has not loaded elemrnts!');
      },
      act: (bloc) {
        bloc.add(const LoadStorageEvent(MeasureViewModel, measureId: null));
      },
      expect: () => [
        isA<AvailableListState>(),
      ],
    );

    blocTest<StorageBloc, StorageState>(
      'emit Storage filter event should change state',
      build: () => storageBloc,
      verify: (bloc) async {
        final availableState = bloc.state as AvailableListState;
        final filteredEntities = availableState.entities
            .where((element) => element.comment!.contains('сто'));
        final onlyFilteredExists =
            filteredEntities.length == availableState.entities.length;
        expect(
          onlyFilteredExists,
          true,
          reason: 'Wrong count of filtered elements!',
        );

        final stateIsFiltered = availableState.filtered;
        expect(stateIsFiltered, true, reason: 'Flag not appear!');
      },
      seed: () =>
          AvailableListState(measuresHistory(), const [], Filter.empty()),
      act: (bloc) {
        final filter = Filter.defaultFilter().copyWith(query: 'сто');
        storageBloc.add(FilterStorageEvent(MeasureViewModel, filter));
      },
      expect: () => [
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
      ],
    );

    blocTest<StorageBloc, StorageState>(
      'emit Storage remove event should change state',
      build: () => storageBloc,
      verify: (bloc) async {
        final availableState = bloc.state as AvailableListState;

        expect(availableState.entities.isEmpty, true);
      },
      seed: () => AvailableListState(measures, measures, Filter.empty()),
      act: (bloc) {
        storageBloc.add(DeleteStorageEvent(measures));
      },
      expect: () => [
        isA<LoadingStorageState>(),
        isA<AvailableListState>(),
      ],
    );

    blocTest<StorageBloc, StorageState>(
      'States flow',
      build: () => storageBloc,
      wait: Duration.zero,
      act: (bloc) async {
        bloc
          ..add(const LoadStorageEvent(MeasureViewModel, measureId: null))
          ..add(FilterStorageEvent(MeasureViewModel, Filter.defaultFilter()))
          ..add(const CancelFilterEvent(MeasureViewModel))
          ..add(const DeleteStorageEvent(<BaseStopwatchEntity>[]));
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
