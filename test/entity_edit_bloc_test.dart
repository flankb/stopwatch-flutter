import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';


void main() {
  group('EntityBloc', () {
    StopwatchFakeRepository repository;
    EntityBloc entityBloc;

    setUp(() {
      repository = StopwatchFakeRepository(preBuild: true);
      entityBloc = EntityBloc(repository);
    });

    tearDown(() {
      entityBloc?.close();
    });

    test('Initial state test', () {
      expect(entityBloc.state is LoadingEntityState, true);
    });

    test("Full entity bloc test", () async {
      final _testController = StreamController<bool>();
      int counterStates = 0;
      MeasureViewModel measure = MeasureViewModel.fromEntity((await repository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished))).first);

      entityBloc.listen((state) async {
        debugPrint("Listened: " + state.toString());
        if (counterStates == 2) {
          // Проверим, что сущность изменилась
          final measureUpdate = (await repository.getMeasuresByIdAsync(measure.id));
          debugPrint("Red entity: " + measureUpdate.toString());
          expect(measureUpdate.comment == "Added comment", true, reason: "Не обновился комментарий!");
        }

        if (counterStates == 2) {
          _testController.add(true);
          _testController.close();
        }

        counterStates++;
      });

      entityBloc.add(OpenEntityEvent(measure));
      measure.comment = "Added comment";
      entityBloc.add(SaveEntityEvent(measure));

      expectLater(_testController.stream, emits(true));
    });

    blocTest(
      'States flow entity bloc',
      build: () async => entityBloc,
      wait: Duration(seconds: 0),
      skip: 0,
      act: (bloc) async {
        MeasureViewModel measure = MeasureViewModel.fromEntity((await repository.getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished))).first);

        bloc.add(OpenEntityEvent(measure));
        measure.comment = "100 m";

        bloc.add(SaveEntityEvent(measure));
      },
      verify: (bloc) async {
      },
      expect: [
        isA<LoadingEntityState>(),
        isA<AvailableEntityState>(),
        isA<AvailableEntityState>(),
      ],
    );
  });
}