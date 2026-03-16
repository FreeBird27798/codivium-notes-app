import 'package:codivium_notes_app/features/settings/domain/usecases/change_font.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'toggle_theme_test.mocks.dart';

void main() {
  late ChangeFont usecase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    usecase = ChangeFont(mockSettingsRepository);
  });

  test('should call changeFont from repository with correct font', () async {
    // Arrange
    const tFont = 'Arial';
    when(mockSettingsRepository.changeFont(any))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(tFont);

    // Assert
    expect(result, const Right(null));
    verify(mockSettingsRepository.changeFont(tFont));
    verifyNoMoreInteractions(mockSettingsRepository);
  });
}