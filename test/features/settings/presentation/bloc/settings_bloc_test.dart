import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;
    late MockSettingsRepository mockSettingsRepository;
    late MockToggleTheme mockToggleTheme;
    late MockChangeFont mockChangeFont;

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      mockToggleTheme = MockToggleTheme();
      mockChangeFont = MockChangeFont();
      settingsBloc = SettingsBloc(
        settingsRepository: mockSettingsRepository,
        toggleTheme: mockToggleTheme,
        changeFont: mockChangeFont,
      );
    });

    tearDown(() {
      settingsBloc.close();
    });

    test('initial state should be SettingsInitial', () {
      expect(settingsBloc.state, SettingsInitial());
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits [] when nothing is added',
      build: () => SettingsBloc(
        settingsRepository: mockSettingsRepository,
        toggleTheme: mockToggleTheme,
        changeFont: mockChangeFont,
      ),
      expect: () => [],
    );
  });
}
