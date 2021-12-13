part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  T? getSettingsValue<T>(String key) => null;

  @override
  List<Object> get props => [];
}

class SettingsUpdatingState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsLoadedState({this.settings = const <String, dynamic>{}});

  @override
  List<Object> get props => [settings];

  @override
  T? getSettingsValue<T>(String key) {
    if (!settings.containsKey(key)) {
      return null;
    }

    final dynamic value = settings[key];
    return value is T ? settings[key] as T : null;
  }

  SettingsLoadedState copyWith({
    Map<String, dynamic>? settings,
  }) =>
      SettingsLoadedState(
        settings: settings ?? this.settings,
      );
}
