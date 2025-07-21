import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/ui/components/bottom_button_row.dart';
import 'package:fakelingo/ui/components/card_overlay.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

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
  void _listenController() => setState(() {});

  final List<SwipeItemModel> _listItem = [
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Person1',
      age: 20,
      description: "Tôi là người hướng nội và yêu chó mèo.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      basicInfo: BasicInfoModel(
        distance: 4,
        height: 170,
        gender: "Male",
        zodiac: "Song Ngư",
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/2.png', 'assets/2.png', 'assets/2.png'],
      name: 'Person2',
      age: 22,
      description: "description 2",
    ),
    SwipeItemModel(
      imageUrls: ['assets/3.png', 'assets/3.png', 'assets/3.png'],
      name: 'Person3',
      age: 20,
      description: "description 3",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_listenController)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 34,
          child: Stack(
            children: [
              SwipableStack(
                detectableSwipeDirections: const {
                  SwipeDirection.right,
                  SwipeDirection.left,
                  SwipeDirection.up,
                },
                controller: _controller,
                stackClipBehaviour: Clip.none,
                overlayBuilder: (context, swipeProperty) {
                  final direction = swipeProperty.direction;
                  final progress = swipeProperty.swipeProgress;

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

                  return const SizedBox();
                },
                onSwipeCompleted: (index, direction) {
                  _swipeDirectionNotifier.value = null;
                  context.read<SwipePhotoProvider>().resetPhoto();
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
            ],
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: BottomButtonsRow(
            isShortRow: false,
            onSwipe: (direction) {
              _controller.next(swipeDirection: direction);
            },
            onRewindTap: _controller.rewind,
            canRewind: _controller.canRewind,
            swipeDirectionNotifier: _swipeDirectionNotifier,
          ),
        ),
      ],
    );
  }
}
