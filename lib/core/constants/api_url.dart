import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrl {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  static String get messageServerUrl => dotenv.env['MESSAGE_SERVER'] ?? 'http://10.0.2.2:8080';

  static const _auth = '/auth';
  static const _user = '/user';
  static const _feed = '/feed';
  static const _swipe = '/swipe';
  static final String message = '$messageServerUrl/messages';

  // Auth endpoints
  static String get login => '$baseUrl$_auth/login';
  static String get register => '$baseUrl$_auth/register';

  // User endpoints
  static String get profile => '$baseUrl$_user/profile';
  static String get updateProfile => '$baseUrl$_user/update';
  static String get updateFcmToken => '$baseUrl$_user/fcm-token';


  // Message endpoints
  static String get get_chat_list => '$message';
  static String get send_message => '$message/create';
  static String get get_conversation => '$message/conversation';

  //Feed endpoints
  static String get get_feed => '$baseUrl$_feed/get';

  //Swipe endpoint
static String get action_swipe => '$baseUrl$_swipe/action';
}
