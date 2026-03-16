import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';
import 'test/features/settings/data/datasources/settings_local_datasource_test.mocks.dart';

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDatasource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockSettingsLocalDatasource();
    repository = SettingsRepositoryImpl(localDatasource: mockLocalDataSource);
  });

  group('SettingsRepositoryImpl', () {
    
    test('should return settings when getSettings is successful', () async {
      // Arrange
      when(mockLocalDataSource.getIsDarkMode()).thenAnswer((_) async => true);
      when(mockLocalDataSource.getFontFamily()).thenAnswer((_) async => 'Roboto');

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should return Right'),
        (r) {
          expect(r.isDarkMode, isTrue);
          expect(r.fontFamily, 'Roboto');
        },
      );
      verify(mockLocalDataSource.getIsDarkMode()).called(1);
      verify(mockLocalDataSource.getFontFamily()).called(1);
    });

    test('should toggle theme successfully', () async {
      // Arrange
      when(mockLocalDataSource.getIsDarkMode()).thenAnswer((_) async => false);
      when(mockLocalDataSource.setIsDarkMode(any)).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.toggleTheme();

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockLocalDataSource.setIsDarkMode(true)).called(1);
    });

    test('should change font successfully', () async {
      // Arrange
      const tFont = 'Arial';
      when(mockLocalDataSource.setFontFamily(any)).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.changeFont(tFont);

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockLocalDataSource.setFontFamily(tFont)).called(1);
    });

    test('should return exception when getSettings fails', () async {
      // Arrange
      when(mockLocalDataSource.getIsDarkMode()).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result.isLeft(), isTrue);
    });
  });
}