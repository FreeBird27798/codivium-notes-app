import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test_helpers.mocks.dart'; 
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';

void main() {
  group('SettingsBloc', () {
    late SettingsBloc settingsBloc;
    late MockSettingsRepository mockSettingsRepository;
    late MockToggleTheme mockToggleTheme;
    late MockChangeFont mockChangeFont;

    final tAppSettings = AppSettings(isDarkMode: false, fontFamily: 'Default');

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      mockToggleTheme = MockToggleTheme();
      mockChangeFont = MockChangeFont();
    });

    test('initial state should be SettingsInitial', () {
      settingsBloc = SettingsBloc(
        settingsRepository: mockSettingsRepository,
        toggleTheme: mockToggleTheme,
        changeFont: mockChangeFont,
      );
      expect(settingsBloc.state, SettingsInitial());
      settingsBloc.close();
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits [SettingsLoading, SettingsLoaded] when LoadSettings is added',
      build: () {
        when(() => mockSettingsRepository.getSettings())
            .thenAnswer((_) async => Right(tAppSettings));
        
        return SettingsBloc(
          settingsRepository: mockSettingsRepository,
          toggleTheme: mockToggleTheme,
          changeFont: mockChangeFont,
        );
      },
      act: (bloc) => bloc.add(LoadSettings()),
      expect: () => [SettingsLoading(), SettingsLoaded(tAppSettings)],
    );

    blocTest<SettingsBloc, SettingsState>(
      'should call toggleTheme usecase and refresh settings without loading flicker',
      build: () {
        when(() => mockToggleTheme()).thenAnswer((_) async => const Right(null));
        when(() => mockSettingsRepository.getSettings())
            .thenAnswer((_) async => Right(tAppSettings));
        
        return SettingsBloc(
          settingsRepository: mockSettingsRepository,
          toggleTheme: mockToggleTheme,
          changeFont: mockChangeFont,
        );
      },
      act: (bloc) => bloc.add(ToggleThemeEvent()),
      expect: () => [SettingsLoaded(tAppSettings)], 
      verify: (_) {
        verify(() => mockToggleTheme()).called(1);
      },
    );
  });
}