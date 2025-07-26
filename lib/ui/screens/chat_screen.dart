import 'package:fakelingo/core/constants/colors.dart';
import 'package:fakelingo/core/models/message_model.dart';
import 'package:fakelingo/core/models/send_message_model.dart';
import 'package:fakelingo/core/services/message_service.dart';
import 'package:fakelingo/core/services/socket_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ChatBoxScreen extends StatefulWidget {
  final String conversationId;
  final String? lastMessageId;
  final String displayName;
  final String targetUserId;
  final String targetUsername;
  final String? avatarUrl;

  const ChatBoxScreen({
    super.key,
    required this.conversationId,
    this.lastMessageId,
    required this.displayName,
    required this.targetUserId,
    required this.targetUsername,
    this.avatarUrl
  });

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen>
    with TickerProviderStateMixin {
  final List<MessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final socketService = SocketService();
  final messageService = MessageService();
  final String userId = StorageService.getItem("user_id").toString();

  bool _isLoading = false;
  bool _hasMore = true;
  bool _initialLoadComplete = false;

  // Animation controllers for new messages
  final Map<String, AnimationController> _messageAnimations = {};
  final Map<String, Animation<double>> _slideAnimations = {};
  final Map<String, Animation<double>> _fadeAnimations = {};
  final Map<String, Animation<double>> _scaleAnimations = {};

  late SendMessageModel _baseMessageData;

  @override
  void initState() {
    super.initState();
    fetchMessages(null);
    _baseMessageData = SendMessageModel(toUserName: widget.targetUsername, toUserId: widget.targetUserId,fromUsername: StorageService.getItem('user_name').toString(), fromUserId: userId, content: '');

    _scrollController.addListener(_onScroll);
    _setupSocketListener();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _messageAnimations.values) {
      controller.dispose();
    }
    _messageAnimations.clear();
    super.dispose();
  }

  void _onScroll() {
    if (!_initialLoadComplete) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore &&
        messages.isNotEmpty) {
      String beforeMessageId = messages.first.id;
      fetchMessages(beforeMessageId);
    }
  }

  void _setupSocketListener() {
    socketService.socket.on('receive_message', (data) {
      if (data is Map<String, dynamic>) {
        _handleNewMessage(data);
      }
    });
  }

  void _createMessageAnimation(String messageId) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _messageAnimations[messageId] = controller;
    _slideAnimations[messageId] = slideAnimation;
    _fadeAnimations[messageId] = fadeAnimation;
    _scaleAnimations[messageId] = scaleAnimation;

    // Start animation
    controller.forward();

    // Clean up after animation completes
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (_messageAnimations.containsKey(messageId)) {
            _messageAnimations[messageId]?.dispose();
            _messageAnimations.remove(messageId);
            _slideAnimations.remove(messageId);
            _fadeAnimations.remove(messageId);
            _scaleAnimations.remove(messageId);
          }
        });
      }
    });
  }

  void _handleNewMessage(Map<String, dynamic> messageData) {
    final conversationId = messageData['conversationId'];
    final content = messageData['content'];
    final senderId = messageData['senderId'];
    final receiverId = messageData['receiverId'];
    final createAt = messageData['createdAt'];
    final id = messageData['_id'];

    if (conversationId == null ||
        content == null ||
        senderId == null ||
        id == null ||
        conversationId != widget.conversationId) {
      return;
    }

    final newMessage = MessageModel(
        id: id,
        content: content,
        senderId: senderId,
        conversationId: conversationId,
        isRead: false,
        receiverId: receiverId,
        createdAt: DateTime.parse(createAt)
    );

    if (!mounted) return;

    setState(() {
      messages.add(newMessage);
    });

    _createMessageAnimation(id);

    HapticFeedback.lightImpact();

    _scrollToBottom();
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
          _scrollToBottom();
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && messages.isNotEmpty) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final tempMessage = MessageModel(
      id: tempId,
      content: content,
      senderId: userId ?? '',
      conversationId: widget.conversationId,
      isRead: false,
      receiverId: widget.targetUserId,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(tempMessage);
    });

    _createMessageAnimation(tempId);

    HapticFeedback.selectionClick();

    _controller.clear();
    _scrollToBottom();
    await messageService.sendMessage(new SendMessageModel(fromUsername: _baseMessageData.fromUsername, fromUserId: _baseMessageData.fromUserId, toUserName: _baseMessageData.toUserName, toUserId: _baseMessageData.toUserId, content: content));
  }

  Widget _buildAnimatedMessage({
    required MessageModel msg,
    required bool isMe,
    required bool showAvatar,
    required BuildContext context,
  }) {
    final hasAnimation = _messageAnimations.containsKey(msg.id);

    Widget messageWidget = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: showAvatar
                  ? (widget.avatarUrl != null
                  ? CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.avatarUrl!),
              )
                  : CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ))
                  : const Opacity(
                opacity: 0,
                child: CircleAvatar(radius: 20),
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isMe ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 6),
                  bottomRight: Radius.circular(isMe ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isMe
                        ? const Color(0xFFE91E63).withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.content,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : const Color(0xFF424242),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE91E63), width: 1.5),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                ),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );

    // Apply animations if they exist
    if (hasAnimation) {
      return AnimatedBuilder(
        animation: _messageAnimations[msg.id]!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              isMe ? _slideAnimations[msg.id]!.value : -_slideAnimations[msg.id]!.value,
              0,
            ),
            child: Transform.scale(
              scale: _scaleAnimations[msg.id]!.value,
              child: Opacity(
                opacity: _fadeAnimations[msg.id]!.value,
                child: messageWidget,
              ),
            ),
          );
        },
      );
    }

    return messageWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFE91E63), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                      ? NetworkImage(widget.avatarUrl!)
                      : null,
                  child: (widget.avatarUrl == null || widget.avatarUrl!.isEmpty)
                      ? Icon(Icons.person, color: Colors.grey, size: 20)
                      : null,
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              widget.displayName.trim(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.tinderPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF8FA),
                    Color(0xFFFFF0F5),
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == messages.length) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    );
                  }

                  final reversedIndex = messages.length - 1 - index;

                  if (reversedIndex < 0 || reversedIndex >= messages.length) {
                    return const SizedBox.shrink();
                  }

                  final msg = messages[reversedIndex];
                  final prevMsg = reversedIndex < messages.length - 1 ? messages[reversedIndex + 1] : null;
                  final isMe = msg.senderId == userId;
                  final showAvatar = prevMsg == null || prevMsg.senderId != msg.senderId;

                  return _buildAnimatedMessage(
                    msg: msg,
                    isMe: isMe,
                    showAvatar: showAvatar,
                    context: context,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF5F5F5),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF757575),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE91E63).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _sendMessage,
                        borderRadius: BorderRadius.circular(22),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}