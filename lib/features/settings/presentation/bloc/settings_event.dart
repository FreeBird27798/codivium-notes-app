import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {}

class ChangeFontEvent extends SettingsEvent {
  final String fontFamily;
  const ChangeFontEvent(this.fontFamily);

  @override
  List<Object?> get props => [fontFamily];
}

