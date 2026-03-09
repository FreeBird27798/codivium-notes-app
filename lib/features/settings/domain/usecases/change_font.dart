import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';

class ChangeFont {
  final SettingsRepository repository;

  ChangeFont(this.repository);

  Future<Either<Exception, void>> call(String fontFamily) {
    return repository.changeFont(fontFamily);
  }
}
