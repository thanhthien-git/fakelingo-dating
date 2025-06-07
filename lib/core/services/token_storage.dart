import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = 'access_token';
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void saveToken(String token) {
    _prefs.setString(_key, token);
  }

  static String? getToken() {
    return _prefs.getString(_key);
  }

  static void clearToken() {
    _prefs.remove(_key);
  }
}
