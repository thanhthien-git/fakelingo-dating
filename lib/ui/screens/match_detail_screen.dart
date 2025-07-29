import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/ui/components/card_overlay.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class MatchDetailScreen extends StatefulWidget {
  final List<SwipeItemModel> likedUsers;
  final int initialIndex;

  const MatchDetailScreen({
    Key? key,
    required this.likedUsers,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late final SwipableStackController _controller;
  final ValueNotifier<SwipeDirection?> _swipeDirectionNotifier = ValueNotifier(
    null,
  );

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    // ❌ KHÔNG cần gọi next nữa
  }

  @override
  void dispose() {
    _controller.dispose();
    _swipeDirectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SwipePhotoProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFF8E91),
                  Color(0xFFFFA07A),
                ],
              ),
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ai đã thích bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.likedUsers.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  // Add info action here
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F9FA), Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF6B9D).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFA07A).withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main content
              Column(
                children: [
                  // Progress indicator
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _swipeDirectionNotifier,
                      builder: (context, direction, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFFA07A),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Swipe để khám phá',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8E8E93),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.swipe,
                                          size: 14,
                                          color: Color(0xFFFF6B9D),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          direction != null
                                              ? (direction ==
                                                      SwipeDirection.right
                                                  ? '→ Thích'
                                                  : direction ==
                                                      SwipeDirection.left
                                                  ? '← Bỏ qua'
                                                  : '↑ Super Like')
                                              : 'Vuốt để tương tác',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                direction != null
                                                    ? const Color(0xFFFF6B9D)
                                                    : const Color(0xFF1C1C1E),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // SwipableStack with enhanced container
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: SwipableStack(
                        controller: _controller,
                        detectableSwipeDirections: const {
                          SwipeDirection.left,
                          SwipeDirection.right,
                          SwipeDirection.up,
                        },
                        onSwipeCompleted: (index, direction) {
                          context.read<SwipePhotoProvider>().resetPhoto();
                          _swipeDirectionNotifier.value = null;
                        },
                        itemCount: widget.likedUsers.length,
                        builder: (context, properties) {
                          final item = widget.likedUsers[properties.index];

                          // Xử lý overlay direction
                          final direction = properties.direction;
                          final progress = properties.swipeProgress;

                          if (progress < 0.1 &&
                              _swipeDirectionNotifier.value != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _swipeDirectionNotifier.value = null;
                            });
                          }

                          if (direction != null &&
                              _swipeDirectionNotifier.value != direction &&
                              progress > 0.3) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _swipeDirectionNotifier.value = direction;
                            });
                          }

                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -5,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: SwipeCard(
                                      swipeItemModel: item,
                                      controller: _controller,
                                      swipeDirectionNotifier:
                                          _swipeDirectionNotifier,
                                      showPrimaryDetail: true,
                                    ),
                                  ),
                                ),
                              ),
                              if (properties.stackIndex == 0 &&
                                  direction != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 20,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: CardOverlay(
                                      swipeProgress: progress,
                                      direction: direction,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Bottom instruction panel
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String label,
    required Color color,
    required String direction,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            direction,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
