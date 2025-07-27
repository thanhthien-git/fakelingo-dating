import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/models/feed_condition.dart';
import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/http_service.dart';

class FeedService {
  final Dio _dio = HttpService().dio;

  Future<List<User>> getFeedByCondition(FeedCondition condition) async{
    try {
      final response = await _dio.post(ApiUrl.get_feed, data: condition.toJson());

      final users = (response.data as List)
          .map((e) => User.fromJson(e))
          .toList();

      return users;
    }
        catch(e) {
      print("error while fetching users ${e.toString()}");
      return [];
        }
  }
}
