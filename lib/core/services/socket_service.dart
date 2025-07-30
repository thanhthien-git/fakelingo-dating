import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fakelingo/core/constants/api_url.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late IO.Socket socket;

  void initSocket(
      String userId, {
        Function(Map<String, dynamic>)? onNewMessage,
        required BuildContext context, // Thêm context để show popup
      }) {
    socket = IO.io(
      ApiUrl.messageServerUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) => print('✅ Socket connected'));
    socket.onDisconnect((_) => print('❌ Socket disconnected'));
    socket.onConnectError((err) => print('⚠️ Connect error: $err'));
    socket.onError((err) => print('⚠️ Socket error: $err'));

    socket.on('receive_message', (data) {
      print('📩 Tin nhắn mới: $data');
      if (onNewMessage != null && data is Map<String, dynamic>) {
        onNewMessage(data);
      }
    });

    socket.on('has_blocked', (data) {
      print('🚫 Bị block: $data');

      final message =
      data is Map<String, dynamic> ? data['message'] ?? 'You have been blocked due to harmful message.' : 'You have been blocked.';

      // Hiển thị popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('🚫 Blocked'),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }

  void dispose() {
    socket.disconnect();
  }
}
