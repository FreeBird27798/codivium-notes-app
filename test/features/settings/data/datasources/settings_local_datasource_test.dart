import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';

import 'settings_local_datasource_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late SettingsLocalDatasourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    dataSource = SettingsLocalDatasourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('SettingsLocalDatasource', () {
    
    group('Dark Mode Operations', () {
      test('should return true when dark mode is stored as true in database', () async {
        // Arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => [{'key': 'is_dark_mode', 'value': 'true'}]);

        // Act
        final result = await dataSource.getIsDarkMode();

        // Assert
        expect(result, isTrue);
      });

      test('should call insert when saving dark mode for the first time', () async {
        // Arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => []);

        // Act
        await dataSource.setIsDarkMode(true);

        // Assert
        verify(mockDatabase.insert(any, any)).called(1);
      });
    });

    group('Font Family Operations', () {
      test('should return default font family (Roboto) when no font is stored', () async {
        // Arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => []);

        // Act
        final result = await dataSource.getFontFamily();

        // Assert
        expect(result, equals('Roboto'));
      });

      test('should call update when font family setting already exists', () async {
        // Arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(mockDatabase.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => [{'key': 'font_family', 'value': 'Arial'}]);

        // Act
        await dataSource.setFontFamily('Roboto');

        // Assert
        verify(mockDatabase.update(any, any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).called(1);
      });
    });

  });
}