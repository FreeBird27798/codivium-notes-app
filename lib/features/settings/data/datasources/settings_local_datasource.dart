import 'package:codivium_notes_app/core/constants/db_constants.dart';
import 'package:codivium_notes_app/core/database/database_helper.dart';

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
      whereArgs: ['is_dark_mode'],
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
      whereArgs: ['is_dark_mode'],
    );
    if (existing.isEmpty) {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_dark_mode',
        'key': 'is_dark_mode',
        'value': value.toString(),
      });
    } else {
      await db.update(
        DbConstants.settingsTable,
        {'value': value.toString()},
        where: 'key = ?',
        whereArgs: ['is_dark_mode'],
      );
    }
  }

  @override
  Future<String> getFontFamily() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DbConstants.settingsTable,
      where: 'key = ?',
      whereArgs: ['font_family'],
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
      whereArgs: ['font_family'],
    );
    if (existing.isEmpty) {
      await db.insert(DbConstants.settingsTable, {
        DbConstants.columnId: 'setting_font_family',
        'key': 'font_family',
        'value': fontFamily,
      });
    } else {
      await db.update(
        DbConstants.settingsTable,
        {'value': fontFamily},
        where: 'key = ?',
        whereArgs: ['font_family'],
      );
    }
  }
}

