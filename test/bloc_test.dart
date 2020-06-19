
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

void main() {
  group('MeasureBloc', () {
    MeasureBloc measureBloc;
    StopwatchFakeRepository repository;

    setUp(() {
      repository = StopwatchFakeRepository();
      measureBloc = MeasureBloc(Ticker3(), repository);
    });

    tearDown(() {
      measureBloc?.close();
    });

    test('initial state test', () {
      final initialState = MeasureUpdatingState(MeasureViewModel());
      expect(measureBloc.initialState.props[0].toString(), initialState.props[0].toString());
    });

    //expectLater(actual, matcher) // TODO Асинхронный expect

    test("description", () async {
      // https://stackoverflow.com/questions/42611880/difference-between-await-for-and-listen-in-dart/42613676
      // https://pub.dev/packages/fake_async
      // https://stackoverflow.com/questions/56621534/how-to-unit-test-stream-listen-in-dart

      // flutter test wait for stream

      measureBloc.add(MeasureOpenedEvent());
      measureBloc.add(MeasureStartedEvent());

      final _testController = StreamController<bool>();


      measureBloc.listen((state) async {
        debugPrint("Listened " + state.toString());

        await Future.delayed(Duration(seconds: 2));

        //debugPrint("stateasfasfas");
        _testController.add(true);
      });

      expectLater(_testController.stream, emits(true));
      //_testController.close();

      //await Future.delayed(Duration(seconds: 2));

      //await Future.

      //expect()

      //expect(measureBloc.state, 1);

      //await emitsExactly(measureBloc, [1], skip: 2);
    });

    blocTest(
      'open',
      build: () async => measureBloc,
      wait: Duration(seconds: 0),
      act: (bloc) async {
        bloc.add(MeasureOpenedEvent());
        await Future.delayed(Duration(seconds: 2));

        bloc.add(MeasureStartedEvent());

        await Future.delayed(Duration(seconds: 1));
        bloc.add(MeasurePausedEvent());
        /*bloc.add(MeasureOpenedEvent());
        bloc.add(MeasureStartedEvent());
        bloc.add(MeasurePausedEvent());*/
      },

     verify: (bloc) async {
        //debugPrint("Test state ${(bloc as MeasureBloc).state}"); // Последне состояние
        //expect((bloc as MeasureBloc).state is MeasureReadyState , equals(true));
      },
      expect: [
        isA<MeasureReadyState>(),
        /*predicate<MeasureState>((state){
          debugPrint("Test state $state");
          return true;
        }),*/

        isA<MeasureUpdatingState>(),
        /*predicate<MeasureState>((state){
          debugPrint("Test state $state");
          return true;
        }),*/

        isA<MeasureStartedState>(),
        /*predicate<MeasureState>((state) {
          debugPrint("Matcher started measure: ${state.measure.toString()}");

          //debugPrint("Test state ${state.measure}");
          //expect(state.measure.status == StopwatchStatus.Started, equals(true), reason: "Status wrong!");
          expect(repository.sessions.length > 0, equals(true), reason: "Sessions empty!");
          //bool result  = true;
          return true;
        }),*/

        isA<MeasureUpdatingState>(),
        isA<MeasurePausedState>(),

        /*predicate<MeasureState>((state){
          bool result  = true;

          debugPrint("Matcher pause measure: ${state.measure.toString()}");

          return result;
        })*/
      ],
    );

    /*blocTest(
        'start',
        build: () async => measureBloc,
        wait: Duration(seconds: 2),
        skip: 1,
        act: (bloc) async => bloc.add(MeasureStartedEvent()),
        verify: (bloc) async {
          expect((bloc as MeasureBloc).state is MeasureStartedState , equals(true));
        }
    );*/

    /*test('StopwatchFakeRepository test', () async {
      final fakeRep = StopwatchFakeRepository();

      expect((await fakeRep.getMeasuresByStatusAsync("")), equals(null));
    });*/

  });
}