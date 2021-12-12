part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class SetSettingsEvent<T extends Object> extends SettingsEvent {
  final String key;
  final T value;

  const SetSettingsEvent(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}
