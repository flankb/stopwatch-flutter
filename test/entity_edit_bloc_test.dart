import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:bloc_test/bloc_test.dart';

import 'fake_repos.dart';

void main() {
  group('EntityBloc test', () {
    late StopwatchFakeRepository repository;
    late EntityBloc entityBloc;

    late MeasureViewModel measure;

    setUp(() async {
      repository = StopwatchFakeRepository(preBuild: true);
      entityBloc = EntityBloc(repository);

      measure = MeasureViewModel.fromEntity((await repository
              .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished)))
          .first);
    });

    tearDown(() {
      entityBloc.close();
    });

    test('Initial state test', () {
      expect(entityBloc.state is LoadingEntityState, true);
    });

    // test("Full entity bloc test", () async {
    //   final _testController = StreamController<bool>();
    //   int counterStates = 0;
    //   MeasureViewModel measure = MeasureViewModel.fromEntity((await repository
    //           .getMeasuresByStatusAsync(describeEnum(StopwatchStatus.Finished)))
    //       .first);

    //   entityBloc.stream.listen((state) async {
    //     debugPrint("Listened: " + state.toString());
    //     if (counterStates == 2) {
    //       // Проверим, что сущность изменилась
    //       final measureUpdate =
    //           (await repository.getMeasuresByIdAsync(measure.id!));
    //       debugPrint("Red entity: " + measureUpdate.toString());
    //       expect(measureUpdate.comment == "Added comment", true,
    //           reason: "Не обновился комментарий!");
    //     }

    //     if (counterStates == 2) {
    //       _testController.add(true);
    //       _testController.close();
    //     }

    //     counterStates++;
    //   });

    //   entityBloc.add(OpenEntityEvent(measure));
    //   entityBloc.add(SaveEntityEvent(measure, comment: "Added comment"));

    //   expectLater(_testController.stream, emits(true));
    // });

    blocTest<EntityBloc, EntityState>(
        'emit OpenEntityEvent should change state',
        build: () {
          return entityBloc;
        },
        seed: () => AvailableEntityState(measure),
        //EntityState.getUpdatedVersion()
        //AvailableEntityState:AvailableEntityState(2, MeasureViewModel{id: 2, comment: Пробежка,  elapsed: 10000, elapsedLap: 0, dateCreated: 2021-10-31 21:24:03.837296, status: StopwatchSt
        act: (bloc) {
          entityBloc
            ..add(OpenEntityEvent(measure))
            ..add(SaveEntityEvent(measure, comment: "Added comment"));
        },
        expect: () => <EntityState>[]);

    blocTest<EntityBloc, EntityState>(
      'States flow entity bloc',
      build: () => entityBloc,
      wait: Duration(seconds: 0),
      skip: 0,
      act: (bloc) async {
        MeasureViewModel measure = MeasureViewModel.fromEntity(
            (await repository.getMeasuresByStatusAsync(
                    describeEnum(StopwatchStatus.Finished)))
                .first);

        bloc.add(OpenEntityEvent(measure));
        bloc.add(SaveEntityEvent(measure, comment: "100 m"));
      },
      verify: (bloc) async {},
      expect: () => [
        isA<LoadingEntityState>(),
        isA<AvailableEntityState>(),
        isA<AvailableEntityState>(),
      ],
    );
  });
}
