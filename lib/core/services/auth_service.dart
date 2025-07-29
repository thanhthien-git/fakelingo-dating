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

  Future<String> register() async {
    return "asd";
  }

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: '760280976254-97ns8kde8a3chpson424p6euru36o40e.apps.googleusercontent.com'
      );

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        throw Exception("Đăng nhập Google bị hủy");
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      final response = await _dio.post(
        ApiUrl.loginWithGoogle,
        data: {
          "idToken": auth.idToken,
        },
      );
        final token = response.data.toString();

        StorageService.saveToken(token);
    }
    catch (e) {
      print(e);
    }
  }


  static void logout() {
    StorageService.clearToken();
  }
}
