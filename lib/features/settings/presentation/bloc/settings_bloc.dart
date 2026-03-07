import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeFontEvent>(_onChangeFont);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {}

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<SettingsState> emit) async {}

  Future<void> _onChangeFont(ChangeFontEvent event, Emitter<SettingsState> emit) async {}
}

