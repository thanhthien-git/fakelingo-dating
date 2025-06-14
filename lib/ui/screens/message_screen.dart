import 'package:fakelingo/core/models/chat_item_model.dart';
import 'package:fakelingo/core/services/message_service.dart';
import 'package:fakelingo/core/services/socket_service.dart';
import 'package:fakelingo/ui/components/chat_item.dart';
import 'package:fakelingo/ui/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with TickerProviderStateMixin {
  final messageService = MessageService();
  final socketService = SocketService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<ChatList> _chatList = [];
  Set<String> _unreadConversations = {};
  Map<String, AnimationController> _itemAnimations = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupSocketListener();
  }

  Future<void> _loadInitialData() async {
    try {
      final chatList = await messageService.getChatList();
      setState(() {
        _chatList = chatList;
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() => _isLoading = false);
    }
  }

  void _setupSocketListener() {
    socketService.socket.on('receive_message', (data) {
      if (data is Map<String, dynamic>) {
        _handleNewMessage(data);
      }
    });
  }

  void _handleNewMessage(Map<String, dynamic> messageData) {
    final conversationId = messageData['conversationId'] as String?;
    final content = messageData['content'] as String?;

    if (conversationId == null || content == null) return;

    setState(() {
      _unreadConversations.add(conversationId);

      final existingIndex = _chatList.indexWhere(
              (chat) => chat.conversationId == conversationId
      );

      if (existingIndex != -1) {
        // Update existing conversation
        final updatedChat = _updateChatContent(_chatList[existingIndex], content);

        if (existingIndex == 0) {
          // Already at top, just update content
          _chatList[0] = updatedChat;
        } else {
          // Move to top with animation
          _chatList.removeAt(existingIndex);
          _chatList.insert(0, updatedChat);
          _animateItemToTop(existingIndex);
        }
      } else {
        // New conversation - refresh list
        _refreshChatListSilently();
      }
    });

    // Trigger notification animation
    _showNewMessageNotification(conversationId);
  }

  ChatList _updateChatContent(ChatList originalChat, String newContent) {
    // Điều chỉnh theo cấu trúc ChatList thực tế
    return ChatList(
      conversationId: originalChat.conversationId,
      user: originalChat.user,
      lastMessageContent: newContent,
    );
  }

  void _animateItemToTop(int fromIndex) {
    // Animate item moving to top
    if (_listKey.currentState != null) {
      _listKey.currentState!.removeItem(
        fromIndex,
            (context, animation) => Container(),
        duration: const Duration(milliseconds: 200),
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_listKey.currentState != null) {
          _listKey.currentState!.insertItem(0);
        }
      });
    }
  }

  void _showNewMessageNotification(String conversationId) {
    // Create animation controller for this specific item
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _itemAnimations[conversationId] = controller;
    controller.forward();

    // Remove animation after completion
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _itemAnimations.remove(conversationId);
          controller.dispose();
        });
      }
    });
  }

  Future<void> _refreshChatList() async {
    setState(() => _isLoading = true);
    await _loadInitialData();
  }

  Future<void> _refreshChatListSilently() async {
    try {
      final newChatList = await messageService.getChatList();
      setState(() {
        _chatList = newChatList;
      });
    } catch (err) {
      print(err);
    }
  }

  void _markAsRead(String conversationId) {
    setState(() {
      _unreadConversations.remove(conversationId);
    });

    // Remove animation if exists
    final controller = _itemAnimations[conversationId];
    if (controller != null) {
      controller.stop();
      _itemAnimations.remove(conversationId);
      controller.dispose();
    }
  }

  @override
  void dispose() {
    socketService.socket.off('receive_message');
    // Dispose all animation controllers
    for (var controller in _itemAnimations.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with unread count
            _buildHeader(),

            // Chat list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildChatList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final unreadCount = _unreadConversations.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (_chatList.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshChatList,
      color: Colors.white,
      backgroundColor: Colors.black,
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _chatList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index, animation) {
          if (index >= _chatList.length) return Container();

          final chat = _chatList[index];
          final isUnread = _unreadConversations.contains(chat.conversationId);
          final itemAnimation = _itemAnimations[chat.conversationId];

          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: _buildChatItem(chat, isUnread, itemAnimation),
          );
        },
      ),
    );
  }

  Widget _buildChatItem(ChatList chat, bool isUnread, AnimationController? itemAnimation) {
    Widget chatItem = EnhancedChatItem(
      data: chat,
      isUnread: isUnread,
      onTap: (conversationId) {
        _markAsRead(conversationId);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, animation, __) => ChatBoxScreen(
              conversationId: conversationId,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOut)),
                ),
                child: child,
              );
            },
          ),
        );
      },
    );

    // Add glow animation for new messages
    if (itemAnimation != null) {
      return AnimatedBuilder(
        animation: itemAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3 * itemAnimation.value),
                  blurRadius: 20 * itemAnimation.value,
                  spreadRadius: 2 * itemAnimation.value,
                ),
              ],
            ),
            child: chatItem,
          );
        },
      );
    }

    return chatItem;
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline,
                    color: Colors.white54, size: 72),
                const SizedBox(height: 16),
                const Text(
                  'You have no chats yet',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Match someone to see it here.',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Enhanced ChatItem với hiệu ứng đẹp
class EnhancedChatItem extends StatefulWidget {
  final ChatList data;
  final bool isUnread;
  final void Function(String conversationId)? onTap;

  const EnhancedChatItem({
    super.key,
    required this.data,
    required this.isUnread,
    this.onTap,
  });

  @override
  State<EnhancedChatItem> createState() => _EnhancedChatItemState();
}

class _EnhancedChatItemState extends State<EnhancedChatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isUnread) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EnhancedChatItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUnread != oldWidget.isUnread) {
      if (widget.isUnread) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isUnread ? _pulseAnimation.value : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: widget.isUnread ? 8 : 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.isUnread ? 16 : 8),
              color: widget.isUnread
                  ? Colors.blue.withOpacity(0.08)
                  : Colors.transparent,
              border: widget.isUnread
                  ? Border.all(color: Colors.blue.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.isUnread ? 16 : 8),
              onTap: () => widget.onTap?.call(widget.data.conversationId),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Expanded(child: _buildChatInfo()),
                    _buildTrailing(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(widget.data.user.avatar ?? ""),
        ),
        if (widget.isUnread)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.data.user.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: widget.isUnread ? FontWeight.w900 : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (widget.isUnread)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.data.lastMessageContent ?? 'Say some words👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.isUnread
                ? Colors.white.withOpacity(0.9)
                : Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: widget.isUnread ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    return AnimatedRotation(
      turns: widget.isUnread ? 0.1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Icon(
        Icons.chevron_right,
        color: widget.isUnread ? Colors.white70 : Colors.white38,
        size: widget.isUnread ? 24 : 20,
      ),
    );
  }
}