import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/models/chat_item_model.dart';
import 'package:fakelingo/core/models/send_message_model.dart';
import 'package:fakelingo/core/services/http_service.dart';

class MessageService {
  final Dio _dio = HttpService("message").dio;

  Future<List<ChatList>> getChatList() async {
    try {
      final response = await _dio.get(ApiUrl.get_chat_list);

      final List<dynamic> data = response.data;

      return data.map((json) => ChatList.fromJson(json)).toList();
    } catch (e) {
      print('Error when getting chat list: $e');
      return [];
    }
  }

  Future<dynamic> sendMessage(SendMessageModel message) async {
    try {
      final response = await _dio.patch(ApiUrl.send_message, data: message);
      return response.data;
    }
    catch (e) {
      print('Error when sending message: $e');
    }
  }
}