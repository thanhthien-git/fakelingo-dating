import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/services/http_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Dio _dio = HttpService().dio;

  Future<void> initFcm() async {
    print('init firebase');

    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await sendTokenToServer(token);
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }


  Future<bool> sendTokenToServer(String token) async {
    try {
      await _dio.post(
        ApiUrl.updateFcmToken,
        data: {'fcmToken': token},
      );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
