import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/models/filter.dart';
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
        //final availableState = (state is AvailableListState) ? state : null;
        /*if (counterStates == 1) {
          // проверим, что сущность изменилась
          final measureUpdate = (await repository.getMeasuresByIdAsync(measure.id));

          debugPrint("Readed entity: " + measureUpdate.toString());

          expect(measureUpdate.comment == "Added comment", true, reason: "Не обновился комментарий!");
        }*/

        if (counterStates == 1) {
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
        bloc.add(SaveEntityEvent(measure));
      },
      verify: (bloc) async {
      },
      expect: [
        isA<LoadingEntityState>(),
        isA<AvailableEntityState>(),
      ],
    );
  });
}