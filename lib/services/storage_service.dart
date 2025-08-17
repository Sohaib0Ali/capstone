import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(key, value);
    // Log for evidence screenshot
    // ignore: avoid_print
    print('[StorageService] saveString key="$key" value="$value" => $ok');
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    // ignore: avoid_print
    print('[StorageService] getString key="$key" => "$value"');
    return value;
  }

  Future<void> saveBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setBool(key, value);
    // ignore: avoid_print
    print('[StorageService] saveBool key="$key" value=$value => $ok');
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(key) ?? defaultValue;
    // ignore: avoid_print
    print('[StorageService] getBool key="$key" => $value');
    return value;
  }
}
