import 'package:dio/dio.dart';
import 'package:fakelingo/core/constants/api_url.dart';
import 'package:fakelingo/core/models/chat_item_model.dart';
import 'package:fakelingo/core/models/message_model.dart';
import 'package:fakelingo/core/models/send_message_model.dart';
import 'package:fakelingo/core/services/http_service.dart';

class MessageService {
  final Dio _dio = HttpService("message").dio;

  Future<List<ChatList>> getChatList() async {
    try {
      final response = await _dio.get(ApiUrl.get_chat_list);

      final List<dynamic> data = response.data;
      print(data);
      return data.map((json) => ChatList.fromJson(json)).toList();
    } catch (e) {
      print('Error when getting chat list: $e');
      return [];
    }
  }

  Future<List<MessageModel>> getConversationById(
    String conversationId,
    String beforeMessageId,
  ) async {
    try {
      var url = '${ApiUrl.get_conversation}?id=$conversationId';

      if (beforeMessageId.isNotEmpty) {
        url = '$url&before=$beforeMessageId';
      }
      final response = await this._dio.get(url);

      List<MessageModel> messages = (response.data as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();

      return messages;
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<dynamic> sendMessage(SendMessageModel message) async {
    try {
      final response = await _dio.post(ApiUrl.send_message, data: message);
      return response.data;
    } catch (e) {
      print('Error when sending message: $e');
    }
  }
}
