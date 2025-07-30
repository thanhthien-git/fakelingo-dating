import 'package:fakelingo/core/models/feed_condition.dart';
import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/core/services/feed_service.dart';
import 'package:fakelingo/core/services/swipe_service.dart';
import 'package:fakelingo/core/dtos/swipe_dto.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/bottom_button_row.dart';
import 'package:fakelingo/ui/components/card_overlay.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:fakelingo/ui/components/filter_feed.dart';

class SwiperHome extends StatefulWidget {
  const SwiperHome({Key? key}) : super(key: key);

  @override
  _SwiperHomeState createState() => _SwiperHomeState();
}

class _SwiperHomeState extends State<SwiperHome> {
  late final SwipableStackController _controller;
  final ValueNotifier<SwipeDirection?> _swipeDirectionNotifier = ValueNotifier(
    null,
  );
  List<SwipeItemModel> _listItem = [];
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  // Add SwipeService instance
  final SwipeService _swipeService = SwipeService();

  // Track programmatic swipes to avoid duplicate API calls
  bool _isProgrammaticSwipe = false;

  // Track if we're currently processing a swipe to prevent spam
  bool _isProcessingSwipe = false;

  FeedCondition _currentFilter = FeedCondition(
    ageMax: 30,
    ageMin: 20,
    maxDistance: 10,
    coordinates: [106.700981, 10.779783],
    gender: 'F',
  );

  void _fetchFeed() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final feedService = FeedService();
      final users = await feedService.getFeedByCondition(_currentFilter);

      final items = users
          .where((user) => user.profile != null)
          .map((user) => SwipeItemModel.fromUser(user))
          .toList();

      setState(() {
        _listItem = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = 'Không thể tải dữ liệu. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _handleSwipeAction(int index, SwipeDirection direction) async {
    if (index < 0 || index >= _listItem.length) {
      print('Invalid index: $index, list length: ${_listItem.length}');
      return;
    }

    if (_isProcessingSwipe) {
      print('Already processing a swipe, ignoring...');
      return;
    }

    setState(() {
      _isProcessingSwipe = true;
    });

    final swipedUser = _listItem[index];
    String swipeType;

    switch (direction) {
      case SwipeDirection.left:
        swipeType = "LEFT";
        break;
      case SwipeDirection.right:
        swipeType = "RIGHT";
        break;
      default:
        setState(() {
          _isProcessingSwipe = false;
        });
        return; // Don't handle up swipes or other directions
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
        AnimatedToast.show(context, "lỗi");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingSwipe = false;
        });
      }
    }
  }

  void _onApplyFilters(FeedCondition newCondition) {
    setState(() {
      _currentFilter = newCondition;
    });
    _fetchFeed();
  }

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    _fetchFeed();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_listenController)
      ..dispose();
    _swipeDirectionNotifier.dispose();
    super.dispose();
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade100,
            Colors.orange.shade100,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đang tìm kiếm...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chúng tôi đang tìm những người phù hợp với bạn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade100,
            Colors.orange.shade100,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFeed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade100,
            Colors.orange.shade100,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.pink,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không còn ai nữa!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn đã xem hết tất cả người dùng trong khu vực',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchFeed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Discover',
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.grey),
            onPressed: () {
              context.showFilterModal(_currentFilter, _onApplyFilters);
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _isError
          ? _buildErrorState()
          : _listItem.isEmpty
          ? _buildEmptyState()
          : Stack(
        children: [
          // Main swipe area
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            bottom: 100,
            child: SwipableStack(
              detectableSwipeDirections: const {
                SwipeDirection.right,
                SwipeDirection.left,
     SwipeDirection.up,
    },
  controller: _controller,
  stackClipBehaviour: Clip.none,
              // Disable swipe gestures when processing
              allowVerticalSwipe: !_isProcessingSwipe,
              // allowHorizontalSwipe: !_isProcessingSwipe,
              overlayBuilder: (context, swipeProperty) {
                final direction = swipeProperty.direction;
                final progress = swipeProperty.swipeProgress;

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

                return const SizedBox();
              },
              onSwipeCompleted: (index, direction) async {
                _swipeDirectionNotifier.value = null;
                context.read<SwipePhotoProvider>().resetPhoto();

                // Only call API if this is NOT a programmatic swipe (from button)
                if (!_isProgrammaticSwipe) {
                  await _handleSwipeAction(index, direction);
                }

                // Reset the flag after handling
                _isProgrammaticSwipe = false;

                final remainingCards = _listItem.length - index - 1;

                if (remainingCards <= 0) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      _fetchFeed();
                    }
                  });
                }

              },
              horizontalSwipeThreshold: 0.8,
              verticalSwipeThreshold: 0.8,
              builder: (context, properties) {
                final item = _listItem[properties.index % _listItem.length];

                return Stack(
                  children: [
                    SwipeCard(
                      swipeItemModel: item,
                      controller: _controller,
                      swipeDirectionNotifier: _swipeDirectionNotifier,
                      showArrowUpIcon: true,
                      showPrimaryDetail: true,
                      // Disable card interactions when processing
                    ),

                    if (properties.stackIndex == 0 &&
                        properties.direction != null)
                      CardOverlay(
                        swipeProgress: properties.swipeProgress,
                        direction: properties.direction!,
                      ),
                  ],
                );
              },
            ),
          ),

          // Bottom buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: BottomButtonsRow(
              isShortRow: false,
              // Disable buttons when processing swipe
              isDisabled: _isProcessingSwipe,
              onSwipe: (direction) async {
                // Prevent action if already processing
                if (_isProcessingSwipe) return;

                // Get current card index
                final currentIndex = _controller.currentIndex;

                // Set flag to indicate this is a programmatic swipe
                _isProgrammaticSwipe = true;

                // Call API first for button swipes
                if (currentIndex >= 0 && currentIndex < _listItem.length) {
                  await _handleSwipeAction(currentIndex, direction);
                }

                // Only trigger animation if API was successful (not processing anymore)
                if (!_isProcessingSwipe) {
                  _controller.next(swipeDirection: direction);
                }
              },
              onRewindTap: _controller.rewind,
              canRewind: _controller.canRewind && !_isProcessingSwipe,
              swipeDirectionNotifier: _swipeDirectionNotifier,
            ),
          ),
        ],
      ),
    );
  }
}