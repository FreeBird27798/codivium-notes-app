import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Exception, AppSettings>> getSettings();
  Future<Either<Exception, void>> toggleTheme();
  Future<Either<Exception, void>> changeFont(String fontFamily);
}
