import 'package:codivium_notes_app/core/constants/db_constants.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';


const String CACHED_IS_DARK_MODE = 'is_dark_mode';
const String CACHED_FONT_FAMILY = 'font_family';

abstract class SettingsLocalDatasource {
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool value);
  Future<String> getFontFamily();
  Future<void> setFontFamily(String fontFamily);
}

class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  final DatabaseHelper databaseHelper;

  SettingsLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<bool> getIsDarkMode() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.settingsTable,
      where: 'key = ?',
      whereArgs: [CACHED_IS_DARK_MODE],
    );
    if (result.isEmpty) return false;
    return result.first['value'] == 'true';
  }

  @override
  Future<void> setIsDarkMode(bool value) async {
    final db = await databaseHelper.database;
    final existing = await db.query(
      DbConstants.settingsTable,
      where: 'key = ?',
      whereArgs: [CACHED_IS_DARK_MODE],
    );
    if (existing.isEmpty) {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_dark_mode',
        'key': CACHED_IS_DARK_MODE,
        'value': value.toString(),
      });
    } else {
      await db.update(
        DbConstants.settingsTable,
        {'value': value.toString()},
        where: 'key = ?',
        whereArgs: [CACHED_IS_DARK_MODE],
      );
    }
  }

  @override
  Future<String> getFontFamily() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.settingsTable,
      where: 'key = ?',
      whereArgs: [CACHED_FONT_FAMILY],
    );
    if (result.isEmpty) return 'Roboto';
    return result.first['value'] as String;
  }

  @override
  Future<void> setFontFamily(String fontFamily) async {
    final db = await databaseHelper.database;
    final existing = await db.query(
      DbConstants.settingsTable,
      where: 'key = ?',
      whereArgs: [CACHED_FONT_FAMILY],
    );
    if (existing.isEmpty) {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_font_family',
        'key': CACHED_FONT_FAMILY,
        'value': fontFamily,
      });
    } else {
      await db.update(
        DbConstants.settingsTable,
        {'value': fontFamily},
        where: 'key = ?',
        whereArgs: [CACHED_FONT_FAMILY],
      );
    }
  }
}