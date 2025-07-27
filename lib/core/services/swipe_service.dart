import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/dtos/swipe_dto.dart';
import 'package:fakelingo/core/services/http_service.dart';

class SwipeService {
  final Dio _dio = HttpService().dio;

  Future<void> action(SwipeDto swipe) async {
    try {
      final response = await _dio.post(ApiUrl.action_swipe, data: swipe.toJson());
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
