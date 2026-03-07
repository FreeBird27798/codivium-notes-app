import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource localDatasource;

  SettingsRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, AppSettings>> getSettings() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> toggleTheme() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> changeFont(String fontFamily) async {
    throw UnimplementedError();
  }
}

