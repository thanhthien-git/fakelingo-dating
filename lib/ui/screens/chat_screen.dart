import 'package:fakelingo/core/models/message_model.dart';
import 'package:fakelingo/core/services/message_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatBoxScreen extends StatefulWidget {
  final String conversationId;
  final String? lastMessageId;

  const ChatBoxScreen({
    super.key,
    required this.conversationId,
    this.lastMessageId,
  });

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  final List<MessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final messageService = MessageService();

  bool _isLoading = false;
  bool _hasMore = true;
  bool _initialLoadComplete = false;
  @override
  void initState() {
    super.initState();
    fetchMessages(null);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_initialLoadComplete) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        _scrollController.position.userScrollDirection == ScrollDirection.reverse &&
        !_isLoading &&
        _hasMore &&
        messages.isNotEmpty) {
      // Lấy ID của tin nhắn cũ nhất làm beforeMessageId
      String beforeMessageId = messages.first.id;
      fetchMessages(beforeMessageId);
    }
  }

  Future<void> fetchMessages(String? beforeMessageId) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final fetched = await messageService.getConversationById(
        widget.conversationId,
        beforeMessageId ?? '',
      );

      if (fetched.isEmpty) {
        setState(() => _hasMore = false);
      } else {
        setState(() {
          if (beforeMessageId == null || beforeMessageId.isEmpty) {
            messages.addAll(fetched);
            _initialLoadComplete = true;
          } else {
            messages.insertAll(0, fetched);
          }
        });

        if (beforeMessageId == null || beforeMessageId.isEmpty) {
          scrollToBottom();
        }
      }
    } catch (err) {
      print('Error loading messages: $err');
      if (beforeMessageId == null || beforeMessageId.isEmpty) {
        setState(() => _initialLoadComplete = true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: const Color(0xFFFDD405),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                reverse: false, // Giữ nguyên false
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: messages.length + (_isLoading || _hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // Loading indicator ở đầu danh sách (tin nhắn cũ)
                  if (index == 0 && _isLoading && _hasMore) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Điều chỉnh index khi có loading indicator
                  int messageIndex = _isLoading && _hasMore ? index - 1 : index;

                  if (messageIndex >= messages.length || messageIndex < 0) {
                    return const SizedBox(height: 20);
                  }

                  final msg = messages[messageIndex];
                  final isMe = msg.senderId == StorageService.getItem('user_id');

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFFB388FF) : const Color(0xFFFDD405),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                          fontSize: 16,
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.amber),
                  onPressed: () {
                    // TODO: Handle send
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}