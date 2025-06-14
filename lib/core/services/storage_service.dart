import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _token_key = 'access_token';
  static const _user_id = 'user_id';
  static const _user_name = 'user_name';

  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setItem(String key, String value) {
    _prefs.setString(key, value);
  }

  static String? getItem(String key) {
    return _prefs.getString(key);
  }

  static void saveToken(String token) {
    setItem(_token_key, token);
  }

  static String? getToken() {
    return getItem(_token_key);
  }

  static void clearToken() {
    _prefs.remove(_user_id);
    _prefs.remove(_user_name);
    _prefs.remove(_token_key);
  }
}
