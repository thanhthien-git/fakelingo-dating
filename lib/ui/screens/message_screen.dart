import 'package:fakelingo/core/models/chat_item_model.dart';
import 'package:fakelingo/core/services/message_service.dart';
import 'package:fakelingo/core/services/socket_service.dart';
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

  // Tinder color scheme
  static const Color tinderPrimary = Color(0xFFFF4458);
  static const Color tinderSecondary = Color(0xFFFF6B7A);
  static const Color tinderGold = Color(0xFFFFD700);
  static const Color tinderBackground = Color(0xFFFAFAFA);
  static const Color tinderCardBg = Color(0xFFFFFFFF);

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
        final updatedChat = _updateChatContent(_chatList[existingIndex], content);

        if (existingIndex == 0) {
          _chatList[0] = updatedChat;
        } else {
          _chatList.removeAt(existingIndex);
          _chatList.insert(0, updatedChat);
          _animateItemToTop(existingIndex);
        }
      } else {
        _refreshChatListSilently();
      }
    });

    _showNewMessageNotification(conversationId);
  }

  ChatList _updateChatContent(ChatList originalChat, String newContent) {
    return ChatList(
      conversationId: originalChat.conversationId,
      user: originalChat.user,
      lastMessageContent: newContent,
    );
  }

  void _animateItemToTop(int fromIndex) {
    if (_listKey.currentState != null) {
      _listKey.currentState!.removeItem(
        fromIndex,
            (context, animation) => Container(),
        duration: const Duration(milliseconds: 300),
      );

      Future.delayed(const Duration(milliseconds: 150), () {
        if (_listKey.currentState != null) {
          _listKey.currentState!.insertItem(0);
        }
      });
    }
  }

  void _showNewMessageNotification(String conversationId) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _itemAnimations[conversationId] = controller;
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500), () {
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
    for (var controller in _itemAnimations.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tinderBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTinderHeader(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildChatList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTinderHeader() {
    final unreadCount = _unreadConversations.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tinder flame icon
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [tinderPrimary, tinderSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Messages',
            style: TextStyle(
              color: Color(0xFF424242),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          if (unreadCount > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [tinderPrimary, tinderSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: tinderPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(tinderPrimary),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildChatList() {
    if (_chatList.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshChatList,
      color: tinderPrimary,
      backgroundColor: Colors.white,
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _chatList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            child: FadeTransition(
              opacity: animation,
              child: _buildChatItem(chat, isUnread, itemAnimation),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatItem(ChatList chat, bool isUnread, AnimationController? itemAnimation) {
    Widget chatItem = TinderChatItem(
      data: chat,
      isUnread: isUnread,
      onTap: (conversationId) {
        _markAsRead(conversationId);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (_, animation, __) => ChatBoxScreen(
              conversationId: conversationId,
              targetUserId: chat.user.id,
              targetUsername: chat.user.username,
              displayName: chat.user.displayName,
              avatarUrl: chat.user.avatar,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutCubic)),
                ),
                child: FadeTransition(opacity: animation, child: child),
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
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: tinderPrimary.withOpacity(0.2 * itemAnimation.value),
                  blurRadius: 15 * itemAnimation.value,
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [tinderPrimary.withOpacity(0.1), tinderSecondary.withOpacity(0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: tinderPrimary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Start Matching',
                  style: TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Messages will appear here once you start\nmatching with people.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to main swipe screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tinderPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Start Swiping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TinderChatItem extends StatefulWidget {
  final ChatList data;
  final bool isUnread;
  final void Function(String conversationId)? onTap;

  const TinderChatItem({
    super.key,
    required this.data,
    required this.isUnread,
    this.onTap,
  });

  @override
  State<TinderChatItem> createState() => _TinderChatItemState();
}

class _TinderChatItemState extends State<TinderChatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  static const Color tinderPrimary = Color(0xFFFF4458);
  static const Color tinderSecondary = Color(0xFFFF6B7A);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isUnread) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TinderChatItem oldWidget) {
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isUnread ? _scaleAnimation.value : (_isPressed ? 0.98 : 1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: widget.isUnread
                  ? Border.all(color: tinderPrimary.withOpacity(0.2), width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: widget.isUnread
                      ? tinderPrimary.withOpacity(0.08)
                      : const Color(0x08000000),
                  blurRadius: widget.isUnread ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => widget.onTap?.call(widget.data.conversationId),
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildTinderAvatar(),
                      const SizedBox(width: 16),
                      Expanded(child: _buildChatInfo()),
                      _buildTrailing(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTinderAvatar() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isUnread ? tinderPrimary : Colors.grey.shade300,
              width: widget.isUnread ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isUnread
                    ? tinderPrimary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                blurRadius: widget.isUnread ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(widget.data.user.avatar ?? ""),
          ),
        ),
        if (widget.isUnread)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [tinderPrimary, tinderSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: tinderPrimary.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
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
                  color: const Color(0xFF424242),
                  fontWeight: widget.isUnread ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.isUnread)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [tinderPrimary, tinderSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          widget.data.lastMessageContent ?? 'Say hello! 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.isUnread
                ? const Color(0xFF616161)
                : const Color(0xFF9E9E9E),
            fontSize: 15,
            fontWeight: widget.isUnread ? FontWeight.w500 : FontWeight.w400,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    return Icon(
      Icons.chevron_right_rounded,
      color: widget.isUnread ? tinderPrimary : const Color(0xFFBDBDBD),
      size: 24,
    );
  }
}