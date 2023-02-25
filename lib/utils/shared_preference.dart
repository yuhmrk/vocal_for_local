import 'package:shared_preferences/shared_preferences.dart';

class Shared_Preference {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  //sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefsInstance!.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefsInstance!.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefsInstance!.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefsInstance!.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefsInstance!.setStringList(key, value);

  //gets
  static bool getBool(String key) => _prefsInstance!.getBool(key) ?? false;

  static double getDouble(String key) => _prefsInstance!.getDouble(key) ?? 0.0;

  static int getInt(String key) => _prefsInstance!.getInt(key) ?? 0;

  static String getString(String key) =>
      _prefsInstance!.getString(key) ?? "N/A";

  static List<String> getStringList(String key) =>
      _prefsInstance!.getStringList(key) ?? [];

  //deletes..
  static Future<bool> remove(String key) async =>
      await _prefsInstance!.remove(key);

  static Future<bool> clear() async => await _prefsInstance!.clear();
}

class SharedPreferenceKeys {
  static String isLogin = "isLogin";
}
