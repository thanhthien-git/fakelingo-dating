import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/ui/components/action_button_home.dart';
import 'package:fakelingo/ui/components/card_overlay.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      imageUrl: 'assets/1.png',
      name: 'Person1',
      age: 20,
      description:
          "description 1description 1description 1description 1description 1description 1description 1description 1",
    ),
    SwipeItemModel(
      imageUrl: 'assets/2.png',
      name: 'Person2',
      age: 22,
      description: "description 2",
    ),
    SwipeItemModel(
      imageUrl: 'assets/3.png',
      name: 'Person3',
      age: 20,
      description: "description 3",
    ),
    SwipeItemModel(
      imageUrl: 'assets/1.png',
      name: 'Person1',
      age: 20,
      description: "description 1",
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
    return Column(
      children: [
        Expanded(
          child: SwipableStack(
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
            },
            horizontalSwipeThreshold: 0.8,
            verticalSwipeThreshold: 0.8,
            builder: (context, properties) {
              if (_listItem.isEmpty) {
                Center(child: Text("No data"));
              }
              final itemIndex = properties.index % _listItem.length;
              final item = _listItem[itemIndex];
              return Stack(
                children: [
                  SwipeCard(
                    name: item.name,
                    assetPath: item.imageUrl,
                    age: item.age,
                    description: item.description,
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
        BottomButtonsRow(
          onSwipe: (direction) {
            _controller.next(swipeDirection: direction);
          },
          onRewindTap: _controller.rewind,
          canRewind: _controller.canRewind,
          swipeDirectionNotifier: _swipeDirectionNotifier,
        ),
      ],
    );
  }
}
