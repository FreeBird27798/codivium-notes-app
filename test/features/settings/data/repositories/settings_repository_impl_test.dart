import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';
import '../../../../helpers/test_helpers.mocks.dart';

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
      // "لمسة صنايعية": استخدمنا الـ stubbing المناسب
      when(mockLocalDataSource.getIsDarkMode()).thenAnswer((_) async => true);
      when(
        mockLocalDataSource.getFontFamily(),
      ).thenAnswer((_) async => 'Roboto');

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result, isA<Right<dynamic, AppSettings>>());
      result.fold((l) => fail('Should return Right'), (r) {
        expect(r.isDarkMode, isTrue);
        expect(r.fontFamily, 'Roboto');
      });
    });

    test('should toggle theme successfully', () async {
      // Arrange
      when(mockLocalDataSource.getIsDarkMode()).thenAnswer((_) async => false);
      // "لمسة صنايعية": setIsDarkMode بترجع Future<void>
      when(mockLocalDataSource.setIsDarkMode(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.toggleTheme();

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockLocalDataSource.getIsDarkMode()).called(1);
      verify(mockLocalDataSource.setIsDarkMode(true)).called(1);
    });

    test('should change font successfully', () async {
      // Arrange
      const tFont = 'Arial';
      when(mockLocalDataSource.setFontFamily(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.changeFont(tFont);

      // Assert
      expect(result.isRight(), isTrue);
      verify(mockLocalDataSource.setFontFamily(tFont)).called(1);
    });

    test('should return exception when getSettings fails', () async {
      // Arrange
      when(
        mockLocalDataSource.getIsDarkMode(),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result.isLeft(), isTrue);
    });
  });
}
