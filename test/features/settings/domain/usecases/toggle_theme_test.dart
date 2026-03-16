import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:codivium_notes_app/features/settings/domain/usecases/toggle_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SettingsRepository])
import 'toggle_theme_test.mocks.dart'; 

void main() {
  late ToggleTheme usecase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = ToggleTheme(mockSettingsRepository);
  });

  test('should call toggleTheme from repository', () async {
    // Arrange
    when(mockSettingsRepository.toggleTheme())
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(null));
    verify(mockSettingsRepository.toggleTheme());
    verifyNoMoreInteractions(mockSettingsRepository);
  });
}