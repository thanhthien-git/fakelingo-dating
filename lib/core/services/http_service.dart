import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/services/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  static final Map<String?, HttpService> _instances = {};

  late final Dio dio;

  factory HttpService([String? type]) {
    return _instances.putIfAbsent(type, () => HttpService._internal(type));
  }

  HttpService._internal(String? type) {
    final baseUrl = _getBaseUrlByType(type);

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  String _getBaseUrlByType(String? type) {
    switch (type) {
      case 'message':
        return ApiUrl.messageServerUrl;
      default:
        return ApiUrl.baseUrl;
    }
  }
}
