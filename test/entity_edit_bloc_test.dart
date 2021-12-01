import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';

import 'fake_repos.dart';

void main() {
  group('EntityBloc test', () {
    late StopwatchFakeRepository repository;
    late EntityBloc entityBloc;

    late MeasureViewModel measure;

    setUp(() async {
      repository = StopwatchFakeRepository(preBuild: true);
      entityBloc = EntityBloc(repository);

      measure = MeasureViewModel.fromEntity(
        (await repository.getMeasuresByStatusAsync(
          describeEnum(StopwatchStatus.Finished),
        ))
            .first,
      );
    });

    tearDown(() {
      entityBloc.close();
    });

    test('Initial state test', () {
      expect(entityBloc.state is LoadingEntityState, true);
    });

    blocTest<EntityBloc, EntityState>(
      'emit OpenEntityEvent should change state',
      build: () => entityBloc,
      seed: () => AvailableEntityState(measure),
      act: (bloc) {
        entityBloc
          ..add(OpenEntityEvent(measure))
          ..add(SaveEntityEvent(measure, comment: 'Added comment'));
      },
      expect: () => <EntityState>[
        const LoadingEntityState(),
        AvailableEntityState(measure.copyWith(comment: 'Added comment'))
      ],
    );

    blocTest<EntityBloc, EntityState>(
      'States flow entity bloc',
      build: () => entityBloc,
      wait: Duration.zero,
      skip: 0,
      act: (bloc) async {
        final measure = MeasureViewModel.fromEntity(
          (await repository.getMeasuresByStatusAsync(
            describeEnum(StopwatchStatus.Finished),
          ))
              .first,
        );

        bloc
          ..add(OpenEntityEvent(measure))
          ..add(SaveEntityEvent(measure, comment: '100 m'));
      },
      verify: (bloc) async {},
      expect: () => [
        isA<AvailableEntityState>(),
        isA<LoadingEntityState>(),
        isA<AvailableEntityState>(),
      ],
    );
  });
}
