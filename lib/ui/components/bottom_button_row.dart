import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:fakelingo/ui/components/action_button.dart';

class BottomButtonsRow extends StatelessWidget {
  final void Function(SwipeDirection direction) onSwipe;
  final VoidCallback onRewindTap;
  final bool canRewind;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;
  final bool isShortRow;
  const BottomButtonsRow({
    Key? key,
    required this.onSwipe,
    required this.onRewindTap,
    required this.canRewind,
    required this.swipeDirectionNotifier,
    this.isShortRow=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SwipeDirection?>(
      valueListenable: swipeDirectionNotifier,
      builder: (context, direction, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(!isShortRow)
              _buildSlot(
                show: direction == null,
                width: 48,
                height: 48,
                child: ActionTinderIconButton(
                  direction: SwipeDirection.left,
                  swipeDirection: direction,
                  icon: Icons.undo,
                  width: 48,
                  height: 48,
                  inActiveColor: canRewind ? Colors.orange : Colors.grey,
                  activeColor: Colors.orange,
                  activeIcon: Colors.white,
                  inActiveIcon: Colors.white,
                  onTap: canRewind ? onRewindTap : null,
                ),
              ),
              _buildSlot(
                show: direction == null || direction == SwipeDirection.left,
                width: 64,
                height: 64,
                child: ActionTinderIconButton(
                  direction: SwipeDirection.left,
                  swipeDirection: direction,
                  icon: Icons.close,
                  width: 64,
                  height: 64,
                  inActiveColor: Colors.white,
                  activeColor: Colors.red,
                  activeIcon: Colors.white,
                  inActiveIcon: Colors.red,
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    onSwipe(SwipeDirection.left);
                  },
                ),
              ),
              _buildSlot(
                show: direction == null || direction == SwipeDirection.up,
                width: 48,
                height: 48,
                child: ActionTinderIconButton(
                  direction: SwipeDirection.up,
                  swipeDirection: direction,
                  icon: Icons.star,
                  width: 48,
                  height: 48,
                  inActiveColor: Colors.white,
                  activeColor: Colors.blue,
                  activeIcon: Colors.white,
                  inActiveIcon: Colors.blue,
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    onSwipe(SwipeDirection.up);
                  },
                ),
              ),
              _buildSlot(
                show: direction == null || direction == SwipeDirection.right,
                width: 64,
                height: 64,
                child: ActionTinderIconButton(
                  direction: SwipeDirection.right,
                  swipeDirection: direction,
                  icon: Icons.favorite,
                  width: 64,
                  height: 64,
                  inActiveColor: Colors.white,
                  activeColor: Colors.green,
                  activeIcon: Colors.white,
                  inActiveIcon: Colors.green,
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    onSwipe(SwipeDirection.right);
                  },
                ),
              ),
              if(!isShortRow)
              _buildSlot(
                show: direction == null,
                width: 48,
                height: 48,
                child: ActionTinderIconButton(
                  direction: SwipeDirection.right,
                  swipeDirection: direction,
                  icon: Icons.flash_on,
                  width: 48,
                  height: 48,
                  inActiveColor: Colors.white,
                  activeColor: Colors.purple,
                  activeIcon: Colors.white,
                  inActiveIcon: Colors.purple,
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlot({
    required bool show,
    required Widget child,
    required double width,
    required double height,
  }) {
    return show ? child : SizedBox(width: width, height: height);
  }
}
