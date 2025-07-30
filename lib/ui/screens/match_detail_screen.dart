import 'package:fakelingo/core/dtos/swipe_dto.dart';
import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/core/services/swipe_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
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
  final ValueNotifier<SwipeDirection?> _swipeDirectionNotifier = ValueNotifier(null);
  final _swipeService = SwipeService();

  late List<SwipeItemModel> likedUsers;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    likedUsers = List.from(widget.likedUsers);
  }

  @override
  void dispose() {
    _controller.dispose();
    _swipeDirectionNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleSwipeAction(int index, SwipeDirection direction) async {
    if (index < 0 || index >= likedUsers.length) return;

    final swipedUser = likedUsers[index];
    String swipeType;

    switch (direction) {
      case SwipeDirection.left:
        swipeType = "LEFT";
        break;
      case SwipeDirection.right:
        swipeType = "RIGHT";
        break;
      default:
        return;
    }

    try {
      final swipeDto = SwipeDto(
        targetUserId: swipedUser.userId,
        type: swipeType,
      );

      await _swipeService.action(swipeDto);
      print('Swipe action sent successfully: ${swipeType} for user ${swipedUser.userId}');
    } catch (e) {
      print('Error sending swipe action: $e');
      if (mounted) {
        AnimatedToast.show(context, "Lỗi khi gửi swipe");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SwipePhotoProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Ai đã thích bạn (${likedUsers.length})',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: likedUsers.isEmpty
            ? const Center(child: Text("Không còn ai thích bạn"))
            : Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F9FA), Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
            ),
          ),
          child: SwipableStack(
            controller: _controller,
            detectableSwipeDirections: const {
              SwipeDirection.left,
              SwipeDirection.right,
              SwipeDirection.up,
            },
            onSwipeCompleted: (index, direction) async {
              if (index >= 0 && index < likedUsers.length) {
                await _handleSwipeAction(index, direction);

                Future.microtask(() {
                  if (mounted && index < likedUsers.length) {
                    setState(() {
                      likedUsers.removeAt(index);
                    });
                  }
                });
              }
              context.read<SwipePhotoProvider>().resetPhoto();
              _swipeDirectionNotifier.value = null;
            },
            itemCount: likedUsers.length,
            builder: (context, properties) {
              final item = likedUsers[properties.index];
              final direction = properties.direction;
              final progress = properties.swipeProgress;

              if (progress < 0.1 && _swipeDirectionNotifier.value != null) {
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
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                        color: Colors.white,
                        child: SwipeCard(
                          swipeItemModel: item,
                          controller: _controller,
                          swipeDirectionNotifier: _swipeDirectionNotifier,
                          showPrimaryDetail: true,
                        ),
                      ),
                    ),
                  ),
                  if (properties.stackIndex == 0 && direction != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
    );
  }
}
