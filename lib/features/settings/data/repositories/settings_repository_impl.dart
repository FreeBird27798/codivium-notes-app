import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource localDatasource;

  SettingsRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, AppSettings>> getSettings() async {
    try {
      final isDarkMode = await localDatasource.getIsDarkMode();
      final fontFamily = await localDatasource.getFontFamily();
      
      return Right(AppSettings(
        isDarkMode: isDarkMode,
        fontFamily: fontFamily,
      ));
    } catch (e) {
      return Left(Exception('Failed to load settings from local storage'));
    }
  }

  @override
  Future<Either<Exception, void>> toggleTheme() async {
    try {
      final currentMode = await localDatasource.getIsDarkMode();     
      await localDatasource.setIsDarkMode(!currentMode);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to toggle theme'));
    }
  }

  @override
  Future<Either<Exception, void>> changeFont(String fontFamily) async {
    try {
      await localDatasource.setFontFamily(fontFamily);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to change font family'));
    }
  }
}