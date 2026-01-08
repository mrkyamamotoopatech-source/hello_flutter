import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _keyDebugNetwork = 'debugNetwork';
  static const _keyPageSize = 'pageSize';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  // ---- 読み込み ----
  bool getDebugNetwork() {
    return _prefs.getBool(_keyDebugNetwork) ?? false;
  }

  int getPageSize() {
    return _prefs.getInt(_keyPageSize) ?? 10;
  }

  // ---- 書き込み ----
  Future<void> setDebugNetwork(bool value) async {
    await _prefs.setBool(_keyDebugNetwork, value);
  }

  Future<void> setPageSize(int value) async {
    await _prefs.setInt(_keyPageSize, value);
  }
}
