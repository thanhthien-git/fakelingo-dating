import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/dtos/login_dto.dart';
import 'package:fakelingo/core/services/http_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final Dio _dio = HttpService().dio;
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<String> login(LoginDto dto) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: dto.toJson());
      final token = response.data.toString();
      StorageService.saveToken(token);
      return token;
    } catch (e) {
      throw Exception("Đăng nhập thất bại");
    }
  }

  Future<String> register({
    required String email,
    required String username,
    required String password,
    required String rePassword
  }) async {
    try {
      final response = await _dio.post(
        ApiUrl.register,
        data: jsonEncode({
          'email': email,
          'userName': username,
          'password': password,
          'rePassword': rePassword,
        }),
      );

      final token = response.data.toString();
      StorageService.saveToken(token);
      StorageService.setItem("isOnboarding", "1");
      StorageService.setItem("userName", username);
      return token;
    } catch (e) {
      print(e);
      throw Exception("Đăng ký thất bại");
    }
  }

  Future<String> verifyOtp(String digits, String userName) async {
    try {
      final response = await _dio.post(
        ApiUrl.verifyOtp,
        data: jsonEncode({'digits': digits, 'userName': userName}),
      );
      print(response.data);
      return response.data.toString();
    } catch (e) {
      throw Exception("Mã xác thực sai");
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId:
            '760280976254-97ns8kde8a3chpson424p6euru36o40e.apps.googleusercontent.com',
      );

      final account = await googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;

      final response = await _dio.post(
        ApiUrl.loginWithGoogle,
        data: {"idToken": auth.idToken},
      );
      final token = response.data.toString();
      StorageService.saveToken(token);
      return token;
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    StorageService.clearToken();
  }
}
