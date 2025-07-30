import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/dtos/swipe_dto.dart';
import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/http_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';

class SwipeService {
  final Dio _dio = HttpService().dio;

  Future<void> action(SwipeDto swipe) async {
    try {
      final response = await _dio.post(
        ApiUrl.action_swipe,
        data: swipe.toJson(),
      );
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<List<User>> getUnread(int page, int pageSize) async {
    try {
      final response = await _dio.get(
        ApiUrl.unread_swipe,
        queryParameters: {
          "page": page,
          "limit": pageSize,
        },
      );

      print('Raw Response: ${response.data}');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error in getUnread: $e');
      return [];
    }
  }

}
