import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;

    setUp(() {
      settingsBloc = SettingsBloc();
    });

    tearDown(() {
      settingsBloc.close();
    });

    test('initial state should be SettingsInitial', () {
      expect(settingsBloc.state, SettingsInitial());
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits [] when nothing is added',
      build: () => settingsBloc,
      expect: () => [],
    );
  });
}


