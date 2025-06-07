import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrl {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  static const _auth = '/auth';
  static const _user = '/user';

  // Auth endpoints
  static String get login => '$baseUrl$_auth/login';
  static String get register => '$baseUrl$_auth/register';

  // User endpoints
  static String get profile => '$baseUrl$_user/profile';
  static String get updateProfile => '$baseUrl$_user/update';
}
