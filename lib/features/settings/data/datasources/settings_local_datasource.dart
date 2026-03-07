abstract class SettingsLocalDatasource {
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool value);
  Future<String> getFontFamily();
  Future<void> setFontFamily(String fontFamily);
}

class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  @override
  Future<bool> getIsDarkMode() async {
    throw UnimplementedError();
  }

  @override
  Future<void> setIsDarkMode(bool value) async {
    throw UnimplementedError();
  }

  @override
  Future<String> getFontFamily() async {
    throw UnimplementedError();
  }

  @override
  Future<void> setFontFamily(String fontFamily) async {
    throw UnimplementedError();
  }
}

