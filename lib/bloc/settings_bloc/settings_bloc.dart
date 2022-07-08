import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stopwatch/resources/settings_repository.dart';

import '../../constants.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(SettingsRepository repository)
      : _repository = repository,
        super(SettingsUpdatingState()) {
    on<SettingsEvent>(
      (event, emitter) async {
        if (event is LoadSettingsEvent) {
          await _mapLoadSettingsToState(event, state, emitter);
        } else if (event is SetSettingsEvent) {
          _mapSetSettingsToState(event, state, emitter);
        }
      },
      transformer: sequential(),
    );
  }

  Future<void> _mapLoadSettingsToState(
    LoadSettingsEvent event,
    SettingsState state,
    Emitter<SettingsState> emitter,
  ) async {
    emitter(SettingsUpdatingState());

    await _repository.loadSettings();

    final settings = {
      prefSound: _repository.getBool(prefSound) ?? true,
      prefVibration: _repository.getBool(prefVibration) ?? true,
      prefKeepScreenAwake: _repository.getBool(prefKeepScreenAwake) ?? false,
      prefSaveMeasures: _repository.getBool(prefSaveMeasures) ?? true,
      prefTheme: _repository.getString(prefTheme) ?? greenLight
    };

    emitter(SettingsLoadedState(settings: settings));
  }

  void _mapSetSettingsToState(
    SetSettingsEvent event,
    SettingsState state,
    Emitter<SettingsState> emitter,
  ) {
    if (state is SettingsLoadedState) {
      if (event.value is String) {
        _repository.setString(key: event.key, value: event.value as String);
      } else if (event.value is bool) {
        _repository.setBool(key: event.key, value: event.value as bool);
      }

      final settings = Map<String, dynamic>.from(state.settings)
        ..[event.key] = event.value;

      emitter(state.copyWith(settings: settings));
    }

    emitter(state);
  }
}
