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

Future<bool> existsMeasure(StopwatchFakeRepository repository, StopwatchStatus status) async {
  final measures = await repository.getMeasuresByStatusAsync(describeEnum(status));
  return measures.length > 0;
}

void main() {
  group('StorageBloc', () {
    StopwatchFakeRepository repository;
    StorageBloc storageBloc;

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

      storageBloc.listen((state) async {
        debugPrint("Listened: " + state.toString());

      });

      expectLater(_testController.stream, emits(true));
    });

    blocTest(
      'States flow',
      build: () async => storageBloc,
      wait: Duration(seconds: 0),
      act: (bloc) async {
        bloc.add(LoadStorageEvent(MeasureViewModel));
        bloc.add(FilterStorageEvent(MeasureViewModel, Filter.defaultFilter()));
        bloc.add(CancelFilterEvent(MeasureViewModel));
        bloc.add(DeleteStorageEvent(List<BaseStopwatchEntity>()));
      },
      verify: (bloc) async {
      },
      expect: [
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
