import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/settings/domain/repositories/settings_repository.dart';

class ToggleTheme {
  final SettingsRepository repository;

  ToggleTheme(this.repository);

  Future<Either<Exception, void>> call() {
    return repository.toggleTheme();
  }
}

