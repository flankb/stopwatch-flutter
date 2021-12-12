import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stopwatch/resources/settings_repository.dart';

import '../../constants.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(SettingsRepository repository)
      : _repository = repository,
        super(SettingsUpdatingState());

  Stream<SettingsState> _mapLoadSettingsToState(
    LoadSettingsEvent event,
    SettingsState state,
  ) async* {
    yield SettingsUpdatingState();

    await _repository.loadSettings();

    final settings = {
      prefSound: _repository.getBool(prefSound) ?? true,
      prefVibration: _repository.getBool(prefVibration) ?? true,
      prefKeepScreenAwake: _repository.getBool(prefKeepScreenAwake) ?? false,
      prefSaveMeasures: _repository.getBool(prefSaveMeasures) ?? true,
      prefTheme: _repository.getString(prefTheme) ?? greenLight
    };

    yield SettingsLoadedState(settings: settings);
  }

  SettingsState _mapSetSettingsToState(
    SetSettingsEvent event,
    SettingsState state,
  ) {
    if (state is SettingsLoadedState) {
      if (event.value is String) {
        _repository.setString(key: event.key, value: event.value as String);
      } else if (event.value is bool) {
        _repository.setBool(key: event.key, value: event.value as bool);
      }

      final settings = Map<String, dynamic>.from(state.settings)
        ..[event.key] = event.value;

      return state.copyWith(settings: settings);
    }

    return state;
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadSettingsEvent) {
      yield* _mapLoadSettingsToState(event, state);
    } else if (event is SetSettingsEvent) {
      yield _mapSetSettingsToState(event, state);
    }
  }
}
