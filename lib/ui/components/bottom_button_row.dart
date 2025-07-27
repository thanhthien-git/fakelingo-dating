import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:fakelingo/ui/components/action_button.dart';

class BottomButtonsRow extends StatelessWidget {
  final void Function(SwipeDirection direction) onSwipe;
  final VoidCallback onRewindTap;
  final bool canRewind;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;
  final bool isShortRow;
  final bool isDisabled; // Add this property

  const BottomButtonsRow({
    Key? key,
    required this.onSwipe,
    required this.onRewindTap,
    required this.canRewind,
    required this.swipeDirectionNotifier,
    this.isShortRow = false,
    this.isDisabled = false, // Add this parameter
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
              if (!isShortRow)
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
                    inActiveColor: isDisabled ? Colors.grey.shade300 : Colors.white,
                    activeColor: isDisabled ? Colors.grey.shade400 : Colors.red,
                    activeIcon: Colors.white,
                    inActiveIcon: isDisabled ? Colors.grey.shade500 : Colors.red,
                    onTap: isDisabled ? null : () async {
                      await Future.delayed(Duration(milliseconds: 500));
                      onSwipe(SwipeDirection.left);
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
                  inActiveColor: isDisabled ? Colors.grey.shade300 : Colors.white,
                  activeColor: isDisabled ? Colors.grey.shade400 : Colors.green,
                  activeIcon: Colors.white,
                  inActiveIcon: isDisabled ? Colors.grey.shade500 : Colors.green,
                  onTap: isDisabled ? null : () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    onSwipe(SwipeDirection.right);
                  },
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