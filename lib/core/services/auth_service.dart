import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/dtos/login_dto.dart';
import 'package:fakelingo/core/services/http_service.dart';
import 'package:fakelingo/core/services/token_storage.dart';

class AuthService {

  final Dio _dio = HttpService().dio;

  Future<String> login(LoginDto dto) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: dto.toJson());
      final token = response.data.toString();
      TokenStorage.saveToken(token);
      return token;
    } catch (e) {
      throw Exception("Đăng nhập thất bại");
    }
  }

   Future<String> register() async {
    return "asd";
  }

  static void logout() {
    TokenStorage.clearToken();
  }
}
