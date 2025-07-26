  import 'package:fakelingo/ui/components/card_overlay.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
  import 'package:flutter/material.dart';
  import 'package:swipable_stack/swipable_stack.dart';
  import 'package:fakelingo/core/models/swipe_item_model.dart';
  import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
  import 'package:provider/provider.dart';

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
    final ValueNotifier<SwipeDirection?> _swipeDirectionNotifier =
        ValueNotifier(null);

    @override
    void initState() {
      super.initState();
      _controller = SwipableStackController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Jump đến vị trí initialIndex (hack nhẹ)
        for (int i = 0; i < widget.initialIndex; i++) {
          _controller.next(swipeDirection: SwipeDirection.right);
        }
      });
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text("Chi tiết người đã thích bạn"),
          ),
          body:SwipableStack(
  controller: _controller,
  detectableSwipeDirections: const {
    SwipeDirection.left,
    SwipeDirection.right,
  },
  overlayBuilder: (context, properties) {
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

    return properties.index == 0 && direction != null
        ? CardOverlay(
            swipeProgress: progress,
            direction: direction,
          )
        : const SizedBox.shrink();
  },
  onSwipeCompleted: (index, direction) {
    // Reset ảnh về index 0 khi chuyển người
    final photoProvider =
        Provider.of<SwipePhotoProvider>(context, listen: false);
    photoProvider.resetPhoto();
    _swipeDirectionNotifier.value = null;
  },
  itemCount: widget.likedUsers.length,
  builder: (context, properties) {
    final item = widget.likedUsers[properties.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SwipeCard(
        swipeItemModel: item,
        controller: _controller,
        swipeDirectionNotifier: _swipeDirectionNotifier,
        showPrimaryDetail: true,
      ),
    );
  },
),
        ),
      );
    }
  }
